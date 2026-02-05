# Use Terraform functions

Terraform includes over 100 built-in functions for manipulating data. Master the most useful ones for Azure infrastructure.

## What are functions

Functions transform values. They take inputs and return outputs.

```terraform
upper("hello")  # Returns "HELLO"
length([1, 2, 3])  # Returns 3
```

Functions are pure: same inputs always return same outputs. No side effects.

## String functions

### upper and lower

Convert case:

```terraform
locals {
  env       = "Production"
  env_lower = lower(local.env)  # "production"
  env_upper = upper(local.env)  # "PRODUCTION"
}

resource "azurerm_resource_group" "example" {
  name     = "rg-${local.env_lower}"  # "rg-production"
  location = "uksouth"
}
```

### format

Build strings with placeholders:

```terraform
locals {
  env      = "dev"
  app_name = "webapp"
  location = "uksouth"
  
  # Format: %s for string, %d for number
  resource_name = format("rg-%s-%s-%s", local.env, local.app_name, local.location)
  # Result: "rg-dev-webapp-uksouth"
  
  vm_name = format("vm-%s-%02d", local.env, 5)
  # Result: "vm-dev-05" (zero-padded)
}
```

### join and split

Combine and separate strings:

```terraform
locals {
  regions = ["uksouth", "ukwest", "northeurope"]
  
  # Join with separator
  regions_string = join(", ", local.regions)
  # Result: "uksouth, ukwest, northeurope"
  
  # Split string into list
  connection_string = "Server=myserver;Database=mydb;User=admin"
  parts            = split(";", local.connection_string)
  # Result: ["Server=myserver", "Database=mydb", "User=admin"]
}
```

### regex and regexall

Match patterns:

```terraform
locals {
  resource_id = "/subscriptions/12345/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mystorageacct"
  
  # Extract resource group name
  rg_name = regex(".*/resourceGroups/([^/]+)/.*", local.resource_id)[0]
  # Result: "my-rg"
  
  # Extract all parts
  parts = regex(".*/(resourceGroups)/([^/]+)/.*/([^/]+)$", local.resource_id)
  # Result: ["resourceGroups", "my-rg", "mystorageacct"]
}

# Azure-specific: Parse connection string
locals {
  connection_string = "DefaultEndpointsProtocol=https;AccountName=mystorageacct;AccountKey=abc123;EndpointSuffix=core.windows.net"
  
  # Extract account name
  account_name = regex("AccountName=([^;]+)", local.connection_string)[0]
  # Result: "mystorageacct"
}
```

### replace

Replace substrings:

```terraform
locals {
  resource_name = "My Resource Name"
  
  # Replace spaces with hyphens
  sanitized = replace(local.resource_name, " ", "-")
  # Result: "My-Resource-Name"
  
  # Make lowercase and replace spaces
  final = lower(replace(local.resource_name, " ", "-"))
  # Result: "my-resource-name"
}
```

### trim, trimprefix, trimsuffix

Remove characters:

```terraform
locals {
  name_with_spaces = "  my-resource  "
  
  trimmed = trim(local.name_with_spaces, " ")
  # Result: "my-resource"
  
  # Remove prefix
  full_name = "rg-production-app"
  app_name  = trimprefix(local.full_name, "rg-")
  # Result: "production-app"
  
  # Remove suffix
  resource_with_type = "myvm-vm"
  clean_name        = trimsuffix(local.resource_with_type, "-vm")
  # Result: "myvm"
}
```

## Collection functions

### length

Count elements:

```terraform
locals {
  regions = ["uksouth", "ukwest", "northeurope"]
  
  region_count = length(local.regions)  # 3
  
  name = "production"
  name_length = length(local.name)  # 10
}
```

### concat

Combine lists:

```terraform
locals {
  dev_regions  = ["uksouth", "ukwest"]
  prod_regions = ["northeurope", "westeurope"]
  
  all_regions = concat(local.dev_regions, local.prod_regions)
  # Result: ["uksouth", "ukwest", "northeurope", "westeurope"]
}
```

### merge

Combine maps:

```terraform
locals {
  common_tags = {
    ManagedBy   = "Terraform"
    Department  = "Engineering"
  }
  
  env_tags = {
    Environment = "production"
    CostCenter  = "CC-1234"
  }
  
  all_tags = merge(local.common_tags, local.env_tags)
  # Result: All four tags combined
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = "uksouth"
  tags     = merge(local.common_tags, { Environment = "dev" })
}
```

### flatten

Convert nested lists to flat list:

```terraform
locals {
  environments = ["dev", "staging", "prod"]
  regions      = ["uksouth", "ukwest"]
  
  # Create nested list
  nested = [
    for env in local.environments : [
      for region in local.regions :
      "${env}-${region}"
    ]
  ]
  # Result: [["dev-uksouth", "dev-ukwest"], ["staging-uksouth", "staging-ukwest"], ...]
  
  # Flatten to single list
  flattened = flatten(local.nested)
  # Result: ["dev-uksouth", "dev-ukwest", "staging-uksouth", "staging-ukwest", ...]
}
```

### contains

Check if element exists:

```terraform
locals {
  approved_regions = ["uksouth", "ukwest", "northeurope"]
  requested_region = "uksouth"
  
  is_approved = contains(local.approved_regions, local.requested_region)
  # Result: true
}

resource "azurerm_resource_group" "example" {
  name     = "rg-example"
  location = var.location
  
  lifecycle {
    precondition {
      condition     = contains(["uksouth", "ukwest"], var.location)
      error_message = "Region must be uksouth or ukwest"
    }
  }
}
```

### keys and values

Extract from maps:

```terraform
locals {
  environments = {
    dev     = "uksouth"
    staging = "ukwest"
    prod    = "northeurope"
  }
  
  env_names = keys(local.environments)
  # Result: ["dev", "staging", "prod"]
  
  locations = values(local.environments)
  # Result: ["uksouth", "ukwest", "northeurope"]
}
```

### lookup

Get value from map with default:

```terraform
locals {
  vm_sizes = {
    dev     = "Standard_B2s"
    staging = "Standard_D2s_v5"
    prod    = "Standard_D4s_v5"
  }
  
  # Get value with default
  size = lookup(local.vm_sizes, "dev", "Standard_B1s")
  # Result: "Standard_B2s"
  
  # Non-existent key returns default
  size_unknown = lookup(local.vm_sizes, "test", "Standard_B1s")
  # Result: "Standard_B1s"
}

resource "azurerm_linux_virtual_machine" "example" {
  name = "vm-example"
  size = lookup(local.vm_sizes, var.environment, "Standard_B1s")
  
  # ... other configuration
}
```

### slice

Extract subset of list:

```terraform
locals {
  all_regions = ["uksouth", "ukwest", "northeurope", "westeurope", "francecentral"]
  
  # slice(list, start_index, end_index)
  primary_regions = slice(local.all_regions, 0, 2)
  # Result: ["uksouth", "ukwest"]
  
  last_two = slice(local.all_regions, 3, 5)
  # Result: ["westeurope", "francecentral"]
}
```

## Type conversion functions

### tostring, tonumber, tobool

Convert types:

```terraform
locals {
  # String to number
  port_string = "443"
  port_number = tonumber(local.port_string)  # 443
  
  # Number to string
  count_number = 5
  count_string = tostring(local.count_number)  # "5"
  
  # String to bool
  enabled_string = "true"
  enabled_bool   = tobool(local.enabled_string)  # true
}
```

### tolist, toset, tomap

Convert collections:

```terraform
locals {
  # Set (unique values) to list
  unique_regions = toset(["uksouth", "ukwest", "uksouth"])
  # Result: ["uksouth", "ukwest"]
  
  region_list = tolist(local.unique_regions)
  
  # Create map
  env_map = tomap({
    environment = "production"
    tier        = "standard"
  })
}
```

### can

Test if expression succeeds:

```terraform
locals {
  ip_address = "192.168.1.1"
  
  # Check if valid IP format
  is_valid_ip = can(regex("^[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}$", local.ip_address))
  # Result: true
  
  # Check if can convert to number
  value = "123"
  is_number = can(tonumber(local.value))  # true
  
  value_text = "abc"
  is_number2 = can(tonumber(local.value_text))  # false
}
```

### try

Return first expression that succeeds:

```terraform
locals {
  # Try to get value, fallback to default
  config = {
    # region key might not exist
  }
  
  region = try(local.config.region, "uksouth")
  # Returns "uksouth" if config.region doesn't exist
}
```

## Encoding functions

### base64encode and base64decode

Encode and decode base64:

```terraform
locals {
  script = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y nginx
  EOT
  
  # Encode for Azure custom data
  encoded_script = base64encode(local.script)
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "vm-example"
  # ...
  custom_data = base64encode(local.script)
}
```

### jsonencode and jsondecode

Convert to/from JSON:

```terraform
locals {
  # Encode object as JSON
  config = {
    server   = "myserver.database.windows.net"
    database = "mydb"
    port     = 1433
  }
  
  config_json = jsonencode(local.config)
  # Result: '{"server":"myserver.database.windows.net","database":"mydb","port":1433}'
  
  # Parse JSON string
  json_string = '{"environment":"prod","region":"uksouth"}'
  parsed      = jsondecode(local.json_string)
  environment = jsondecode(local.json_string)["environment"]  # "prod"
}
```

## Azure-specific examples

### Parse Azure resource IDs

```terraform
locals {
  storage_id = azurerm_storage_account.example.id
  # "/subscriptions/12345/resourceGroups/my-rg/providers/Microsoft.Storage/storageAccounts/mysa"
  
  # Extract parts
  subscription_id = split("/", local.storage_id)[2]
  resource_group  = split("/", local.storage_id)[4]
  storage_name    = split("/", local.storage_id)[8]
  
  # Or use regex
  rg_name = regex(".*/resourceGroups/([^/]+)/.*", local.storage_id)[0]
}
```

### Build connection strings

```terraform
locals {
  storage_account_name = azurerm_storage_account.example.name
  storage_account_key  = azurerm_storage_account.example.primary_access_key
  
  # Build connection string
  connection_string = format(
    "DefaultEndpointsProtocol=https;AccountName=%s;AccountKey=%s;EndpointSuffix=core.windows.net",
    local.storage_account_name,
    local.storage_account_key
  )
}
```

### Generate unique names

```terraform
locals {
  # Base name
  base_name = "mystorageacct"
  
  # Add hash of resource group ID for uniqueness
  unique_suffix = substr(
    sha256(azurerm_resource_group.example.id),
    0,
    8
  )
  
  storage_name = "${local.base_name}${local.unique_suffix}"
}
```

### Clean resource names

```terraform
locals {
  # User input with invalid characters
  raw_name = "My Storage Account!"
  
  # Clean: lowercase, remove special chars, truncate
  clean_name = substr(
    lower(
      replace(
        replace(local.raw_name, " ", ""),
        "/[^a-z0-9]/",
        ""
      )
    ),
    0,
    24
  )
  # Result: "mystorageaccount"
}
```

### Create multiple NSG rules

```terraform
locals {
  # Define rules
  nsg_rules = {
    allow_http = {
      priority  = 100
      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"
      port      = "80"
    }
    allow_https = {
      priority  = 110
      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"
      port      = "443"
    }
    allow_ssh = {
      priority  = 120
      direction = "Inbound"
      access    = "Allow"
      protocol  = "Tcp"
      port      = "22"
    }
  }
}

resource "azurerm_network_security_rule" "example" {
  for_each = local.nsg_rules
  
  name                        = each.key
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
```

### Combine tags

```terraform
locals {
  # Common tags
  common_tags = {
    ManagedBy   = "Terraform"
    Environment = var.environment
  }
  
  # Resource-specific tags
  storage_tags = merge(
    local.common_tags,
    {
      Purpose    = "Data Storage"
      Backup     = "Daily"
      CostCenter = var.cost_center
    }
  )
  
  # VM tags
  vm_tags = merge(
    local.common_tags,
    {
      Purpose = "Application Server"
      OS      = "Linux"
    }
  )
}

resource "azurerm_storage_account" "example" {
  # ...
  tags = local.storage_tags
}

resource "azurerm_linux_virtual_machine" "example" {
  # ...
  tags = local.vm_tags
}
```

## Complete example

Full working example using multiple functions:

```terraform
variable "environment" {
  type = string
}

variable "app_name" {
  type = string
}

variable "regions" {
  type    = list(string)
  default = ["uksouth", "ukwest"]
}

locals {
  # Clean app name
  clean_app_name = lower(replace(var.app_name, " ", "-"))
  
  # Build resource names
  resource_group_name = format("rg-%s-%s", var.environment, local.clean_app_name)
  
  # Create storage name (max 24 chars, alphanumeric only)
  storage_base = replace(local.clean_app_name, "-", "")
  storage_name = substr("st${var.environment}${local.storage_base}", 0, 24)
  
  # Common tags
  common_tags = {
    Environment = title(var.environment)
    Application = var.app_name
    ManagedBy   = "Terraform"
    Regions     = join(", ", var.regions)
  }
  
  # Get primary region
  primary_region = element(var.regions, 0)
  
  # Check if prod
  is_production = lower(var.environment) == "prod"
  
  # Conditional replication
  replication_type = local.is_production ? "GRS" : "LRS"
}

resource "azurerm_resource_group" "example" {
  name     = local.resource_group_name
  location = local.primary_region
  tags     = local.common_tags
}

resource "azurerm_storage_account" "example" {
  name                     = local.storage_name
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = local.replication_type
  
  tags = merge(
    local.common_tags,
    {
      Purpose = "Application Data"
      Tier    = local.is_production ? "Premium" : "Standard"
    }
  )
}

# Output parsed values
output "parsed_resource_id" {
  value = {
    subscription_id = split("/", azurerm_storage_account.example.id)[2]
    resource_group  = split("/", azurerm_storage_account.example.id)[4]
    storage_name    = split("/", azurerm_storage_account.example.id)[8]
  }
}
```

## Try the examples

```bash
cd 22-functions/examples
terraform init
terraform apply \
  -var="environment=dev" \
  -var="app_name=My Test App"
```

## Best practices

- Use locals for complex expressions so you do not repeat function calls.
- Comment complex logic, especially regex patterns.
- Use `can()` to validate inputs before applying transformations.
- Break complex nested functions into multiple locals.
- Test edge cases like empty strings, long strings, and special characters.

## Function reference

Full list at [terraform.io/language/functions](https://www.terraform.io/language/functions).

Common categories:
- String: upper, lower, format, replace, regex, trim, join, split
- Collection: length, concat, merge, flatten, contains, keys, values, lookup, slice
- Type: tostring, tonumber, tobool, tolist, toset, tomap, can, try
- Encoding: base64encode, jsonencode, yamlencode
- Filesystem: file, fileexists, templatefile
- Date: timestamp, formatdate
- Hash: md5, sha256, uuid
- Network: cidrhost, cidrsubnet

Explore them all to simplify your Terraform code.

## Use Terraform MCP server for function assistance

The Terraform MCP server helps you discover and use functions correctly.

### Set up MCP in VS Code

Add to your VS Code MCP settings (see [lesson 23](../23-mcp-server/) for full setup):

```json
{
  "mcpServers": {
    "terraform": {
      "command": "npx",
      "args": ["-y", "@terraform-mcp/server"]
    }
  }
}
```

### Ask about functions

With MCP enabled, ask GitHub Copilot:

**"What Terraform function can I use to remove spaces from a string?"**

Response:
```
Use replace() function:
replace(string, search, replace)

Example:
locals {
  name_with_spaces = "My Resource Name"
  clean_name = replace(local.name_with_spaces, " ", "-")
  # Result: "My-Resource-Name"
}
```

**"How do I extract a resource group name from an Azure resource ID?"**

Response:
```
Use regex() or split():

# With regex
rg_name = regex(".*/resourceGroups/([^/]+)/.*", resource_id)[0]

# With split
rg_name = split("/", resource_id)[4]
```

**"What function combines two maps in Terraform?"**

Response:
```
Use merge():

locals {
  common_tags = { ManagedBy = "Terraform" }
  env_tags = { Environment = "prod" }
  all_tags = merge(local.common_tags, local.env_tags)
}
```

### Get function documentation

Ask for detailed usage:

**"Show me all the parameters for the format() function"**

Response includes:
- Function signature
- Parameter types
- Return type
- Examples
- Common use cases

### Test function expressions

Ask MCP to validate function usage:

**"Will this work: `substr(var.name, 0, 24)`"**

MCP checks:
- Correct function name
- Right number of parameters
- Valid parameter types
- Returns explanation if invalid

### Discover functions for tasks

Ask high-level questions:

**"How can I create a unique storage account name from a resource group name?"**

Response suggests:
```terraform
locals {
  # Hash the resource group ID for uniqueness
  unique_suffix = substr(sha256(azurerm_resource_group.example.id), 0, 8)
  
  # Clean the name and add suffix
  storage_name = "${replace(lower(var.app_name), " ", "")}${local.unique_suffix}"
  
  # Ensure max 24 characters
  final_name = substr(local.storage_name, 0, 24)
}
```

### Get Azure-specific examples

**"How do I build an Azure SQL connection string in Terraform?"**

Response:
```terraform
locals {
  connection_string = format(
    "Server=tcp:%s.database.windows.net,1433;Database=%s;User ID=%s;Password=%s;Encrypt=yes;TrustServerCertificate=no;",
    azurerm_mssql_server.example.name,
    azurerm_mssql_database.example.name,
    var.admin_username,
    var.admin_password
  )
}
```

### Debug function errors

When you get errors like:

```
Error: Invalid function argument
  on main.tf line 5:
  5:   name = substr(var.storage_name)
```

Ask MCP:

**"Why is my substr() call failing?"**

Response:
```
substr() requires 3 arguments:
substr(string, offset, length)

You're missing offset and length.

Fix:
substr(var.storage_name, 0, 24)
```

### Learn function combinations

**"How do I create resource names for multiple regions?"**

Response shows combining functions:
```terraform
locals {
  regions = ["uksouth", "ukwest", "northeurope"]
  
  # Use for expression with format
  resource_groups = {
    for region in local.regions :
    region => format("rg-%s-%s", var.environment, region)
  }
  # Result: { uksouth = "rg-dev-uksouth", ... }
}
```

### MCP advantages for functions

- Get function documentation without leaving the editor.
- Request Azure-specific usage patterns.
- Validate syntax before running `terraform plan`.
- Discover the right function even if you do not know its name.
- Learn how to chain multiple functions together.

### Try it

```bash
# Open VS Code with MCP enabled
code .

# Ask Copilot Chat:
# "Show me how to use the flatten function with Azure regions"
# "What's the difference between merge and concat?"
# "How do I parse JSON in Terraform?"
```

MCP makes learning and using Terraform functions faster and more accurate.

## Next steps

You've completed all core Terraform on Azure tutorials. You now know how to:

- Deploy infrastructure with Terraform
- Manage state locally and remotely
- Use variables and modules
- Test and validate configurations
- Import existing resources
- Manipulate state safely
- Validate with pre/post-conditions
- Transform data with functions
- Accelerate development with MCP server

### Keep learning

- Build a real project (VMs, networking, storage, databases).
- Explore the Terraform modules registry: [registry.terraform.io/browse/modules](https://registry.terraform.io/browse/modules?provider=azurerm)
- Integrate Terraform with GitHub Actions or Azure DevOps.
- Study Azure Landing Zones for enterprise patterns.
- Join communities:
- [Terraform Discord](https://discord.gg/terraform)
- [HashiCorp Forum](https://discuss.hashicorp.com/c/terraform-core)
- [Azure Terraform GitHub](https://github.com/Azure/terraform-azurerm-examples)

Keep experimenting. The best way to learn is by building.

Return to [main README](../README.md) for the complete learning path.
