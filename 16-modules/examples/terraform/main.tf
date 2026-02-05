module "acr" {
  source = "./modules/acr"

  resource_group_name = "rg-demo-modules"
  location            = "UK South"
  acr_name            = "acrdemo"
  acr_sku             = "Standard"
  acr_admin_enabled   = true
}