# Test that dev environment uses correct SKUs
run "test_dev_environment" {
  command = plan

  variables {
    resource_group_name  = "rg-test-dev"
    location             = "uksouth"
    storage_account_name = "stdev"
    environment          = "dev"
  }

  assert {
    condition     = azurerm_storage_account.test.account_tier == "Standard"
    error_message = "Dev environment should use Standard tier"
  }

  assert {
    condition     = azurerm_storage_account.test.account_replication_type == "LRS"
    error_message = "Dev environment should use LRS replication"
  }

  assert {
    condition     = azurerm_resource_group.test.location == "uksouth"
    error_message = "Resource group should be in uksouth"
  }
}

# Test that prod environment uses premium features
run "test_prod_environment" {
  command = plan

  variables {
    resource_group_name  = "rg-test-prod"
    location             = "uksouth"
    storage_account_name = "stprod"
    environment          = "prod"
  }

  assert {
    condition     = azurerm_storage_account.test.account_tier == "Premium"
    error_message = "Prod environment should use Premium tier"
  }

  assert {
    condition     = azurerm_storage_account.test.account_replication_type == "GRS"
    error_message = "Prod environment should use GRS replication"
  }
}

# Test that security settings are enabled
run "test_security_settings" {
  command = plan

  variables {
    resource_group_name  = "rg-test-security"
    location             = "uksouth"
    storage_account_name = "stsec"
    environment          = "dev"
  }

  assert {
    condition     = azurerm_storage_account.test.https_traffic_only_enabled == true
    error_message = "HTTPS traffic should be enforced"
  }

  assert {
    condition     = azurerm_storage_account.test.min_tls_version == "TLS1_2"
    error_message = "Minimum TLS version should be 1.2"
  }
}

# Test that tags are applied correctly
run "test_resource_tags" {
  command = plan

  variables {
    resource_group_name  = "rg-test-tags"
    location             = "uksouth"
    storage_account_name = "sttags"
    environment          = "staging"
  }

  assert {
    condition     = azurerm_resource_group.test.tags["Environment"] == "staging"
    error_message = "Environment tag should match variable"
  }

  assert {
    condition     = azurerm_resource_group.test.tags["ManagedBy"] == "Terraform"
    error_message = "ManagedBy tag should be set to Terraform"
  }

  assert {
    condition     = azurerm_storage_account.test.tags["Environment"] == "staging"
    error_message = "Storage account should inherit resource group tags"
  }
}

# Test validation rules
run "test_invalid_environment" {
  command = plan

  variables {
    resource_group_name  = "rg-test-invalid"
    location             = "uksouth"
    storage_account_name = "stinvalid"
    environment          = "test"  # Invalid value
  }

  expect_failures = [
    var.environment
  ]
}

# Integration test with actual deployment
run "test_deployment" {
  command = apply

  variables {
    resource_group_name  = "rg-terratest-${run.suffix}"
    location             = "uksouth"
    storage_account_name = "sttest"
    environment          = "dev"
  }

  assert {
    condition     = output.resource_group_name == "rg-terratest-${run.suffix}"
    error_message = "Resource group name should match expected value"
  }

  assert {
    condition     = length(output.storage_account_name) > 3
    error_message = "Storage account name should be at least 3 characters"
  }

  assert {
    condition     = output.storage_account_tier == "Standard"
    error_message = "Storage tier should be Standard for dev"
  }
}
