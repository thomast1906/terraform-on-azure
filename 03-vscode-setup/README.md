# Set up your editor

VS Code provides the best experience for writing Terraform. You get syntax highlighting, autocompletion, and inline validation.

## Install VS Code

Windows:

```powershell
winget install Microsoft.VisualStudioCode
```

macOS:

```bash
brew install --cask visual-studio-code
```

Linux:

```bash
sudo snap install code --classic
```

## Install the Terraform extension

Open VS Code and install the HashiCorp Terraform extension:

1. Press `Cmd+Shift+X` (macOS) or `Ctrl+Shift+X` (Windows/Linux)
2. Search for "HashiCorp Terraform"
3. Click Install

This extension gives you:

- Syntax highlighting for `.tf` files
- IntelliSense for resource types and properties
- Automatic formatting with `terraform fmt`
- Inline validation as you type
- Resource documentation on hover

You can also install it from the command line:

```bash
code --install-extension hashicorp.terraform
```

## Optional: Install Azure CLI

You'll need the Azure CLI to authenticate with Azure. Install it:

Windows:

```powershell
winget install Microsoft.AzureCLI
```

macOS:

```bash
brew install azure-cli
```

Linux:

```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

Verify the installation:

```bash
az version
```

