# Terraform Testing and Validation

Testing is a critical aspect of Infrastructure as Code (IaC) that ensures your Terraform configurations are reliable, secure, and follow best practices. This section covers modern testing approaches from basic validation to advanced testing frameworks.

## 🎯 Learning Objectives

By completing this section, you will learn how to:
- **Validate** Terraform syntax and configuration
- **Lint** code for best practices and style consistency
- **Test** infrastructure with automated frameworks
- **Integrate** testing into CI/CD pipelines
- **Implement** security scanning and compliance checks

## 📋 Prerequisites

- Completed sections 1-7 of this learning path
- Understanding of Terraform basics and Azure provider
- Familiarity with command-line tools
- Basic knowledge of testing concepts

## 🧪 Testing Pyramid for Terraform

Terraform testing follows a pyramid approach with different levels of validation:

```
    /\
   /  \        Integration Tests (Terratest, Kitchen-Terraform)
  /____\       
 /      \      Unit Tests (terraform plan, validate)
/________\     Static Analysis (tflint, checkov, terraform fmt)
```

## 1. Static Analysis and Formatting

### Terraform Native Commands

**Formatting and Syntax Validation**
```bash
# Format code according to Terraform standards
terraform fmt -recursive

# Check for syntax errors
terraform validate

# Show differences in formatting
terraform fmt -diff
```

**Configuration Validation**
```bash
# Validate configuration without accessing remote services
terraform validate

# Plan without applying (dry-run)
terraform plan
```

### tflint - Advanced Linting

[TFLint](https://github.com/terraform-linters/tflint) catches potential errors and enforces best practices.

**Installation**
```bash
# Linux/macOS
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash

# Windows (using Chocolatey)
choco install tflint

# Verify installation
tflint --version
```

**Basic Usage**
```bash
# Initialize tflint (creates .tflint.hcl)
tflint --init

# Run linting
tflint

# Run with specific ruleset
tflint --enable-rule=terraform_deprecated_interpolation
```

**Configuration Example (.tflint.hcl)**
```hcl
config {
  plugin_dir = "~/.tflint.d/plugins"

  call_module_type = "all"
  force = false
  disabled_by_default = false
}

plugin "azurerm" {
  enabled = true
  version = "0.25.1"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_deprecated_interpolation" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_comment_syntax" {
  enabled = true
}
```

## 2. Security and Compliance Scanning

### Checkov - Security Analysis

[Checkov](https://www.checkov.io/) scans for security misconfigurations and compliance violations.

**Installation**
```bash
# Using pip
pip install checkov

# Using Docker
docker pull bridgecrew/checkov

# Verify installation
checkov --version
```

**Basic Usage**
```bash
# Scan current directory
checkov -d .

# Scan specific file
checkov -f main.tf

# Generate report in JSON format
checkov -d . -o json

# Skip specific checks
checkov -d . --skip-check CKV_AZURE_1,CKV_AZURE_2
```

## 3. Modern Terraform Testing Framework (Terraform 1.6+)

Terraform 1.6 introduced a built-in testing framework that allows you to write tests directly in your Terraform configuration.

### Writing Terraform Tests

**Test File Structure:**
```hcl
# tests/resource_group_test.tftest.hcl
run "create_resource_group" {
  command = plan
  
  variables {
    resource_group_name = "test-rg"
    location           = "East US"
    environment        = "dev"
  }
  
  assert {
    condition     = azurerm_resource_group.test.name == "test-rg"
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
    resource_group_name = "test-rg"
    location           = "East US"
    environment        = "dev"
  }
  
  assert {
    condition     = azurerm_resource_group.test.tags.Environment == "dev"
    error_message = "Environment tag not set correctly"
  }
  
  assert {
    condition     = azurerm_resource_group.test.tags.ManagedBy == "Terraform"
    error_message = "ManagedBy tag not set correctly"
  }
}

run "apply_and_verify" {
  command = apply
  
  variables {
    resource_group_name = "test-rg-${random_string.suffix.result}"
    location           = "East US"
    environment        = "dev"
  }
  
  assert {
    condition     = azurerm_resource_group.test.id != null
    error_message = "Resource group was not created successfully"
  }
}
```

### Advanced Test Patterns

**Testing with Multiple Configurations:**
```hcl
# tests/multi_environment_test.tftest.hcl
variables {
  environments = ["dev", "staging", "prod"]
}

run "test_all_environments" {
  command = plan
  
  # Test each environment
  for_each = toset(var.environments)
  
  variables {
    environment = each.value
    resource_group_name = "rg-${each.value}-test"
    location = each.value == "prod" ? "West US 2" : "East US"
  }
  
  assert {
    condition = azurerm_resource_group.test.tags.Environment == each.value
    error_message = "Environment tag does not match for ${each.value}"
  }
}
```

**Testing with Mock Providers:**
```hcl
# tests/mock_test.tftest.hcl
mock_provider "azurerm" {
  mock_resource "azurerm_resource_group" {
    defaults = {
      id       = "/subscriptions/12345678-1234-1234-1234-123456789012/resourceGroups/mock-rg"
      name     = "mock-rg"
      location = "East US"
      tags     = {}
    }
  }
}

run "test_with_mocks" {
  command = plan
  
  variables {
    resource_group_name = "mock-rg"
    location           = "East US"
    environment        = "test"
  }
  
  assert {
    condition     = azurerm_resource_group.test.name == "mock-rg"
    error_message = "Mock resource group name incorrect"
  }
}
```

### Running Terraform Tests

```bash
# Run all tests
terraform test

# Run specific test file
terraform test tests/resource_group_test.tftest.hcl

# Run tests with verbose output
terraform test -verbose

# Run tests with specific variables
terraform test -var="environment=staging"
```

### Test Configuration Best Practices

1. **Organize tests by functionality**
```
tests/
├── unit/
│   ├── resource_group_test.tftest.hcl
│   └── storage_account_test.tftest.hcl
├── integration/
│   ├── full_deployment_test.tftest.hcl
│   └── networking_test.tftest.hcl
└── helpers/
    └── test_variables.tf
```

2. **Use meaningful test names and descriptions**
3. **Test both success and failure scenarios**
4. **Clean up resources in integration tests**
5. **Use mocks for expensive or slow resources**

## 📚 Additional Resources

- [Terraform Testing Framework Documentation](https://developer.hashicorp.com/terraform/language/tests)
- [Terraform Testing Tutorial](https://developer.hashicorp.com/terraform/tutorials/configuration-language/testing)
- [Terratest Documentation](https://terratest.gruntwork.io/)
- [TFLint Ruleset for Azure](https://github.com/terraform-linters/tflint-ruleset-azurerm)
- [Checkov Terraform Policies](https://www.checkov.io/4.Terraform/resource-registry.html)

## 🎯 Hands-on Exercise

**Practice what you've learned:**
1. Create a simple Terraform configuration with a resource group and storage account
2. Set up tflint and checkov for the configuration
3. Write validation rules for your variables
4. Create a simple test script to verify the plan output
5. Run all validation steps and fix any issues found

**Next Step:** Ready to learn about importing existing infrastructure? Continue to [Section 9: Terraform Import Strategies](../9-terraform-import/)

---

*Testing is not just about catching errors—it's about building confidence in your infrastructure deployments.* 🚀