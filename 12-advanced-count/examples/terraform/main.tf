resource "azurerm_resource_group" "rg" {
  count    = 3
  name     = "rg-demo-${count.index}"
  location = "uksouth"
  
  tags = {
    Index = count.index
  }
}