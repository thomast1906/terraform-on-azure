# Visual Studio Code Setup for Terraform

## 🎯 Learning Objectives

By the end of this tutorial, you will:
- Have VS Code installed with Terraform support
- Understand essential extensions for Terraform development
- Know how to configure VS Code for optimal Terraform experience
- Be able to use IntelliSense and syntax highlighting for Terraform

## 📋 Prerequisites

- Terraform installed (from previous step)
- Basic familiarity with text editors

## 🛠️ VS Code Installation

### Windows

**Option 1: Chocolatey (Recommended)**
```powershell
# Install VS Code
choco install vscode

# Install with additional options
choco install vscode --params "/NoDesktopIcon /NoQuicklaunchIcon"
```

**Option 2: Winget**
```powershell
winget install Microsoft.VisualStudioCode
```

**Option 3: Direct Download**
Download from [code.visualstudio.com](https://code.visualstudio.com/)

### macOS

**Option 1: Homebrew (Recommended)**
```bash
# Install VS Code
brew install --cask visual-studio-code
```

**Option 2: Direct Download**
Download from [code.visualstudio.com](https://code.visualstudio.com/)

### Linux

**Ubuntu/Debian**:
```bash
# Download and install the .deb package
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
sudo apt update
sudo apt install code
```

## 🔌 Essential Extensions

### 1. HashiCorp Terraform Extension

**Installation via Command Palette**:
1. Open VS Code
2. Press `Ctrl+Shift+P` (Windows/Linux) or `Cmd+Shift+P` (macOS)
3. Type "Extensions: Install Extensions"
4. Search for "HashiCorp Terraform"
5. Click Install

**Installation via Command Line**:
```bash
code --install-extension HashiCorp.terraform
```

**Features provided**:
- ✅ Syntax highlighting
- ✅ IntelliSense and auto-completion
- ✅ Code formatting
- ✅ Error detection
- ✅ Module explorer
- ✅ Hover documentation

### 2. Additional Recommended Extensions

Install these for a complete Terraform development experience:

```bash
# Azure-related extensions
code --install-extension ms-vscode.azure-account
code --install-extension ms-azure-devops.azure-pipelines

# General productivity extensions  
code --install-extension ms-vscode.vscode-json
code --install-extension redhat.vscode-yaml
code --install-extension ms-python.python
code --install-extension golang.go

# Git and GitHub integration
code --install-extension github.vscode-pull-request-github
code --install-extension eamodio.gitlens

# Enhanced editing
code --install-extension streetsidesoftware.code-spell-checker
code --install-extension ms-vscode.powershell
```

## ⚙️ VS Code Configuration

### Workspace Settings

Create `.vscode/settings.json` in your project root:

```json
{
  "terraform.experimentalFeatures": {
    "validateOnSave": true,
    "prefillRequiredFields": true
  },
  "terraform.languageServer": {
    "external": true,
    "pathToBinary": "",
    "args": ["serve"]
  },
  "files.associations": {
    "*.tf": "terraform",
    "*.tfvars": "terraform"
  },
  "editor.formatOnSave": true,
  "editor.codeActionsOnSave": {
    "source.fixAll": true
  },
  "[terraform]": {
    "editor.defaultFormatter": "hashicorp.terraform",
    "editor.formatOnSave": true,
    "editor.tabSize": 2,
    "editor.insertSpaces": true
  },
  "[terraform-vars]": {
    "editor.defaultFormatter": "hashicorp.terraform",
    "editor.formatOnSave": true,
    "editor.tabSize": 2,
    "editor.insertSpaces": true
  }
}
```

### Extension Recommendations

Create `.vscode/extensions.json`:

```json
{
  "recommendations": [
    "hashicorp.terraform",
    "ms-vscode.azure-account",
    "ms-vscode.vscode-json",
    "redhat.vscode-yaml",
    "github.vscode-pull-request-github"
  ]
}
```

## 🧪 Testing Your Setup

### 1. Create a Test Terraform File

Create a new file called `test.tf`:

```hcl
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "test" {
  name     = "test-rg"
  location = "East US"
  
  tags = {
    Environment = "Test"
  }
}
```

### 2. Verify Features Work

You should see:
- ✅ **Syntax highlighting** - Different colors for keywords, strings, etc.
- ✅ **IntelliSense** - Auto-completion when typing
- ✅ **Error detection** - Red squiggly lines for errors
- ✅ **Hover documentation** - Hover over resources for documentation

### 3. Test Formatting

1. Make the code messy (wrong indentation, extra spaces)
2. Press `Shift+Alt+F` (Windows/Linux) or `Shift+Option+F` (macOS)
3. Code should auto-format

## 🎨 Customization Tips

### Themes for Terraform

Popular VS Code themes that work well with Terraform:

- **Dark**: "One Dark Pro", "Dracula Official"
- **Light**: "GitHub Light", "Atom One Light"

### Useful Keyboard Shortcuts

| Action | Windows/Linux | macOS |
|--------|---------------|-------|
| Format Document | `Shift+Alt+F` | `Shift+Option+F` |
| Command Palette | `Ctrl+Shift+P` | `Cmd+Shift+P` |
| Quick Open | `Ctrl+P` | `Cmd+P` |
| Toggle Terminal | `Ctrl+`` | `Cmd+`` |
| Go to Definition | `F12` | `F12` |
| Peek Definition | `Alt+F12` | `Option+F12` |

## ✅ Verification Checklist

- [ ] VS Code installed and launches successfully
- [ ] HashiCorp Terraform extension installed
- [ ] Syntax highlighting works in `.tf` files
- [ ] IntelliSense provides auto-completion
- [ ] Format on save works
- [ ] No error messages in extension host

## 🚀 Next Steps

Your development environment is ready! Next:
1. ✅ **Complete**: VS Code setup
2. 🔄 **Next**: [Terraform Commands](../2-terraform-commands/)
3. 🎯 **Goal**: Learn essential Terraform commands

## 💡 Pro Tips

- **Integrated Terminal**: Use `Ctrl+`` to open terminal within VS Code
- **Side-by-Side Editing**: `Ctrl+\` to split editor
- **File Explorer**: `Ctrl+Shift+E` to toggle file explorer
- **Extension Marketplace**: `Ctrl+Shift+X` to browse extensions

## 📚 Additional Resources

- [VS Code Terraform Extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform)
- [VS Code Documentation](https://code.visualstudio.com/docs)
- [Terraform Language Server](https://github.com/hashicorp/terraform-ls)

