# Basic validation tests that don't create actual resources
run "validate_resource_group_name" {
  command = plan
  
  variables {
    resource_group_name    = "test-rg-validation"
    location              = "East US"
    storage_account_name  = "teststorageacct123"
    environment           = "dev"
  }
  
  assert {
    condition     = azurerm_resource_group.test.name == "test-rg-validation"
    error_message = "Resource group name does not match expected value"
  }
  
  assert {
    condition     = azurerm_resource_group.test.location == "East US"
    error_message = "Resource group location does not match expected value"
  }
}

run "validate_tags" {
  command = plan
  
  variables {
    resource_group_name    = "test-rg-tags"
    location              = "East US"
    storage_account_name  = "teststorageacct456"
    environment           = "dev"
  }
  
  assert {
    condition     = azurerm_resource_group.test.tags.Environment == "dev"
    error_message = "Environment tag not set correctly"
  }
  
  assert {
    condition     = azurerm_resource_group.test.tags.ManagedBy == "Terraform"
    error_message = "ManagedBy tag not set correctly"
  }
  
  assert {
    condition     = azurerm_resource_group.test.tags.Purpose == "Terraform Testing"
    error_message = "Purpose tag not set correctly"
  }
}

run "validate_storage_account_settings" {
  command = plan
  
  variables {
    resource_group_name    = "test-rg-storage"
    location              = "East US"
    storage_account_name  = "teststorageacct789"
    environment           = "dev"
  }
  
  assert {
    condition     = azurerm_storage_account.test.account_tier == "Standard"
    error_message = "Storage account tier should be Standard"
  }
  
  assert {
    condition     = azurerm_storage_account.test.account_replication_type == "LRS"
    error_message = "Dev environment should use LRS replication"
  }
  
  assert {
    condition     = azurerm_storage_account.test.allow_nested_items_to_be_public == false
    error_message = "Storage account should not allow public nested items"
  }
  
  assert {
    condition     = azurerm_storage_account.test.min_tls_version == "TLS1_2"
    error_message = "Storage account should enforce TLS 1.2 minimum"
  }
}

run "validate_production_settings" {
  command = plan
  
  variables {
    resource_group_name    = "test-rg-prod"
    location              = "East US"
    storage_account_name  = "teststorageprod123"
    environment           = "prod"
  }
  
  assert {
    condition     = azurerm_storage_account.test.account_replication_type == "GRS"
    error_message = "Production environment should use GRS replication"
  }
  
  assert {
    condition     = azurerm_resource_group.test.tags.Environment == "prod"
    error_message = "Environment tag should be set to prod"
  }
}