# Terraform on Azure - Makefile for common operations
# Usage: make <target>

.PHONY: help install-tools validate lint format security docs clean check-all

# Default target
help:
	@echo "Available targets:"
	@echo "  install-tools  - Install required development tools"
	@echo "  validate      - Validate all Terraform configurations"
	@echo "  lint          - Run TFLint on all configurations" 
	@echo "  format        - Format all Terraform files"
	@echo "  security      - Run security checks with Checkov"
	@echo "  docs          - Generate documentation"
	@echo "  clean         - Clean up temporary files"
	@echo "  check-all     - Run all checks (validate, lint, format, security)"
	@echo "  help          - Show this help message"

# Install development tools
install-tools:
	@echo "Installing development tools..."
	@command -v terraform >/dev/null 2>&1 || (echo "Please install Terraform first" && exit 1)
	@command -v tflint >/dev/null 2>&1 || (echo "Installing TFLint..." && \
		curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash)
	@command -v checkov >/dev/null 2>&1 || (echo "Installing Checkov..." && pip install checkov)
	@command -v terraform-docs >/dev/null 2>&1 || (echo "Installing terraform-docs..." && \
		curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-$$(uname | tr '[:upper:]' '[:lower:]')-amd64.tar.gz && \
		tar -xzf terraform-docs.tar.gz && \
		chmod +x terraform-docs && \
		sudo mv terraform-docs /usr/local/bin/ && \
		rm terraform-docs.tar.gz)
	@echo "✅ All tools installed!"

# Validate all Terraform configurations
validate:
	@echo "🔍 Validating Terraform configurations..."
	@find . -name "*.tf" -not -path "./.terraform/*" | xargs -I {} dirname {} | sort -u | while read dir; do \
		echo "Validating: $$dir"; \
		cd "$$dir"; \
		terraform init -backend=false >/dev/null 2>&1; \
		terraform validate; \
		cd - >/dev/null; \
	done
	@echo "✅ Validation completed!"

# Run TFLint on all configurations
lint:
	@echo "🔍 Running TFLint analysis..."
	@find . -name "*.tf" -not -path "./.terraform/*" | xargs -I {} dirname {} | sort -u | while read dir; do \
		echo "Linting: $$dir"; \
		cd "$$dir"; \
		if [ -f ".tflint.hcl" ]; then tflint --init >/dev/null 2>&1; fi; \
		tflint; \
		cd - >/dev/null; \
	done
	@echo "✅ Linting completed!"

# Format all Terraform files
format:
	@echo "🎨 Formatting Terraform files..."
	@terraform fmt -recursive
	@echo "✅ Formatting completed!"

# Run security checks
security:
	@echo "🔒 Running security checks..."
	@checkov -d . --framework terraform --compact --quiet || true
	@echo "✅ Security scan completed!"

# Generate documentation
docs:
	@echo "📚 Generating documentation..."
	@command -v terraform-docs >/dev/null 2>&1 || (echo "terraform-docs not found. Run 'make install-tools' first." && exit 1)
	@find . -name "*.tf" -not -path "./.terraform/*" | xargs -I {} dirname {} | sort -u | while read dir; do \
		if [ -f "$$dir/main.tf" ]; then \
			echo "Generating docs for: $$dir"; \
			cd "$$dir"; \
			terraform-docs markdown table . > README.md; \
			cd - >/dev/null; \
		fi; \
	done
	@echo "✅ Documentation generated!"

# Clean up temporary files
clean:
	@echo "🧹 Cleaning up temporary files..."
	@find . -name ".terraform" -type d -exec rm -rf {} + 2>/dev/null || true
	@find . -name "terraform.tfstate*" -delete 2>/dev/null || true
	@find . -name "*.tfplan" -delete 2>/dev/null || true
	@find . -name ".terraform.lock.hcl" -delete 2>/dev/null || true
	@echo "✅ Cleanup completed!"

# Run all checks
check-all: format validate lint security
	@echo "🎉 All checks completed successfully!"

# Check if required tools are installed
check-tools:
	@echo "🔧 Checking required tools..."
	@command -v terraform >/dev/null 2>&1 && echo "✅ Terraform" || echo "❌ Terraform not found"
	@command -v tflint >/dev/null 2>&1 && echo "✅ TFLint" || echo "❌ TFLint not found"
	@command -v checkov >/dev/null 2>&1 && echo "✅ Checkov" || echo "❌ Checkov not found"
	@command -v terraform-docs >/dev/null 2>&1 && echo "✅ terraform-docs" || echo "❌ terraform-docs not found"

# Quick development workflow
dev: format validate
	@echo "🚀 Development checks completed!"