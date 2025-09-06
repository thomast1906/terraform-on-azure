# Contributing to Terraform on Azure

Thank you for your interest in contributing to this Terraform on Azure tutorial repository! This guide will help you get started with contributing effectively.

## 🎯 How to Contribute

We welcome contributions in several forms:
- **Content improvements** - Fix typos, improve explanations, add examples
- **New tutorials** - Add new sections or expand existing ones
- **Bug fixes** - Fix broken examples or configurations
- **Documentation** - Improve READMEs and inline documentation
- **Testing** - Add validation scripts or test cases

## 🚀 Getting Started

### Prerequisites

1. **Fork the repository** to your GitHub account
2. **Clone your fork** locally:
   ```bash
   git clone https://github.com/YOUR-USERNAME/terraform-on-azure.git
   cd terraform-on-azure
   ```
3. **Install development tools**:
   ```bash
   make install-tools
   ```

### Development Environment

1. **Install required tools**:
   - Terraform (latest version)
   - Azure CLI
   - VS Code with Terraform extension
   - Git

2. **Set up pre-commit hooks** (optional but recommended):
   ```bash
   pip install pre-commit
   pre-commit install
   ```

## 📝 Content Guidelines

### Writing Style

- **Tutorial-focused**: Write step-by-step instructions
- **Clear and concise**: Use simple language and short sentences
- **Practical**: Include hands-on examples and exercises
- **Beginner-friendly**: Explain concepts thoroughly

### Structure Standards

Each tutorial section should include:

```markdown
# Section Title

## 📋 Overview
Brief description of what will be covered

## 🎯 Learning Objectives
- Specific, measurable learning outcomes
- What users will be able to do after completion

## 📚 Prerequisites
- Required prior knowledge
- Tools needed
- Previous sections that should be completed

## 🛠️ Main Content
Step-by-step instructions with:
- Code examples
- Explanations
- Screenshots (when helpful)

## ✅ Validation
How to verify the work was completed correctly

## 🎉 Summary
Key takeaways and accomplishments

## 🚀 Next Steps
What to do next in the learning journey

## 📚 Additional Resources
Links to relevant external documentation
```

### Code Standards

#### Terraform Code
- Use **Terraform 1.0+** syntax
- Follow **HCL formatting** standards (`terraform fmt`)
- Include **comprehensive comments**
- Use **descriptive variable names**
- Add **validation blocks** where appropriate
- Include **output descriptions**

#### File Organization
```
section-name/
├── README.md              # Main tutorial content
├── examples/              # Working code examples
│   ├── basic/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── README.md
│   └── advanced/
├── scripts/               # Helper scripts
└── images/               # Screenshots and diagrams
```

#### Example Configuration

```hcl
# Resource description and purpose
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location

  tags = merge(
    var.common_tags,
    {
      Purpose = "Terraform Tutorial"
    }
  )

  lifecycle {
    create_before_destroy = true
  }
}
```

#### Variable Documentation

```hcl
variable "resource_group_name" {
  description = "The name of the resource group to create"
  type        = string
  
  validation {
    condition     = length(var.resource_group_name) > 0
    error_message = "Resource group name cannot be empty."
  }
}
```

## 🔄 Development Workflow

### Making Changes

1. **Create a feature branch**:
   ```bash
   git checkout -b feature/improve-testing-section
   ```

2. **Make your changes** following the guidelines above

3. **Test your changes**:
   ```bash
   # Run all validation checks
   make check-all
   
   # Test specific examples
   cd examples/basic
   terraform init
   terraform validate
   terraform plan
   ```

4. **Commit your changes**:
   ```bash
   git add .
   git commit -m "feat: improve testing section with more examples"
   ```

### Pull Request Process

1. **Push to your fork**:
   ```bash
   git push origin feature/improve-testing-section
   ```

2. **Open a Pull Request** with:
   - **Clear title** describing the change
   - **Detailed description** of what was changed and why
   - **Testing details** showing that examples work
   - **Screenshots** if UI changes are involved

3. **Respond to feedback** promptly and make requested changes

### Commit Message Format

Use conventional commit format:
```
type(scope): description

feat(testing): add terratest examples
fix(import): correct resource ID format
docs(readme): update installation instructions
```

Types:
- `feat`: New feature or tutorial
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Formatting changes
- `refactor`: Code restructuring
- `test`: Adding tests
- `chore`: Maintenance tasks

## 🧪 Testing Guidelines

### Before Submitting

Always test your changes:

1. **Validate Terraform syntax**:
   ```bash
   terraform validate
   ```

2. **Check formatting**:
   ```bash
   terraform fmt -check
   ```

3. **Run linting**:
   ```bash
   tflint
   ```

4. **Test deployments** (when possible):
   ```bash
   terraform plan
   # In development environment only:
   terraform apply
   terraform destroy
   ```

### Automated Testing

The repository includes automated checks:
- Terraform validation
- Format checking
- TFLint analysis
- Security scanning with Checkov

These run automatically on pull requests.

## 🐛 Reporting Issues

When reporting bugs or issues:

1. **Use the issue template** (if available)
2. **Provide context**:
   - What you were trying to do
   - What happened vs. what you expected
   - Your environment (OS, Terraform version, etc.)
3. **Include error messages** (full text)
4. **Add minimal reproduction steps**

## 📚 Resources for Contributors

### Terraform Best Practices
- [Official Terraform Style Guide](https://www.terraform.io/docs/language/syntax/style.html)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Terraform Best Practices](https://www.terraform.io/docs/cloud/guides/recommended-practices/)

### Azure Resources
- [Azure Documentation](https://docs.microsoft.com/en-us/azure/)
- [Azure CLI Reference](https://docs.microsoft.com/en-us/cli/azure/)
- [Azure Resource Manager Templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/)

### Writing Guidelines
- [Microsoft Writing Style Guide](https://docs.microsoft.com/en-us/style-guide/welcome/)
- [Google Technical Writing Courses](https://developers.google.com/tech-writing)

## 🏆 Recognition

Contributors will be:
- Listed in the repository contributors
- Mentioned in release notes for significant contributions
- Given credit in the tutorial sections they help create

## ❓ Questions?

- **General questions**: Open a GitHub Discussion
- **Bug reports**: Open a GitHub Issue
- **Feature requests**: Open a GitHub Issue with the "enhancement" label

Thank you for helping make this tutorial better for everyone! 🙏