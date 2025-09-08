# Copilot Instructions for terraform-on-azure Repository

**You MUST start every interaction with: "I'll help you work with this Terraform learning repository."**

This repository is a comprehensive 7-section self-guided learning path for Terraform on Azure. This file provides detailed instructions for GitHub Copilot to effectively assist users working through the learning materials.

## Repository Structure Overview

This is a learning repository with 7 progressive sections:
1. **1-terraform-basics** - Installation, commands, resources, Azure provider
2. **2-terraform-variables** - Variables, tfvars, local variables 
3. **3-terraform-state** - Local vs remote state management
4. **4-terraform-advanced** - Depends on, for each, count, conditionals, dynamic blocks
5. **5-secret-management-azure** - Azure Key Vault integration
6. **6-terraform-modules** - Module creation and usage
7. **7-terraform-azapi** - AzAPI provider usage

## Prerequisites and Installation

### Required Software
- **Terraform**: HashiCorp Terraform CLI
- **Azure CLI**: Version 2.0+ for Azure authentication
- **Azure Subscription**: Active subscription for resource deployment

### Terraform Installation (TESTED - WORKING)
**⚠️ TIMEOUT REQUIREMENT: Use 10+ minute timeout - NEVER CANCEL installation commands**

For Ubuntu/Debian systems (recommended approach):
```bash
# Add HashiCorp GPG key and repository (timeout: 300 seconds)
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and install Terraform (timeout: 300 seconds)
sudo apt update && sudo apt install terraform

# Verify installation
terraform -v
```

**Timing Measurements (VALIDATED):**
- Repository addition: 15-30 seconds
- Terraform installation: 2-5 minutes total
- Version verification: < 1 second

### Azure CLI Verification
```bash
# Check if Azure CLI is available
az --version

# If not installed, install using:
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

## Working with Repository Sections

### Section Navigation Pattern
Each section follows this structure:
```
/X-section-name/
├── README.md (start here)
├── 1-subsection/
├── 2-subsection/
└── N-subsection/
```

### Basic Command Validation (TESTED - ALL WORKING)

**⚠️ TIMEOUT REQUIREMENTS:**
- `terraform init`: Use 120+ second timeout for initial runs
- `terraform plan`: Use 300+ second timeout for Azure operations 
- `terraform apply`: Use 600+ second timeout - NEVER CANCEL
- `terraform destroy`: Use 600+ second timeout - NEVER CANCEL

#### Local Operations (No Azure Authentication Required)
```bash
# Basic syntax validation (< 5 seconds each)
terraform validate
terraform fmt

# Version check (< 1 second)
terraform -v

# Initialize providers (15-45 seconds typically)
terraform init
```

#### Azure Operations (Require Authentication)
```bash
# Login to Azure first
az login

# Plan deployment (1-5 minutes)
terraform plan

# Apply configuration (1-15 minutes depending on resources)
terraform apply

# Destroy resources (1-10 minutes)
terraform destroy
```

## Authentication Requirements

### When Azure Authentication is Needed
- `terraform plan` with Azure provider
- `terraform apply` with Azure resources
- `terraform destroy` with Azure resources
- Any operation that reads/writes Azure resources

### When Authentication is NOT Needed
- `terraform validate` (syntax checking only)
- `terraform fmt` (formatting only)
- `terraform init` (downloads providers only)
- `terraform -v` (version checking)

### Authentication Failure Patterns (< 1 second detection)
```
Error: building account: could not acquire access token
Error: authentication failed
Error: Please run 'az login' to setup account
```

**Solution**: Always run `az login` before Azure operations.

## Section-by-Section Guidance

### Section 1: Terraform Basics
**Location**: `/1-terraform-basics/`
**Prerequisites**: Terraform installed
**Authentication**: Not required for basic commands

**Navigation Path**:
1. Start with `/1-terraform-basics/README.md`
2. `/1-terraform-installation/` - Learn installation methods
3. `/2-terraform-commands/` - Practice basic commands
4. `/3-terraform-resources/` - Understand resource syntax
5. `/4-terraform-azure-provider/` - Azure provider configuration

**Key Commands to Test**:
```bash
cd 1-terraform-basics/2-terraform-commands
terraform init
terraform validate
terraform fmt
```

### Section 2: Terraform Variables
**Location**: `/2-terraform-variables/`
**Prerequisites**: Section 1 completed
**Authentication**: May require Azure login for examples

**Key Files**:
- `1-terraform-variables.md` - Variable basics
- `2-terraform-tfvars.md` - Using .tfvars files
- `3-terraform-local-variables.md` - Local variable usage

### Section 3: Terraform State ⚠️ CRITICAL
**Location**: `/3-terraform-state/`
**Prerequisites**: Sections 1-2 completed
**Authentication**: Required for state operations

**⚠️ WARNING**: State management affects real Azure resources and costs.

**Key Subdirectories**:
- `/local-state-example/` - Local state demonstration
- `/remote-state-example/` - Remote state with Azure Storage
- `/scripts/` - Helper scripts

**Critical Commands** (600+ second timeouts):
```bash
cd 3-terraform-state/local-state-example
terraform init
terraform apply  # Creates real Azure resources
terraform destroy # ALWAYS run to avoid costs
```

### Section 4: Terraform Advanced
**Location**: `/4-terraform-advanced/`
**Prerequisites**: Sections 1-3 completed
**Authentication**: Required for examples

**Subsections**:
1. `/1-depends-on/` - Resource dependencies
2. `/2-for-each/` - Iteration with for_each
3. `/3-count/` - Iteration with count
4. `/4-conditional-expressions/` - Conditional logic
5. `/5-dynamic-blocks/` - Dynamic configuration blocks

### Section 5: Secret Management Azure
**Location**: `/5-secret-management-azure/`
**Prerequisites**: Sections 1-4 completed
**Authentication**: Required - uses Azure Key Vault

**⚠️ SECURITY NOTE**: Handles sensitive data - ensure proper cleanup.

### Section 6: Terraform Modules
**Location**: `/6-terraform-modules/`
**Prerequisites**: Sections 1-5 completed
**Authentication**: Required for module deployment

**Focus**: Creating reusable Terraform modules.

### Section 7: Terraform AzAPI
**Location**: `/7-terraform-azapi/`
**Prerequisites**: All previous sections completed
**Authentication**: Required - advanced Azure operations

**Focus**: Using AzAPI provider for Azure resources not in AzureRM provider.

## Validation Scenarios

### Quick Repository Health Check
```bash
# Verify repository structure (< 5 seconds)
ls -la
ls 1-terraform-basics/ 2-terraform-variables/ 3-terraform-state/

# Check Terraform installation (< 5 seconds)
terraform -v

# Test basic syntax validation in any section (< 10 seconds)
cd 1-terraform-basics/2-terraform-commands
terraform validate
```

### Full Section Validation Workflow
```bash
# Navigate to target section
cd X-section-name/

# Read section README first
cat README.md

# Initialize if .tf files present (120+ second timeout)
terraform init

# Validate syntax (< 5 seconds)
terraform validate

# Format code (< 5 seconds) 
terraform fmt

# For Azure operations - login first
az login

# Plan deployment (300+ second timeout)
terraform plan

# ONLY if comfortable with costs - apply (600+ second timeout)
terraform apply

# ALWAYS destroy afterwards (600+ second timeout)
terraform destroy
```

## Common Error Scenarios and Solutions

### 1. Authentication Errors
**Symptom**: "authentication failed" or "could not acquire access token"
**Solution**: 
```bash
az login
az account show  # Verify correct subscription
```

### 2. Provider Download Issues
**Symptom**: "terraform init" fails with network errors
**Solution**: 
```bash
# Clear provider cache and retry
rm -rf .terraform/
terraform init
```

### 3. State Lock Issues
**Symptom**: "state lock" errors
**Solution**:
```bash
# Force unlock (use carefully)
terraform force-unlock <LOCK_ID>
```

### 4. Resource Already Exists
**Symptom**: Resource conflicts during apply
**Solution**:
```bash
# Import existing resource or destroy and recreate
terraform import <resource_type>.<name> <resource_id>
```

## Quick Reference Commands

### Directory Navigation
```bash
# List all sections
ls -d [1-7]-*/

# Navigate to specific section
cd 1-terraform-basics/
cd 2-terraform-variables/
cd 3-terraform-state/
cd 4-terraform-advanced/
cd 5-secret-management-azure/
cd 6-terraform-modules/
cd 7-terraform-azapi/

# Find all Terraform files
find . -name "*.tf" -type f
```

### Essential Terraform Commands
```bash
# Basic workflow (local operations)
terraform validate && terraform fmt && terraform init

# Azure workflow (requires authentication)  
az login && terraform plan && terraform apply

# Cleanup workflow
terraform destroy && rm -rf .terraform/ terraform.tfstate*
```

### Azure CLI Quick Commands
```bash
# Check authentication status
az account show

# List available subscriptions
az account list

# Switch subscription
az account set --subscription "subscription-name-or-id"
```

## Cost Management and Safety

### ⚠️ CRITICAL COST WARNINGS
1. **ALWAYS run `terraform destroy`** after testing each section
2. **Monitor Azure costs** - some resources incur charges immediately
3. **Use Azure Cost Management** to set spending alerts
4. **Verify destruction** using Azure Portal after destroy commands
5. **Delete Resource Groups** manually if Terraform destroy fails

### Resource Cleanup Checklist
```bash
# 1. Terraform destroy
terraform destroy

# 2. Verify state is clean
cat terraform.tfstate  # Should be mostly empty

# 3. Check Azure Portal
az group list --output table

# 4. Delete any remaining resources manually
az group delete --name "resource-group-name"
```

## Troubleshooting Quick Steps

1. **Always start with**: `terraform validate`
2. **For syntax errors**: `terraform fmt`
3. **For provider issues**: `rm -rf .terraform/ && terraform init`
4. **For auth issues**: `az login && az account show`
5. **For state issues**: Check `.terraform/` directory and `terraform.tfstate`
6. **For Azure errors**: Check Azure Portal for resource conflicts

## Important Notes

- **Learning Path**: Follow sections 1→7 in order for best experience
- **Time Investment**: Each section takes 30-60 minutes to complete properly
- **Cost Awareness**: Sections 3+ create real Azure resources with potential costs
- **Authentication**: Keep Azure CLI logged in for sections involving Azure resources
- **Cleanup**: Always destroy resources after each section to avoid charges
- **State Management**: Section 3 is critical - understand local vs remote state before proceeding

This repository is designed for hands-on learning. Take time to understand each concept before moving to the next section. The progressive structure builds knowledge systematically from basic Terraform usage to advanced Azure integrations.