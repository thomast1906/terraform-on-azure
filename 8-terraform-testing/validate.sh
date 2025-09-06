#!/bin/bash
# validate.sh - Comprehensive Terraform validation script

set -e

echo "🚀 Starting Terraform validation pipeline..."

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    local color=$1
    local message=$2
    echo -e "${color}${message}${NC}"
}

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

print_status $YELLOW "🔍 Step 1: Checking prerequisites..."

# Check Terraform
if command_exists terraform; then
    print_status $GREEN "✅ Terraform found: $(terraform version -json | jq -r '.terraform_version')"
else
    print_status $RED "❌ Terraform not found. Please install Terraform."
    exit 1
fi

# Check tflint
if command_exists tflint; then
    print_status $GREEN "✅ TFLint found: $(tflint --version)"
else
    print_status $YELLOW "⚠️  TFLint not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install tflint
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
    else
        print_status $RED "❌ Please install tflint manually for your OS"
        exit 1
    fi
fi

print_status $YELLOW "🔍 Step 2: Format validation..."
if terraform fmt -check=true -diff=true; then
    print_status $GREEN "✅ Terraform formatting is correct"
else
    print_status $RED "❌ Terraform formatting issues found. Run 'terraform fmt' to fix."
    exit 1
fi

print_status $YELLOW "🔍 Step 3: Syntax validation..."
if terraform validate; then
    print_status $GREEN "✅ Terraform validation passed"
else
    print_status $RED "❌ Terraform validation failed"
    exit 1
fi

print_status $YELLOW "🔍 Step 4: TFLint analysis..."
# Initialize tflint if config exists
if [ -f ".tflint.hcl" ]; then
    tflint --init
fi

if tflint; then
    print_status $GREEN "✅ TFLint analysis passed"
else
    print_status $RED "❌ TFLint found issues"
    exit 1
fi

print_status $YELLOW "🔍 Step 5: Security scanning with Checkov (if available)..."
if command_exists checkov; then
    if checkov -d . --compact; then
        print_status $GREEN "✅ Security scan passed"
    else
        print_status $YELLOW "⚠️  Security issues found. Review checkov output."
    fi
else
    print_status $YELLOW "⚠️  Checkov not found. Install with 'pip install checkov' for security scanning."
fi

print_status $YELLOW "🔍 Step 6: Plan validation..."
terraform init -backend=false
if terraform plan -out=tfplan; then
    print_status $GREEN "✅ Terraform plan created successfully"
    rm -f tfplan
else
    print_status $RED "❌ Terraform plan failed"
    exit 1
fi

print_status $GREEN "🎉 All validation checks passed!"
print_status $YELLOW "💡 Remember to:"
print_status $YELLOW "   - Review any warnings from the tools"
print_status $YELLOW "   - Test in a development environment"
print_status $YELLOW "   - Run 'terraform destroy' after testing"