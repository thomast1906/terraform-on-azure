locals {
  # String manipulation functions
  clean_app_name = lower(replace(var.app_name, " ", "-"))
  app_name_upper = upper(var.app_name)
  
  # Format function for building names
  resource_group_name = format("rg-%s-%s", var.environment, local.clean_app_name)
  
  # Create storage account name (max 24 chars, alphanumeric only)
  storage_base = replace(local.clean_app_name, "-", "")
  storage_name = substr("st${var.environment}${local.storage_base}", 0, 24)
  
  # Collection functions - merge tags
  common_tags = {
    Environment = title(var.environment)  # Capitalize first letter
    Application = var.app_name
    ManagedBy   = "Terraform"
    Regions     = join(", ", var.regions)  # Join list into string
  }
  
  # Get primary region from list
  primary_region = element(var.regions, 0)
  secondary_region = length(var.regions) > 1 ? element(var.regions, 1) : null
  
  # Type conversion and conditionals
  is_production = lower(var.environment) == "prod"
  
  # Conditional replication type
  replication_type = local.is_production ? "GRS" : "LRS"
  account_tier     = local.is_production ? "Premium" : "Standard"
  
  # Collection functions - flatten nested lists
  all_region_combos = flatten([
    for env in ["dev", "prod"] : [
      for region in var.regions :
      "${env}-${region}"
    ]
  ])
  
  # Parse cost center using regex
  cost_center_number = can(regex("^CC-([0-9]{4})$", var.cost_center)) ? regex("^CC-([0-9]{4})$", var.cost_center)[0] : "0000"
  
  # Build resource tags with multiple merge operations
  resource_specific_tags = {
    Purpose    = "Demo Terraform Functions"
    CostCenter = var.cost_center
  }
  
  # Combine all tags
  all_tags = merge(local.common_tags, local.resource_specific_tags)
  
  # Use contains function for validation
  valid_regions     = ["uksouth", "ukwest", "northeurope", "westeurope"]
  primary_is_valid  = contains(local.valid_regions, local.primary_region)
  
  # Use lookup with default
  vm_sizes = {
    dev     = "Standard_B2s"
    staging = "Standard_D2s_v5"
    prod    = "Standard_D4s_v5"
  }
  vm_size = lookup(local.vm_sizes, var.environment, "Standard_B1s")
  
  # Create NSG rules using map
  nsg_rules = {
    allow_http = {
      priority  = 100
      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"
      port      = "80"
      name      = "AllowHTTP"
    }
    allow_https = {
      priority  = 110
      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"
      port      = "443"
      name      = "AllowHTTPS"
    }
    allow_ssh = {
      priority  = 120
      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"
      port      = "22"
      name      = "AllowSSH"
    }
  }
}

# Resource group
resource "azurerm_resource_group" "example" {
  name     = local.resource_group_name
  location = local.primary_region
  tags     = local.all_tags
}

# Storage account demonstrating multiple functions
resource "azurerm_storage_account" "example" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = local.replication_type
  
  enable_https_traffic_only = true
  min_tls_version          = "TLS1_2"
  
  tags = merge(
    local.all_tags,
    {
      ReplicationType = local.replication_type
      IsProduction    = tostring(local.is_production)
      StorageTier     = local.account_tier
    }
  )
}

# Virtual network
resource "azurerm_virtual_network" "example" {
  name                = format("vnet-%s-%s", var.environment, local.clean_app_name)
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  
  tags = local.all_tags
}

# Subnet
resource "azurerm_subnet" "example" {
  name                 = "subnet-default"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Network Security Group
resource "azurerm_network_security_group" "example" {
  name                = format("nsg-%s-%s", var.environment, local.clean_app_name)
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  
  tags = local.all_tags
}

# NSG Rules using for_each with map
resource "azurerm_network_security_rule" "example" {
  for_each = local.nsg_rules
  
  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = "*"
  destination_port_range      = each.value.port
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.example.name
}

# Associate NSG with subnet
resource "azurerm_subnet_network_security_group_association" "example" {
  subnet_id                 = azurerm_subnet.example.id
  network_security_group_id = azurerm_network_security_group.example.id
}

# Demonstrate parsing Azure resource IDs
locals {
  storage_id = azurerm_storage_account.example.id
  # Parse ID: /subscriptions/{sub}/resourceGroups/{rg}/providers/{provider}/{type}/{name}
  
  id_parts        = split("/", local.storage_id)
  subscription_id = length(local.id_parts) > 2 ? local.id_parts[2] : ""
  parsed_rg_name  = length(local.id_parts) > 4 ? local.id_parts[4] : ""
  parsed_sa_name  = length(local.id_parts) > 8 ? local.id_parts[8] : ""
  
  # Use regex to extract resource group
  rg_from_regex = can(regex(".*/resourceGroups/([^/]+)/.*", local.storage_id)) ? regex(".*/resourceGroups/([^/]+)/.*", local.storage_id)[0] : ""
}

# Build connection string using format
locals {
  connection_string = format(
    "DefaultEndpointsProtocol=https;AccountName=%s;AccountKey=%s;EndpointSuffix=core.windows.net",
    azurerm_storage_account.example.name,
    azurerm_storage_account.example.primary_access_key
  )
  
  # Base64 encode a script
  init_script = <<-EOT
    #!/bin/bash
    echo "Environment: ${var.environment}"
    echo "App: ${var.app_name}"
    apt-get update
  EOT
  
  encoded_script = base64encode(local.init_script)
}

# Create JSON configuration
locals {
  app_config = {
    environment      = var.environment
    app_name         = var.app_name
    regions          = var.regions
    storage_account  = azurerm_storage_account.example.name
    primary_endpoint = azurerm_storage_account.example.primary_blob_endpoint
  }
  
  app_config_json = jsonencode(local.app_config)
}
