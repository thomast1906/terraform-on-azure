#!/bin/bash
# bulk-import.sh - Script to import multiple Azure resources into Terraform

set -e

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_status $BLUE "🔍 Checking prerequisites..."
    
    if ! command -v terraform &> /dev/null; then
        print_status $RED "❌ Terraform not found. Please install Terraform."
        exit 1
    fi
    
    if ! command -v az &> /dev/null; then
        print_status $RED "❌ Azure CLI not found. Please install Azure CLI."
        exit 1
    fi
    
    # Check if logged into Azure
    if ! az account show &> /dev/null; then
        print_status $RED "❌ Not logged into Azure. Please run 'az login'"
        exit 1
    fi
    
    print_status $GREEN "✅ Prerequisites check passed"
}

# Import a single resource
import_resource() {
    local tf_address=$1
    local azure_id=$2
    local description=$3
    
    print_status $YELLOW "📥 Importing $description..."
    print_status $BLUE "   Terraform Address: $tf_address"
    print_status $BLUE "   Azure Resource ID: $azure_id"
    
    if terraform import "$tf_address" "$azure_id"; then
        print_status $GREEN "✅ Successfully imported $description"
    else
        print_status $RED "❌ Failed to import $description"
        return 1
    fi
}

# Main import function
main() {
    print_status $BLUE "🚀 Starting bulk import process..."
    
    check_prerequisites
    
    # Initialize Terraform
    print_status $YELLOW "🔧 Initializing Terraform..."
    terraform init
    
    # Get current subscription ID
    SUBSCRIPTION_ID=$(az account show --query id -o tsv)
    print_status $BLUE "📋 Using subscription: $SUBSCRIPTION_ID"
    
    # Example resource definitions - modify as needed
    declare -a RESOURCES=(
        "azurerm_resource_group.imported_rg:/subscriptions/$SUBSCRIPTION_ID/resourceGroups/existing-rg:Resource Group"
        "azurerm_storage_account.imported_storage:/subscriptions/$SUBSCRIPTION_ID/resourceGroups/existing-rg/providers/Microsoft.Storage/storageAccounts/existingstorage:Storage Account"
        # Add more resources as needed
    )
    
    # Import each resource
    local import_count=0
    local success_count=0
    
    for resource in "${RESOURCES[@]}"; do
        IFS=':' read -r tf_address azure_id description <<< "$resource"
        
        if [ -n "$tf_address" ] && [ -n "$azure_id" ] && [ -n "$description" ]; then
            import_count=$((import_count + 1))
            if import_resource "$tf_address" "$azure_id" "$description"; then
                success_count=$((success_count + 1))
            fi
        fi
    done
    
    # Summary
    print_status $BLUE "📊 Import Summary:"
    print_status $BLUE "   Total resources: $import_count"
    print_status $GREEN "   Successfully imported: $success_count"
    print_status $RED "   Failed: $((import_count - success_count))"
    
    if [ $success_count -eq $import_count ]; then
        print_status $GREEN "🎉 All resources imported successfully!"
    else
        print_status $YELLOW "⚠️  Some imports failed. Please check the output above."
    fi
    
    # Run plan to show current state
    print_status $YELLOW "🔍 Running terraform plan to show current state..."
    terraform plan
}

# Usage information
usage() {
    echo "Usage: $0 [options]"
    echo ""
    echo "Options:"
    echo "  -h, --help     Show this help message"
    echo ""
    echo "Before running this script:"
    echo "1. Ensure you have the corresponding Terraform configuration"
    echo "2. Modify the RESOURCES array in the script with your actual resource IDs"
    echo "3. Run 'az login' to authenticate with Azure"
    echo ""
    echo "Example configuration structure:"
    echo "  resource \"azurerm_resource_group\" \"imported_rg\" {"
    echo "    name     = \"existing-rg\""
    echo "    location = \"East US\""
    echo "  }"
}

# Command line argument handling
case "${1:-}" in
    -h|--help)
        usage
        exit 0
        ;;
    *)
        main "$@"
        ;;
esac