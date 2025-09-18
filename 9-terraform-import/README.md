# Terraform Import - Managing Existing Azure Resources

One of the most common real-world scenarios is incorporating existing Azure infrastructure into Terraform management. This section teaches you how to import existing resources, manage brownfield environments, and migrate from other IaC tools.

## 🎯 Learning Objectives

By completing this section, you will learn how to:
- **Import** existing Azure resources into Terraform state
- **Generate** Terraform configuration from existing infrastructure
- **Migrate** from Azure Resource Manager templates to Terraform
- **Handle** complex resource dependencies during import
- **Validate** imported resources and state consistency

## 📋 Prerequisites

- Completed sections 1-8 of this learning path
- Existing Azure resources to practice with (or create sample resources)
- Understanding of Terraform state management
- Azure CLI configured and authenticated

## 🔄 Understanding Terraform Import

### When to Use Import

**Common Scenarios:**
- **Existing Infrastructure** - Resources created outside Terraform
- **Team Migration** - Moving from ARM templates or manual processes
- **Partial Adoption** - Gradually adopting Terraform for existing workloads
- **Disaster Recovery** - Recreating lost Terraform state
- **Resource Conflicts** - Resolving "already exists" errors

### Import Process Overview

#### Modern Import Blocks (Terraform >= 1.5) - **Recommended**
```hcl
# Define import blocks in your configuration
import {
  to = azurerm_resource_group.imported
  id = "/subscriptions/{subscription-id}/resourceGroups/existing-rg"
}

resource "azurerm_resource_group" "imported" {
  name     = "existing-rg"
  location = "East US"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

#### Legacy Import Command (Still Supported)
```bash
# 1. Write Terraform configuration for the resource
# 2. Import the resource into state
terraform import <resource_type>.<resource_name> <resource_id>

# 3. Verify and adjust configuration
terraform plan

# 4. Test with plan/apply cycle
terraform apply
```

### Benefits of Import Blocks

- **Configuration as Code** - Import definitions are part of your Terraform configuration
- **Reproducible** - Import process can be version controlled and shared
- **Plannable** - You can see what will be imported with `terraform plan`
- **Safe** - Import blocks can be safely committed without triggering imports
- **Reviewable** - Import operations can be code-reviewed like any other change

## 1. Basic Resource Import with Import Blocks

### Example: Importing a Resource Group

**Step 1: Create existing resource (if needed)**
```bash
# Create a resource group outside Terraform for demonstration
az group create --name "existing-rg" --location "East US"
```

**Step 2: Write Terraform configuration with import block**
```hcl
# main.tf
terraform {
  required_version = ">= 1.5"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.80"
    }
  }
}

provider "azurerm" {
  features {}
}

# Import block - defines what to import
import {
  to = azurerm_resource_group.imported
  id = "/subscriptions/{subscription-id}/resourceGroups/existing-rg"
}

# Resource configuration for the existing resource group
resource "azurerm_resource_group" "imported" {
  name     = "existing-rg"
  location = "East US"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    ImportedOn  = "2024-01-01"
  }
}
```

**Step 3: Plan and apply the import**
```bash
# Initialize Terraform
terraform init

# Plan to see what will be imported
terraform plan

# Apply to perform the import
terraform apply

# Verify the import
terraform show
```

**Step 4: Remove import blocks after successful import**
```hcl
# Remove the import block after successful import
# import {
#   to = azurerm_resource_group.imported
#   id = "/subscriptions/{subscription-id}/resourceGroups/existing-rg"
# }

# Keep only the resource configuration
resource "azurerm_resource_group" "imported" {
  name     = "existing-rg"
  location = "East US"
  
  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
    ImportedOn  = "2024-01-01"
  }
}
```

**Step 5: Validate configuration**
```bash
# Check for differences after removing import block
terraform plan

# If plan shows unwanted changes, adjust configuration to match actual resource
terraform apply
```

## 📚 Additional Resources

- [Terraform Import Blocks Documentation](https://developer.hashicorp.com/terraform/language/import)
- [Azure Resource ID Formats](https://docs.microsoft.com/en-us/azure/azure-resource-manager/management/resource-name-rules)
- [Terraformer Tool](https://github.com/GoogleCloudPlatform/terraformer)
- [AzAPI Provider for Latest Azure Features](https://registry.terraform.io/providers/Azure/azapi/latest)
- [Terraform State Management Best Practices](https://developer.hashicorp.com/terraform/tutorials/state)

## 🎯 Key Takeaways

- **Import is not migration** - You still need to write proper Terraform configuration
- **Order matters** - Import dependent resources in the correct sequence  
- **Validate everything** - Always run `terraform plan` after import
- **Backup state** - Protect your existing Terraform state before import operations
- **Practice first** - Test import procedures in development environments

**Next Step:** Ready to set up CI/CD for your Terraform? Continue to [Section 10: Terraform CI/CD with GitHub Actions](../10-terraform-cicd/)

---

*Import is your bridge between existing infrastructure and Infrastructure as Code.* 🌉