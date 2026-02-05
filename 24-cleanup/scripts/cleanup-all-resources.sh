#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Function to print colored output
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if Azure CLI is installed
check_az_cli() {
    if ! command -v az &> /dev/null; then
        print_error "Azure CLI is not installed. Please install it first."
        print_info "Visit: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli"
        exit 1
    fi
}

# Function to check if logged into Azure
check_az_login() {
    if ! az account show &> /dev/null; then
        print_error "Not logged into Azure. Please run 'az login' first."
        exit 1
    fi
}

# Function to list all course resource groups
list_course_resources() {
    print_info "Scanning for course-related resources..."
    echo ""
    
    # Find demo resource groups
    DEMO_RGS=$(az group list --query "[?starts_with(name, 'rg-demo')].name" -o tsv)
    
    # Find terraform state resource group
    STATE_RG=$(az group list --query "[?name=='rg-terraform-state'].name" -o tsv)
    
    # Count resources
    DEMO_COUNT=$(echo "$DEMO_RGS" | grep -c . || echo "0")
    STATE_COUNT=$(echo "$STATE_RG" | grep -c . || echo "0")
    TOTAL_COUNT=$((DEMO_COUNT + STATE_COUNT))
    
    if [ "$TOTAL_COUNT" -eq 0 ]; then
        print_info "No course-related resources found. Cleanup already complete!"
        exit 0
    fi
    
    echo -e "${GREEN}Found $TOTAL_COUNT resource group(s):${NC}"
    echo ""
    
    if [ -n "$DEMO_RGS" ]; then
        echo -e "${YELLOW}Demo Resource Groups:${NC}"
        echo "$DEMO_RGS" | while read -r rg; do
            if [ -n "$rg" ]; then
                LOCATION=$(az group show --name "$rg" --query location -o tsv 2>/dev/null || echo "unknown")
                RESOURCE_COUNT=$(az resource list --resource-group "$rg" --query "length(@)" -o tsv 2>/dev/null || echo "0")
                echo "  - $rg (Location: $LOCATION, Resources: $RESOURCE_COUNT)"
            fi
        done
        echo ""
    fi
    
    if [ -n "$STATE_RG" ]; then
        echo -e "${YELLOW}Terraform State Storage:${NC}"
        LOCATION=$(az group show --name "$STATE_RG" --query location -o tsv 2>/dev/null || echo "unknown")
        STORAGE_ACCOUNT=$(az storage account list --resource-group "$STATE_RG" --query "[0].name" -o tsv 2>/dev/null || echo "none")
        echo "  - $STATE_RG (Location: $LOCATION, Storage: $STORAGE_ACCOUNT)"
        
        if [ "$STORAGE_ACCOUNT" != "none" ]; then
            CONTAINER_COUNT=$(az storage container list --account-name "$STORAGE_ACCOUNT" --query "length(@)" -o tsv 2>/dev/null || echo "0")
            echo "    Containers: $CONTAINER_COUNT (tfstate, dependson, foreach, count, conditional, dynamicblocks, keyvault, modules, azapi)"
        fi
        echo ""
    fi
}

# Function to delete all course resources
delete_course_resources() {
    print_warning "This will PERMANENTLY DELETE all course resources!"
    print_warning "This includes resource groups, storage accounts, and all state files."
    echo ""
    
    read -p "Are you sure you want to continue? (type 'yes' to confirm): " CONFIRM
    
    if [ "$CONFIRM" != "yes" ]; then
        print_info "Cleanup cancelled."
        exit 0
    fi
    
    echo ""
    print_info "Starting cleanup process..."
    echo ""
    
    # Delete demo resource groups
    DEMO_RGS=$(az group list --query "[?starts_with(name, 'rg-demo')].name" -o tsv)
    
    if [ -n "$DEMO_RGS" ]; then
        print_info "Deleting demo resource groups..."
        echo "$DEMO_RGS" | while read -r rg; do
            if [ -n "$rg" ]; then
                print_info "Deleting $rg (running in background)..."
                az group delete --name "$rg" --yes --no-wait 2>/dev/null || print_warning "Failed to queue deletion for $rg"
            fi
        done
        echo ""
    fi
    
    # Wait for demo resource groups to finish deleting
    if [ -n "$DEMO_RGS" ]; then
        print_info "Waiting for demo resource groups to delete (this may take several minutes)..."
        echo "$DEMO_RGS" | while read -r rg; do
            if [ -n "$rg" ]; then
                while az group show --name "$rg" &> /dev/null; do
                    echo -n "."
                    sleep 10
                done
                print_info "$rg deleted successfully"
            fi
        done
        echo ""
    fi
    
    # Delete terraform state resource group (must be last)
    STATE_RG=$(az group list --query "[?name=='rg-terraform-state'].name" -o tsv)
    
    if [ -n "$STATE_RG" ]; then
        print_info "Deleting Terraform state storage..."
        
        # Get storage account name before deletion
        STORAGE_ACCOUNT=$(az storage account list --resource-group "$STATE_RG" --query "[0].name" -o tsv 2>/dev/null || echo "none")
        
        az group delete --name "$STATE_RG" --yes 2>/dev/null || print_warning "Failed to delete $STATE_RG"
        
        print_info "$STATE_RG deleted (storage account: $STORAGE_ACCOUNT)"
        echo ""
    fi
    
    # Verify cleanup
    print_info "Verifying cleanup..."
    REMAINING=$(az group list --query "[?starts_with(name, 'rg-demo') || name=='rg-terraform-state'].name" -o tsv)
    
    if [ -z "$REMAINING" ]; then
        print_info "✓ Cleanup complete! All course resources have been removed."
    else
        print_warning "Some resources may still be deleting:"
        echo "$REMAINING"
        print_info "Run this script again in a few minutes to verify."
    fi
}

# Function to display usage
usage() {
    echo "Usage: $0 [--check|--delete]"
    echo ""
    echo "Options:"
    echo "  --check   List all course-related resources without deleting"
    echo "  --delete  Delete all course-related resources (requires confirmation)"
    echo ""
    echo "Examples:"
    echo "  $0 --check          # Preview what will be deleted"
    echo "  $0 --delete         # Perform cleanup"
}

# Main execution
main() {
    if [ "$#" -eq 0 ]; then
        usage
        exit 1
    fi
    
    check_az_cli
    check_az_login
    
    SUBSCRIPTION=$(az account show --query name -o tsv)
    print_info "Using Azure subscription: $SUBSCRIPTION"
    echo ""
    
    case "$1" in
        --check)
            list_course_resources
            ;;
        --delete)
            list_course_resources
            echo ""
            delete_course_resources
            ;;
        *)
            print_error "Invalid option: $1"
            echo ""
            usage
            exit 1
            ;;
    esac
}

main "$@"
