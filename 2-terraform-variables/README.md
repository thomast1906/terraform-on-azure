# Section 2: Terraform Variables

Master the art of creating flexible, reusable Terraform configurations through variables. This section covers everything from basic variable declarations to advanced validation patterns and environment-specific configurations.

## 🎯 Learning Objectives

By the end of this section, you will be able to:
- **Declare and use** different types of Terraform variables
- **Implement** robust variable validation rules
- **Organize** variables effectively using best practices
- **Create** environment-specific configurations with .tfvars files
- **Use** local variables for computed values
- **Apply** variable precedence and scoping rules

## 📋 Prerequisites

- **Completed**: [Section 1: Terraform Basics](../1-terraform-basics/)
- **Understanding**: HCL syntax and Terraform resource blocks
- **Tools**: Terraform installed and Azure CLI configured
- **Knowledge**: Basic command-line usage

## 🗺️ Section Structure

This section contains three progressive tutorials:

### [1. Terraform Variables](./1-terraform-variables.md)
**Foundation concepts and advanced patterns**
- Variable declaration and types (string, number, bool, list, map, object)
- Variable validation with condition rules
- Using variables in resources and expressions
- Best practices for variable organization and documentation

### [2. Terraform tfvars](./2-terraform-tfvars.md)
**Environment-specific configurations**
- Creating and using .tfvars files
- Variable precedence and override rules
- Managing multiple environments (dev, staging, prod)
- Security considerations for sensitive values

### [3. Local Variables](./3-terraform-local-variables.md)
**Computed values and complex expressions**
- Local values for intermediate calculations
- Combining variables with functions
- Reducing repetition in configurations
- When to use locals vs variables

## 🚀 What You'll Build

Throughout this section, you'll create a flexible web application infrastructure that can be deployed across different environments:

```hcl
# Example of what you'll achieve
resource "azurerm_resource_group" "main" {
  name     = "rg-${var.environment}-${var.application_name}"
  location = var.location
  tags     = local.common_tags
}

resource "azurerm_service_plan" "main" {
  name                = "plan-${var.environment}-${var.application_name}"
  resource_group_name = azurerm_resource_group.main.name
  location           = azurerm_resource_group.main.location
  os_type            = "Linux"
  sku_name           = local.app_service_sku
  
  tags = local.common_tags
}
```

### Configuration Files You'll Create

- **variables.tf** - Variable declarations with validation
- **dev.tfvars** - Development environment values
- **prod.tfvars** - Production environment values
- **locals.tf** - Computed values and expressions
- **main.tf** - Resource definitions using variables

## ✅ Success Criteria

You'll know you've successfully completed this section when you can:

- [ ] Declare variables with appropriate types and validation rules
- [ ] Create .tfvars files for different environments
- [ ] Use local variables to reduce configuration repetition
- [ ] Deploy the same configuration to multiple environments
- [ ] Validate variable values using Terraform's validation features
- [ ] Organize variables following best practices
- [ ] Handle sensitive variables securely

## 🛠️ Hands-on Exercises

### Exercise 1: Basic Variables
Create a simple resource group using variables with validation.

### Exercise 2: Environment Configurations  
Deploy the same infrastructure to dev and prod using different .tfvars files.

### Exercise 3: Complex Variables
Use object and list variables to configure multiple resources.

### Exercise 4: Local Variables
Implement local variables to compute resource names and tags.

## 💡 Key Concepts You'll Learn

**Variable Types:**
- Primitive: string, number, bool
- Collections: list, set, map
- Structural: object, tuple

**Variable Features:**
- Default values and required variables
- Validation rules with custom error messages
- Sensitive variables for secrets
- Variable precedence and override rules

**Organization Patterns:**
- Grouping related variables
- Documentation standards
- Naming conventions
- File structure best practices

## 🔧 Tools and Techniques

**Validation Functions:**
- `contains()` - Check if value is in list
- `can()` - Test if expression is valid
- `regex()` - Pattern matching
- `length()` - String/list length validation

**Environment Management:**
- Multiple .tfvars files
- Environment-specific overrides
- Command-line variable setting
- Environment variable integration

## 🎓 Expected Outcomes

After completing this section:

1. **Flexible Configurations** - Your Terraform code will adapt to different environments
2. **Robust Validation** - Variables will catch invalid inputs before deployment
3. **Clean Organization** - Variables will be well-documented and logically grouped
4. **Reusable Patterns** - You'll create templates that work across projects
5. **Security Awareness** - You'll handle sensitive data appropriately

## 🚨 Common Pitfalls to Avoid

- **Missing validation** - Always validate user inputs
- **Poor naming** - Use descriptive, consistent variable names
- **Hardcoded values** - Use variables for anything that might change
- **Sensitive data exposure** - Never commit secrets to version control
- **Type confusion** - Be explicit about variable types

## 📊 Progress Tracking

Mark your progress as you complete each subsection:

- [ ] **Variables Fundamentals** - Basic declaration and usage
- [ ] **Variable Validation** - Implementing robust validation rules  
- [ ] **Environment Files** - Creating and using .tfvars files
- [ ] **Local Variables** - Computing derived values
- [ ] **Hands-on Practice** - Building the complete example
- [ ] **Best Practices** - Following recommended patterns

## 🔗 Quick Navigation

**Previous**: [Section 1: Terraform Basics](../1-terraform-basics/) | **Current**: Section 2: Variables | **Next**: [Section 3: Terraform State](../3-terraform-state/)

---

**Ready to make your Terraform configurations flexible and reusable?** Start with [Terraform Variables](./1-terraform-variables.md) and learn how to parameterize your infrastructure code.

*Variables are the foundation of maintainable Infrastructure as Code. Invest time here to make everything that follows easier!* 🏗️

