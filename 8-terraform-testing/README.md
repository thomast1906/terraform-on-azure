# Test your Terraform code

Testing catches errors before they reach Azure. Use multiple testing approaches to validate syntax, configuration, and infrastructure behavior.

## Terraform native testing (Terraform 1.6+)

Terraform includes a built-in test framework. Write tests in `.tftest.hcl` files to validate your configurations.

### Create a test file

Create `main.tftest.hcl` in your configuration directory:

```hcl
# Test that dev environment uses correct settings
run "test_dev_environment" {
  command = plan

  variables {
    environment = "dev"
  }

  assert {
    condition     = azurerm_storage_account.example.account_tier == "Standard"
    error_message = "Dev should use Standard tier"
  }
}
```

### Run tests

```bash
terraform test
```

Output:
```
main.tftest.hcl... in progress
  run "test_dev_environment"... pass
main.tftest.hcl... pass in 2.1s

Success! 1 passed, 0 failed.
```

### Test commands

Tests support two commands:

**`plan`**: Runs `terraform plan` without deploying:
```hcl
run "test_configuration" {
  command = plan
  # Tests planned changes
}
```

**`apply`**: Actually deploys infrastructure (integration test):
```hcl
run "test_deployment" {
  command = apply
  # Tests real Azure resources
}
```

### Write assertions

Check resource properties:

```hcl
run "test_security" {
  command = plan

  assert {
    condition     = azurerm_storage_account.example.enable_https_traffic_only == true
    error_message = "HTTPS traffic must be enforced"
  }

  assert {
    condition     = azurerm_storage_account.example.min_tls_version == "TLS1_2"
    error_message = "Minimum TLS version should be 1.2"
  }
}
```

### Test with variables

Pass different values to test behavior:

```hcl
run "test_prod_sku" {
  command = plan

  variables {
    environment = "prod"
  }

  assert {
    condition     = azurerm_storage_account.example.account_replication_type == "GRS"
    error_message = "Prod should use geo-redundant storage"
  }
}
```

### Test validation rules

Verify that invalid inputs fail:

```hcl
run "test_invalid_environment" {
  command = plan

  variables {
    environment = "invalid"
  }

  expect_failures = [
    var.environment
  ]
}
```

### Complete Azure example

Working test file for Azure resources (see `examples/main.tftest.hcl`):

```hcl
run "test_azure_storage_security" {
  command = plan

  variables {
    resource_group_name  = "rg-test"
    storage_account_name = "sttest"
    environment          = "dev"
  }

  # Verify HTTPS is enforced
  assert {
    condition     = azurerm_storage_account.test.enable_https_traffic_only == true
    error_message = "Storage account must enforce HTTPS"
  }

  # Verify TLS version
  assert {
    condition     = azurerm_storage_account.test.min_tls_version == "TLS1_2"
    error_message = "Storage account must use TLS 1.2 or higher"
  }

  # Verify tags are applied
  assert {
    condition     = azurerm_storage_account.test.tags["ManagedBy"] == "Terraform"
    error_message = "Resources must be tagged with ManagedBy"
  }
}

# Test different environments
run "test_dev_uses_standard_tier" {
  command = plan

  variables {
    environment = "dev"
  }

  assert {
    condition     = azurerm_storage_account.test.account_tier == "Standard"
    error_message = "Dev environment should use Standard tier"
  }
}

run "test_prod_uses_premium_tier" {
  command = plan

  variables {
    environment = "prod"
  }

  assert {
    condition     = azurerm_storage_account.test.account_tier == "Premium"
    error_message = "Prod environment should use Premium tier"
  }
}
```

### Integration tests

Test actual deployments:

```hcl
run "test_real_deployment" {
  command = apply

  variables {
    resource_group_name  = "rg-integration-test"
    storage_account_name = "stintegration"
    environment          = "dev"
  }

  assert {
    condition     = output.resource_group_id != ""
    error_message = "Resource group should be created"
  }

  assert {
    condition     = length(output.storage_account_name) >= 3
    error_message = "Storage account name should be valid"
  }
}
```

Integration tests create real resources. Terraform destroys them automatically after the test.

### Run specific tests

Run one test file:

```bash
terraform test -filter=main.tftest.hcl
```

Run tests matching a pattern:

```bash
terraform test -filter="test_prod*"
```

Verbose output:

```bash
terraform test -verbose
```

### Organize tests

Group related tests in separate files:

```
tests/
├── security.tftest.hcl
├── networking.tftest.hcl
└── environments.tftest.hcl
```

Terraform runs all `.tftest.hcl` files in your directory.

### Try the examples

```bash
cd 8-terraform-testing/examples
terraform init
terraform test
```

The example includes tests for:
- Environment-specific SKUs
- Security settings
- Resource tags
- Validation rules
- Real deployments

## Level 1: Syntax validation

### terraform validate

The fastest check. Validates syntax and internal consistency:

```bash
terraform validate
```

Catches:
- Syntax errors
- Invalid resource references
- Missing required arguments
- Type mismatches

Run this before every commit.

### terraform fmt

Formats code to Terraform style standards:

```bash
terraform fmt -check
```

The `-check` flag returns an error if files need formatting. Use this in CI/CD pipelines.

Auto-fix formatting:

```bash
terraform fmt -recursive
```

## Level 2: Static analysis with tflint

tflint catches issues validate misses:
- Deprecated syntax
- Provider-specific errors
- Best practice violations
- Potential runtime errors

### Install tflint

```bash
# macOS
brew install tflint

# Windows
choco install tflint

# Linux
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
```

### Configure tflint

Create `.tflint.hcl`:

```hcl
plugin "azurerm" {
  enabled = true
  version = "0.27.0"
  source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}

rule "terraform_deprecated_syntax" {
  enabled = true
}

rule "terraform_unused_declarations" {
  enabled = true
}

rule "terraform_typed_variables" {
  enabled = true
}

rule "terraform_naming_convention" {
  enabled = true
  format  = "snake_case"
}
```

### Run tflint

Initialize plugins:

```bash
tflint --init
```

Run checks:

```bash
tflint
```

### Azure-specific rules

The AzureRM ruleset checks:
- Invalid VM sizes
- Incorrect SKU names
- Deprecated resource properties
- Azure naming constraints

Example output:

```
3 issue(s) found:

Warning: "Standard_A0" is deprecated VM size (azurerm_linux_virtual_machine)
  on main.tf line 45:
  45:   size = "Standard_A0"

Error: Storage account name must be between 3 and 24 characters
  on main.tf line 12:
  12:   name = "my-storage-account-that-is-too-long"
```

## Level 3: Cost estimation

### terraform plan with costs

Preview costs before deploying:

```bash
terraform plan -out=plan.tfplan
```

Use Azure Cost Management or third-party tools like Infracost to estimate costs from the plan file.

### Infracost

Install:

```bash
# macOS
brew install infracost

# Linux/Windows - see https://www.infracost.io/docs/
```

Check costs:

```bash
# Generate plan
terraform plan -out=tfplan.binary
terraform show -json tfplan.binary > plan.json

# Get cost estimate
infracost breakdown --path plan.json
```

Output shows estimated monthly costs for each resource.

## Level 4: Integration testing

### Test in isolated environments

Deploy to a test environment before production:

```terraform
# dev.tfvars
environment = "dev"
instance_count = 1
sku = "Basic"

# prod.tfvars
environment = "prod"
instance_count = 3
sku = "Standard"
```

Test workflow:

```bash
# Deploy to dev
terraform workspace select dev
terraform apply -var-file="dev.tfvars"

# Run application tests
# ...

# Destroy dev
terraform destroy -var-file="dev.tfvars"

# Deploy to prod
terraform workspace select prod
terraform apply -var-file="prod.tfvars"
```

## Level 5: Automated testing with Terratest

Terratest writes Go tests that deploy infrastructure, validate it, and clean up.

### Install Go

```bash
# macOS
brew install go

# Others - see https://go.dev/doc/install
```

### Create a test

Create `test/terraform_azure_example_test.go`:

```go
package test

import (
    "testing"

    "github.com/gruntwork-io/terratest/modules/azure"
    "github.com/gruntwork-io/terratest/modules/terraform"
    "github.com/stretchr/testify/assert"
)

func TestTerraformAzureExample(t *testing.T) {
    t.Parallel()

    terraformOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
        TerraformDir: "../",
        Vars: map[string]interface{}{
            "resource_group_name": "rg-terratest",
            "location": "uksouth",
        },
    })

    defer terraform.Destroy(t, terraformOptions)

    terraform.InitAndApply(t, terraformOptions)

    resourceGroupName := terraform.Output(t, terraformOptions, "resource_group_name")
    
    exists := azure.ResourceGroupExists(t, resourceGroupName, "")
    assert.True(t, exists, "Resource group should exist")
}
```

### Run tests

```bash
cd test
go mod init test
go mod tidy
go test -v -timeout 30m
```

Tests:
1. Initialize Terraform
2. Apply configuration
3. Validate resources exist
4. Run custom checks
5. Destroy infrastructure

## CI/CD pipeline example

GitHub Actions workflow:

```yaml
name: Terraform Tests

on: [push, pull_request]

jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        
      - name: Terraform Format
        run: terraform fmt -check -recursive
        
      - name: Terraform Init
        run: terraform init
        
      - name: Terraform Validate
        run: terraform validate
        
      - name: Setup TFLint
        uses: terraform-linters/setup-tflint@v4
        
      - name: TFLint
        run: |
          tflint --init
          tflint --format compact
```

## Testing checklist

Before deploying:

- [ ] `terraform fmt` passes
- [ ] `terraform validate` succeeds
- [ ] `tflint` shows no errors
- [ ] `terraform plan` output reviewed
- [ ] Costs estimated (if using paid resources)
- [ ] Tested in dev environment
- [ ] Automated tests pass (if using Terratest)

## Best practices

**Test early:** Run validate and fmt on every file save.

**Test often:** Include checks in pre-commit hooks and CI/CD.

**Test realistically:** Use dev environments that mirror prod configuration.

**Test destructively:** Ensure `terraform destroy` works cleanly.

**Test idempotency:** Run apply twice—the second should show no changes.

## Next steps

Learn how to import existing Azure resources into Terraform in the next section.
