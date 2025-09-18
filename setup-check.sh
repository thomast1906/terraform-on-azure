#!/bin/bash

# Terraform Learning Environment Validation Script
# This script validates that all required tools are installed and configured

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    case $1 in
        "success") echo -e "${GREEN}✅ $2${NC}" ;;
        "error")   echo -e "${RED}❌ $2${NC}" ;;
        "warning") echo -e "${YELLOW}⚠️  $2${NC}" ;;
        "info")    echo -e "${BLUE}ℹ️  $2${NC}" ;;
    esac
}

print_header() {
    echo -e "\n${BLUE}$1${NC}"
    echo "=================================="
}

print_header "🚀 Terraform on Azure - Environment Validation"

# Check Terraform installation
print_header "📦 Checking Tool Installations"

if command -v terraform &> /dev/null; then
    TERRAFORM_VERSION=$(terraform version -json | jq -r '.terraform_version')
    print_status "success" "Terraform $TERRAFORM_VERSION installed"
    
    # Check if version is modern enough
    if [[ $(echo "$TERRAFORM_VERSION" | cut -d. -f1) -ge 1 ]] && [[ $(echo "$TERRAFORM_VERSION" | cut -d. -f2) -ge 5 ]]; then
        print_status "success" "Terraform version is modern (>= 1.5.0)"
    else
        print_status "warning" "Terraform version $TERRAFORM_VERSION is older than recommended (1.5.0+)"
    fi
else
    print_status "error" "Terraform not installed"
    echo "  Install from: https://developer.hashicorp.com/terraform/downloads"
    exit 1
fi

# Check Azure CLI
if command -v az &> /dev/null; then
    AZ_VERSION=$(az version --output tsv --query '"azure-cli"')
    print_status "success" "Azure CLI $AZ_VERSION installed"
else
    print_status "error" "Azure CLI not installed"
    echo "  Install from: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
    exit 1
fi

# Check optional tools
print_header "🔧 Checking Optional Tools"

if command -v tflint &> /dev/null; then
    TFLINT_VERSION=$(tflint --version | head -n1 | cut -d' ' -f3)
    print_status "success" "TFLint $TFLINT_VERSION installed"
else
    print_status "warning" "TFLint not installed (recommended for linting)"
    echo "  Install from: https://github.com/terraform-linters/tflint"
fi

if command -v checkov &> /dev/null; then
    CHECKOV_VERSION=$(checkov --version)
    print_status "success" "Checkov $CHECKOV_VERSION installed"
else
    print_status "warning" "Checkov not installed (recommended for security scanning)"
    echo "  Install: pip install checkov"
fi

if command -v code &> /dev/null; then
    print_status "success" "VS Code installed"
    
    # Check for Terraform extension
    if code --list-extensions | grep -q "hashicorp.terraform"; then
        print_status "success" "HashiCorp Terraform VS Code extension installed"
    else
        print_status "warning" "HashiCorp Terraform VS Code extension not installed"
        echo "  Install: code --install-extension hashicorp.terraform"
    fi
else
    print_status "info" "VS Code not found (optional but recommended)"
fi

# Check Azure authentication
print_header "🔐 Checking Azure Authentication"

if az account show &> /dev/null; then
    SUBSCRIPTION_NAME=$(az account show --query name -o tsv)
    SUBSCRIPTION_ID=$(az account show --query id -o tsv)
    print_status "success" "Authenticated with Azure"
    print_status "info" "Current subscription: $SUBSCRIPTION_NAME ($SUBSCRIPTION_ID)"
else
    print_status "error" "Not authenticated with Azure"
    echo "  Run: az login"
    exit 1
fi

# Check Terraform configuration validation
print_header "🧪 Testing Terraform Configuration"

# Create a temporary test directory
TEST_DIR=$(mktemp -d)
cd "$TEST_DIR"

# Create a minimal test configuration
cat > main.tf << 'EOF'
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

# Test data source (doesn't create resources)
data "azurerm_client_config" "current" {}

output "test_output" {
  value = "Terraform configuration is valid!"
}
EOF

# Test terraform commands
if terraform init -backend=false &> /dev/null; then
    print_status "success" "Terraform init working"
else
    print_status "error" "Terraform init failed"
    cd - > /dev/null
    rm -rf "$TEST_DIR"
    exit 1
fi

if terraform validate &> /dev/null; then
    print_status "success" "Terraform validate working"
else
    print_status "error" "Terraform validate failed"
    cd - > /dev/null
    rm -rf "$TEST_DIR"
    exit 1
fi

if terraform plan &> /dev/null; then
    print_status "success" "Terraform plan working (Azure authentication OK)"
else
    print_status "error" "Terraform plan failed (check Azure authentication)"
    cd - > /dev/null
    rm -rf "$TEST_DIR"
    exit 1
fi

# Cleanup
cd - > /dev/null
rm -rf "$TEST_DIR"

# Final summary
print_header "📊 Validation Summary"

print_status "success" "All essential tools are installed and configured!"
print_status "info" "You're ready to start the Terraform on Azure learning journey"

echo ""
echo -e "${GREEN}🎓 Ready to start learning?${NC}"
echo "1. Begin with Section 1: Terraform Basics"
echo "2. Work through each section sequentially"
echo "3. Practice with the hands-on examples"
echo "4. Remember to destroy resources after each section to avoid costs"
echo ""
echo -e "${BLUE}Happy learning! 🚀${NC}"