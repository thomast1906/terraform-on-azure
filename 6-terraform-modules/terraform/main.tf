module "acr" {
  source = "./modules/acr"

  resource_group_name = "tamops"
  location            = "UK South"
  acr_name            = "tamopsacr"
  acr_sku             = "Standard"
  acr_admin_enabled   = true
}