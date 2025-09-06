# Terraform Testing and Validation

## 📋 Overview

Learn how to ensure your Terraform code is reliable, secure, and follows best practices through comprehensive testing and validation approaches. This section covers everything from basic syntax validation to advanced integration testing.

## 🎯 Learning Objectives

By the end of this section, you will be able to:
- Validate Terraform configuration syntax and logic
- Use tflint for code quality and security scanning
- Implement integration tests with Terratest
- Set up automated validation in CI/CD pipelines
- Apply testing best practices to your infrastructure code

## 📚 Prerequisites

- Completed sections 1-3 (Terraform Basics, Variables, State)
- Basic understanding of Azure resources
- Go programming language (for Terratest examples)

## 🛠️ Testing Approaches

### 1. Static Validation with `terraform validate`

The most basic form of testing ensures your Terraform configuration is syntactically valid and internally consistent.

```bash
# Basic validation
terraform validate

# Validate with detailed output
terraform validate -json
```

**What it checks:**
- Configuration syntax
- Required argument presence
- Type checking for variables
- Reference validity

**Limitations:**
- Doesn't check provider-specific logic
- Won't catch runtime errors
- Limited security analysis

### 2. Code Quality with `tflint`

TFLint is a framework for linting Terraform configurations to catch common errors and enforce best practices.

#### Installation

```bash
# macOS
brew install tflint

# Windows (Chocolatey)
choco install tflint

# Linux
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
```

#### Configuration

Create `.tflint.hcl` in your project root:

```hcl
config {
  module = true
  force = false
}

plugin "azurerm" {
  enabled = true
  version = "0.24.0"
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

rule "terraform_documented_outputs" {
  enabled = true
}

rule "terraform_documented_variables" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_module_pinned_source" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}

rule "terraform_standard_module_structure" {
  enabled = true
}
```

#### Usage Examples

```bash
# Initialize tflint (download plugins)
tflint --init

# Run basic linting
tflint

# Lint with specific format
tflint --format=json

# Lint specific directory
tflint /path/to/terraform/code

# Show rule descriptions
tflint --show-rule-names
```

### 3. Security Scanning with Checkov

Checkov is a static code analysis tool for scanning cloud infrastructure configurations for security misconfigurations.

#### Installation and Usage

```bash
# Install checkov
pip install checkov

# Scan Terraform files
checkov -f main.tf

# Scan directory
checkov -d /path/to/terraform

# Generate report
checkov -d . --output json > security-report.json

# Skip specific checks
checkov -d . --skip-check CKV_AZURE_1

# Only run specific checks
checkov -d . --check CKV_AZURE_2
```

### 4. Integration Testing with Terratest

Terratest is a Go library that makes it easier to write automated tests for your infrastructure code.

#### Example Test Structure

Create `test/` directory with Go test files:

```go
// test/terraform_basic_test.go
package test

import (
    "testing"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformBasicExample(t *testing.T) {
    t.Parallel()

    // Configure Terraform options
    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
        // Path to the Terraform code
        TerraformDir: "../examples/basic-resource-group",
        
        // Variables to pass to terraform
        Vars: map[string]interface{}{
            "resource_group_name": "test-rg-" + randomString(8),
            "location": "East US",
        },
    })

    // Clean up resources after test
    defer terraform.Destroy(t, terraformOptions)

    // Deploy the infrastructure
    terraform.InitAndApply(t, terraformOptions)

    // Validate the outputs
    resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
    assert.NotEmpty(t, resourceGroupName)
    
    // Additional validation can be done using Azure SDK
    // to verify resources actually exist in Azure
}

func randomString(length int) string {
    // Implementation for generating random strings
    // for unique resource names
    return "abcd1234" // Simplified for example
}
```

#### Running Terratest

```bash
# Initialize Go module
go mod init terraform-test
go mod tidy

# Run tests
go test -v -timeout 30m

# Run specific test
go test -v -run TestTerraformBasicExample

# Run tests in parallel
go test -v -parallel 2
```

## 🔍 Practical Exercises

### Exercise 1: Basic Validation Pipeline

Create a validation script that runs multiple checks:

```bash
#!/bin/bash
# validate.sh

set -e

echo "🔍 Running Terraform validation..."

# Format check
terraform fmt -check=true -diff=true

# Validate configuration
terraform validate

# Initialize for plan
terraform init -backend=false

# Create plan (without apply)
terraform plan -out=tfplan

echo "✅ All validations passed!"
```

### Exercise 2: Comprehensive Testing Setup

Set up a complete testing pipeline for a resource group example:

1. Create the infrastructure code
2. Set up tflint configuration
3. Write Terratest integration tests
4. Create CI/CD pipeline configuration

### Exercise 3: Security Compliance Scanning

Use Checkov to scan your Terraform code and fix identified security issues:

1. Run baseline security scan
2. Review and understand findings
3. Implement fixes for high-priority issues
4. Set up automated scanning

## ✅ Validation Checklist

- [ ] `terraform validate` passes without errors
- [ ] `terraform fmt` shows no formatting issues
- [ ] tflint runs without warnings (or accepted suppressions)
- [ ] Checkov security scans pass compliance requirements
- [ ] Terratest integration tests pass
- [ ] All tests run in reasonable time (< 30 minutes)
- [ ] Test cleanup works properly (no leaked resources)

## 🎉 Summary

You've learned how to implement comprehensive testing for your Terraform infrastructure:

- **Static validation** ensures basic correctness
- **Linting** enforces code quality and best practices
- **Security scanning** identifies potential vulnerabilities
- **Integration testing** validates real-world behavior
- **Automation** makes testing part of your development workflow

## 🚀 Next Steps

Move on to **[Section 9: Importing Existing Resources](../9-terraform-import/)** to learn how to bring existing Azure infrastructure under Terraform management.

## 📚 Additional Resources

- [Terraform Testing Documentation](https://www.terraform.io/docs/language/modules/testing.html)
- [TFLint Documentation](https://github.com/terraform-linters/tflint)
- [Terratest Documentation](https://terratest.gruntwork.io/)
- [Checkov Documentation](https://www.checkov.io/)
- [Azure DevOps Terraform Tasks](https://marketplace.visualstudio.com/items?itemName=ms-devlabs.custom-terraform-tasks)