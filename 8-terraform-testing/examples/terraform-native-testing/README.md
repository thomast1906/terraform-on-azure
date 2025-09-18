# Terraform Native Testing Framework Example

This example demonstrates how to use Terraform's built-in testing framework (available in Terraform 1.6+).

## Prerequisites

- Terraform >= 1.6.0
- Azure CLI authenticated
- Understanding of Terraform basics

## Files Structure

```
.
├── main.tf              # Main Terraform configuration
├── variables.tf         # Variable definitions
├── outputs.tf           # Output definitions
└── tests/
    ├── basic_test.tftest.hcl           # Basic validation tests
    ├── multi_environment_test.tftest.hcl # Environment-specific tests
    └── integration_test.tftest.hcl     # Integration tests with actual resources
```

## Running Tests

```bash
# Run all tests
terraform test

# Run specific test file
terraform test tests/basic_test.tftest.hcl

# Run tests with verbose output
terraform test -verbose

# Run tests and show JSON output
terraform test -json
```

## Test Types Included

1. **Basic Validation Tests** - Test configuration without creating resources
2. **Multi-Environment Tests** - Validate different environment configurations
3. **Integration Tests** - Create actual resources and validate them

## Example Test Output

```
tests/basic_test.tftest.hcl... in progress
  run "validate_resource_group_name"... pass
  run "validate_tags"... pass
tests/basic_test.tftest.hcl... pass

tests/integration_test.tftest.hcl... in progress
  run "create_and_verify_resource_group"... pass
tests/integration_test.tftest.hcl... pass

Success! 3 passed, 0 failed.
```