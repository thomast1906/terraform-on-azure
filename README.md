# Terraform on Azure

Learn how to deploy infrastructure on Azure using Terraform, from the basics to production deployments.

## What you'll learn

This tutorial takes you from zero to deploying real Azure infrastructure with Terraform. You'll learn:

- How to install and configure Terraform
- Core Terraform concepts and commands
- Managing state locally and remotely in Azure
- Advanced techniques like loops and conditionals
- Secret management with Azure Key Vault
- Building reusable modules
- Using the AzAPI provider for new features
- Testing your configurations with terraform test framework
- Importing existing Azure resources
- State management commands for refactoring
- Pre/post-condition validation for fail-fast patterns
- Built-in Terraform functions for data manipulation
- AI-assisted development with Terraform MCP server

## Prerequisites

- [Azure account](https://azure.microsoft.com/en-us/free/) (free tier works fine)
- A code editor (VS Code recommended)
- Basic command line knowledge
- No Terraform experience required

## Tutorial structure

Work through these sections in order:

### 1. Terraform basics
- [Install Terraform](1-terraform-basics/1-terraform-installation/1-terraform-install.md)
- [Set up VS Code](1-terraform-basics/1-terraform-installation/2-vscode-install.md)
- [Core commands](1-terraform-basics/2-terraform-commands/1-terraform-commands.md)
- [Resources and data sources](1-terraform-basics/3-terraform-resources/1-terraform-resources.md)
- [Configure the Azure provider](1-terraform-basics/4-terraform-azure-provider/1-azure-provider.md)

### 2. Variables
- [Input variables](2-terraform-variables/1-terraform-variables.md)
- [Variable files](2-terraform-variables/2-terraform-tfvars.md)
- [Local values](2-terraform-variables/3-terraform-local-variables.md)

### 3. State management
- [Local vs remote state](3-terraform-state/1-terraform-state-local-vs-remote.md)
- [Deploy with local state](3-terraform-state/2-terraform-local-state-deploy.md)
- [Deploy with remote state](3-terraform-state/3-terraform-remote-state-deploy.md)

### 4. Advanced techniques
- [Resource dependencies](4-terraform-advanced/1-depends-on/)
- [for_each loops](4-terraform-advanced/2-for-each/)
- [Count loops](4-terraform-advanced/3-count/)
- [Conditional expressions](4-terraform-advanced/4-conditional-expressions/)
- [Dynamic blocks](4-terraform-advanced/5-dynamic-blocks/)

### 5. Secret management
- [Azure Key Vault integration](5-secret-management-azure/)

### 6. Modules
- [Build reusable modules](6-terraform-modules/)

### 7. AzAPI provider
- [Use preview Azure features](7-terraform-azapi/)

### 8. Testing
- [Validate and test your code](8-terraform-testing/)

### 9. Import resources
- [Bring existing resources under management](9-terraform-import/)

### 10. State management commands
- [Manipulate state safely](10-state-management-commands/)

### 11. Pre-conditions and post-conditions
- [Validate configurations with lifecycle rules](11-preconditions-postconditions/)

### 12. Terraform functions
- [Master built-in functions for Azure](12-terraform-functions/)

### 13. Terraform MCP server
- [AI-assisted Terraform development](13-terraform-mcp-server/)

## How to use this repository

**Start at section 1** and work through sequentially. Each section builds on previous concepts.

**Run the examples:** Every section includes working code. Deploy it, examine it, modify it, then destroy it.

**Clean up after each section:** Run `terraform destroy` after completing each tutorial to avoid Azure charges.

**Use the scripts:** Section 3 includes shell scripts for setting up remote state storage. Make them executable with `chmod +x`.

## Repository structure

```
├── 1-terraform-basics/
│   ├── 1-terraform-installation/
│   ├── 2-terraform-commands/
│   ├── 3-terraform-resources/
│   └── 4-terraform-azure-provider/
├── 2-terraform-variables/
├── 3-terraform-state/
│   ├── local-state-example/
│   ├── remote-state-example/
│   └── scripts/
├── 4-terraform-advanced/
│   ├── 1-depends-on/
│   ├── 2-for-each/
│   ├── 3-count/
│   ├── 4-conditional-expressions/
│   └── 5-dynamic-blocks/
├── 5-secret-management-azure/
├── 6-terraform-modules/
├── 7-terraform-azapi/
├── 8-terraform-testing/
├── 9-terraform-import/
├── 10-state-management-commands/
├── 11-preconditions-postconditions/
├── 12-terraform-functions/
└── 13-terraform-mcp-server/
```

## Quick start

### How the tutorials are organized

Sections are numbered **1- through 13-** to guide you through a learning path:

- **1-terraform-basics/** - Installation, setup, and first deployment
- **2-terraform-variables/** - Making code reusable
- **3-terraform-state/** - Understanding state management
- **4-terraform-advanced/** - Loops, conditionals, and dependencies
- ...and so on through **13-terraform-mcp-server/**

Each section folder contains:
- `README.md` - Overview and links to tutorials
- Numbered markdown files (e.g., `1-terraform-install.md`)
- `examples/` or `terraform/` folders with working code

**Work through sections in order.** Each builds on concepts from previous sections.

### Get started now

```bash
# 1. Clone this repository
git clone https://github.com/thomast1906/terraform-on-azure.git
cd terraform-on-azure

# 2. Start with section 1
cd 1-terraform-basics

# 3. Follow the README to install Terraform and configure your environment
```

Section 1 covers installing Terraform, setting up VS Code, authenticating to Azure, and deploying a first resource group.

Section 3 adds remote state. Section 13 covers AI assistance for Terraform.

**Start here:** [1. Terraform basics](1-terraform-basics/) →

## Get help

- **Issues:** Found a problem or have a suggestion? [Open an issue](https://github.com/thomast1906/terraform-on-azure/issues)
- **Questions:** Stuck on something? Open a discussion or issue

## Contributing

Want to add a tutorial or fix something? Contributions welcome! Open a pull request with your changes.

## Azure costs

Most examples use free or low-cost resources. Always run `terraform destroy` when done to avoid charges.

## What's new

**February 2026 updates:**
- Refreshed all content to latest Terraform and Azure provider versions
- Added Terraform MCP server integration guide
- New testing approaches section with terraform test framework
- Terraform import tutorial for existing resources
- Pre-conditions and post-conditions for validation
- Terraform functions guide with Azure examples
- State management commands (terraform state mv)
- Rewrote all tutorials in step-by-step format
- Updated examples to match current provider behavior

## Next steps

Ready to begin? Start with [section 1: Terraform basics](1-terraform-basics/).



