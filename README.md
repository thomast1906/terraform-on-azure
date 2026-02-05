# Terraform on Azure

A step-by-step course for deploying and managing Azure infrastructure with Terraform. Learn from basics to advanced patterns through hands-on examples.

## Start here

Begin with [Lesson 01: Introduction](01-introduction/)

## Course outline

### Getting Started
- [01. Introduction](01-introduction/) - Get familiar with Terraform and Infrastructure as Code
- [02. Install Terraform](02-installation/) - Set up Terraform on your machine
- [03. Set up VS Code](03-vscode-setup/) - Configure your development environment
- [04. Core Terraform commands](04-core-commands/) - Learn init, plan, apply, destroy
- [05. Resources and data sources](05-resources-and-data/) - Create and query Azure resources
- [06. Azure provider setup](06-azure-provider/) - Configure authentication and providers

### Variables and State
- [07. Variables](07-variables/) - Make configurations reusable with variables
- [08. State: local](08-state-local/) - Understand Terraform state management
- [09. State: remote](09-state-remote/) - Store state in Azure Storage for teams

### Advanced Patterns
- [10. Advanced: depends_on](10-advanced-dependencies/) - Control resource dependencies
- [11. Advanced: for_each](11-advanced-for-each/) - Create multiple similar resources
- [12. Advanced: count](12-advanced-count/) - Create multiple identical resources
- [13. Advanced: conditionals](13-advanced-conditionals/) - Make configuration decisions
- [14. Advanced: dynamic blocks](14-advanced-dynamic-blocks/) - Generate nested blocks

### Production Best Practices
- [15. Secret management](15-secret-management/) - Secure secrets with Azure Key Vault
- [16. Modules](16-modules/) - Build reusable infrastructure components
- [17. AzAPI provider](17-azapi/) - Use day-one Azure resources
- [18. Testing](18-testing/) - Validate configurations with terraform test

### Workflow and Operations
- [19. Import](19-import/) - Bring existing Azure resources under Terraform
- [20. State commands](20-state-commands/) - Inspect and manage state
- [21. Pre- and post-conditions](21-pre-post-conditions/) - Add validation to resources
- [22. Terraform functions](22-functions/) - Transform and manipulate data
- [23. Terraform MCP server](23-mcp-server/) - Use AI assistance with Terraform

## What you will learn

- Terraform fundamentals: core concepts, workflow, and Azure provider
- State management: local and remote state with Azure Storage backend
- Advanced patterns: resource dependencies, loops, conditionals, dynamic blocks
- Production practices: secret management, testing, modules, validation
- Operations: import existing resources, state manipulation, troubleshooting
- Modern tooling: AzAPI provider, Terraform test framework, AI assistance

## Prerequisites

- Azure subscription ([free account](https://azure.microsoft.com/free/))
- Basic command-line knowledge
- Understanding of cloud infrastructure concepts

## How the course is structured

- 23 progressive lessons from basics to advanced topics
- Each lesson has a `README.md` with explanations and steps
- Hands-on examples in `examples/` directories with working Terraform code
- Examples use azurerm 4.0+ with latest provider features

## Get started

```bash
# Clone the repository
git clone https://github.com/thomast1906/terraform-on-azure.git
cd terraform-on-azure

# Start with lesson 01
cd 01-introduction
```

## Get help

- Issues: [Report bugs or request features](https://github.com/thomast1906/terraform-on-azure/issues)
- Discussions: Ask questions and share your experience

## Contributing

Contributions welcome! Open a pull request to:
- Fix errors or typos
- Improve explanations
- Add new examples
- Suggest new lessons

## License

This course is provided for educational purposes.
