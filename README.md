# Terraform on Azure - Complete Learning Path

A comprehensive, hands-on learning repository to master Terraform deployment on Microsoft Azure. This tutorial-driven guide takes you from complete beginner to confidently deploying production-ready infrastructure.

## 🎯 What You Will Learn

By completing this learning path, you will master:
- **Terraform fundamentals** and Azure provider usage
- **Infrastructure as Code** best practices and modern workflows
- **State management** strategies for team collaboration
- **Advanced Terraform patterns** for complex deployments
- **Security practices** including Azure Key Vault integration
- **Module development** for reusable infrastructure components
- **Testing and validation** approaches for reliable deployments
- **Modern tooling** integration and automation

## 📚 Learning Path Structure

This comprehensive journey is organized into 7 progressive sections:

### 1. 🚀 Terraform Basics
**Foundation concepts and setup**
- Terraform installation and environment setup
- Essential commands and workflow
- Introduction to Terraform resources and syntax
- Azure Provider configuration and authentication

### 2. 🔧 Terraform Variables
**Dynamic and reusable configurations**
- Variable types, declarations, and best practices
- Working with .tfvars files and variable precedence
- Local variables and computed values
- Environment-specific configurations

### 3. 🗃️ Terraform State Management
**Critical state concepts for team collaboration**
- Understanding Terraform state and its importance
- Local vs. remote state backends
- Azure Storage backend configuration
- State locking and team workflows

### 4. ⚡ Advanced Terraform Patterns
**Complex deployment strategies**
- Resource dependencies with `depends_on`
- Iteration with `for_each` and `count`
- Conditional resource creation
- Dynamic configuration blocks
- Data sources and references

### 5. 🔐 Secret Management with Azure Key Vault
**Security-first infrastructure deployment**
- Azure Key Vault integration patterns
- Secure secret storage and retrieval
- Certificate and key management
- Best practices for sensitive data

### 6. 📦 Terraform Modules
**Reusable infrastructure components**
- Module design principles and structure
- Creating and publishing custom modules
- Module composition and dependency management
- Versioning and testing strategies

### 7. 🔬 Advanced Azure Integration (AzAPI)
**Cutting-edge Azure resource management**
- AzAPI provider for latest Azure features
- Managing preview and beta Azure services
- Custom resource configurations
- Migration strategies from AzureRM to AzAPI

### 8. 🧪 Terraform Testing and Validation
**Ensuring reliable and secure deployments**
- Static analysis with terraform validate and fmt
- Linting with tflint and security scanning with checkov
- Integration testing with Terratest
- CI/CD pipeline integration for automated testing

### 9. 📥 Terraform Import Strategies
**Managing existing infrastructure with Terraform**
- Importing existing Azure resources into Terraform state
- Migration from ARM templates and manual deployments
- Handling complex resource dependencies
- Best practices for brownfield environment adoption

## 🛠️ Prerequisites and Setup

### Required Accounts and Subscriptions
- **[Azure Account](https://azure.microsoft.com/en-us/free/)** with an active subscription
- [Azure CLI](https://docs.microsoft.com/en-us/cli/azure/install-azure-cli) installed and configured

### Software Requirements
- **Terraform** >= 1.5.0 ([Installation Guide](./1-terraform-basics/1-terraform-installation/))
- **Azure CLI** >= 2.50.0 for authentication
- **Git** for version control
- **VS Code** (recommended) with HashiCorp Terraform extension

### Recommended Tools
- **tflint** for Terraform linting
- **terraform-docs** for documentation generation
- **checkov** for security scanning
- **Azure Storage Explorer** for state file management

## 🚀 How to Use This Repository

### Learning Path Navigation
This repository is designed as a **progressive learning experience**. Each section builds upon previous knowledge:

1. **Start at Section 1** and work sequentially through Section 7
2. **Complete all subsections** within each section before moving forward
3. **Practice hands-on** with provided examples and exercises
4. **Clean up resources** after each section to avoid Azure charges

### Section Structure
Each section contains:
- 📖 **README.md** - Main tutorial content and learning objectives
- 🎯 **Learning Goals** - What you'll accomplish
- ✅ **Prerequisites** - Required knowledge and setup
- 💻 **Hands-on Examples** - Practical Terraform configurations
- 🔍 **Verification Steps** - How to confirm your success
- 🧹 **Cleanup Instructions** - Resource destruction guidance

### Success Tips
- **Always run in the correct directory** when executing Terraform commands
- **Authenticate with Azure** before running cloud operations: `az login`
- **Destroy resources** after completing each section: `terraform destroy`
- **Use consistent naming** to avoid resource conflicts
- **Check Azure costs** regularly to avoid unexpected charges

## 🧪 Testing and Validation

This repository includes modern Terraform validation approaches:

### Built-in Validation
```bash
# Format code according to standards
terraform fmt

# Validate configuration syntax
terraform validate

# Preview changes before applying
terraform plan
```

### Additional Tools (Optional)
```bash
# Install and use tflint for enhanced validation
curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
tflint

# Security scanning with checkov
pip install checkov
checkov -f main.tf
```

## 🆘 Troubleshooting

### Common Issues and Solutions

**Authentication Errors**
```bash
# Re-authenticate with Azure
az login
az account show  # Verify correct subscription
```

**State Lock Issues**
```bash
# Force unlock if necessary (use carefully)
terraform force-unlock <LOCK_ID>
```

**Resource Conflicts**
```bash
# Import existing resources
terraform import azurerm_resource_group.example /subscriptions/{id}/resourceGroups/{name}
```

**Provider Version Issues**
```bash
# Upgrade providers
terraform init -upgrade
```

## 🔧 Modern Terraform Features Covered

- **Terraform >= 1.5** syntax and features
- **HCL2** configuration language
- **Remote state** with Azure Storage backend
- **Module composition** and registry usage
- **Workspace management** for multiple environments
- **Import workflows** for existing infrastructure
- **Testing strategies** with validation and linting
- **CI/CD integration** patterns

## 💰 Cost Management

### Important Cost Considerations
- 🚨 **Always destroy resources** after completing tutorials
- 📊 **Monitor Azure costs** using Azure Cost Management
- ⏰ **Set spending alerts** to avoid unexpected charges
- 🗑️ **Verify resource deletion** in Azure Portal after destruction

### Resource Cleanup Checklist
```bash
# 1. Terraform destroy
terraform destroy

# 2. Verify state file is clean
cat terraform.tfstate

# 3. Check for orphaned resources
az group list --output table

# 4. Manual cleanup if needed
az group delete --name "resource-group-name"
```

## 🤝 Contributing and Feedback 

We welcome contributions and feedback to improve this learning resource:

- 🐛 **Report Issues** - Found a bug or unclear instruction? [Open an issue](https://github.com/thomast1906/terraform-on-azure/issues)
- 💡 **Suggest Features** - Ideas for new tutorials or improvements? [Start a discussion](https://github.com/thomast1906/terraform-on-azure/discussions)
- 🔄 **Submit Pull Requests** - Want to contribute directly? PRs are welcome!
- ⭐ **Star the Repository** - If this helped you learn, please star it to help others find it

## 📖 Additional Resources

- [Terraform Documentation](https://developer.hashicorp.com/terraform)
- [Azure Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure Architecture Center](https://docs.microsoft.com/en-us/azure/architecture/)
- [Terraform Best Practices](https://developer.hashicorp.com/terraform/cloud-docs/recommended-practices)

---

**Ready to start your Terraform journey?** 🚀 [Begin with Section 1: Terraform Basics](./1-terraform-basics/)

*This repository is continuously updated to reflect the latest Terraform and Azure best practices. Last updated: 2024*


