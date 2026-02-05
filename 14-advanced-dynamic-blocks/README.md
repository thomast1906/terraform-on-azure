# Use dynamic blocks

Dynamic blocks generate repeated nested blocks within a resource. Use them when you need multiple similar nested blocks with different values.

## Basic dynamic blocks

Some resources accept repeated nested blocks. Network security groups accept multiple security rules:

```terraform
resource "azurerm_network_security_group" "example" {
  name                = "nsg-demo"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "allow-https"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
```

This works but gets repetitive. Use a dynamic block instead:

```terraform
variable "security_rules" {
  description = "Security rules for NSG"
  type = list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = string
    destination_port_range     = string
    source_address_prefix      = string
    destination_address_prefix = string
  }))
  default = [
    {
      name                       = "allow-ssh"
      priority                   = 100
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "22"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    },
    {
      name                       = "allow-https"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "443"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  ]
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-demo"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  dynamic "security_rule" {
    for_each = var.security_rules
    content {
      name                       = security_rule.value.name
      priority                   = security_rule.value.priority
      direction                  = security_rule.value.direction
      access                     = security_rule.value.access
      protocol                   = security_rule.value.protocol
      source_port_range          = security_rule.value.source_port_range
      destination_port_range     = security_rule.value.destination_port_range
      source_address_prefix      = security_rule.value.source_address_prefix
      destination_address_prefix = security_rule.value.destination_address_prefix
    }
  }
}
```

The dynamic block:
- Uses `for_each` to iterate over a collection
- Has a label matching the nested block name (`security_rule`)
- Contains a `content` block defining the nested block structure
- References values with `security_rule.value`

## Simpler example with maps

```terraform
variable "allowed_ports" {
  description = "Ports to allow"
  type        = map(number)
  default = {
    ssh   = 22
    http  = 80
    https = 443
  }
}

resource "azurerm_network_security_group" "example" {
  name                = "nsg-demo"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  dynamic "security" {
    for_each = var.allowed_ports
    content {
      name                       = "allow-${security_rule.key}"
      priority                   = 100 + security_rule.value
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = security_rule.value
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
}
```

## When to use dynamic blocks

Use dynamic blocks when:
- A resource needs multiple similar nested blocks
- The number of blocks varies based on input
- Configuration comes from variables or data sources

Don't use dynamic blocks when:
- You have a fixed, small number of blocks (explicit blocks are clearer)
- The blocks are significantly different from each other
- It makes the code harder to read

## Try it yourself

```bash
cd 14-advanced-dynamic-blocks/examples/terraform
terraform init
terraform validate
terraform plan
terraform apply
terraform destroy
```
