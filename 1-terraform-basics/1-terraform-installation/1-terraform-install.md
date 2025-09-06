# Terraform Installation Guide

## 🎯 Learning Objectives

By the end of this tutorial, you will:
- Have Terraform installed on your system
- Understand Terraform version management
- Be able to verify your installation
- Know how to update Terraform when needed

## 📋 Prerequisites

- Administrative access to your computer
- Internet connection for downloading packages
- Basic command line knowledge

## 🛠️ Installation Methods

### Method 1: Package Managers (Recommended)

Package managers provide the easiest installation and update experience.

#### Windows - Chocolatey

1. **Install Chocolatey** (if not already installed):
   - Open PowerShell as Administrator
   - Run the installation command from [chocolatey.org](https://chocolatey.org/install)

2. **Install Terraform**:
   ```powershell
   # Install latest version
   choco install terraform
   
   # Install specific version
   choco install terraform --version=1.6.0
   ```

3. **Verify installation**:
   ```powershell
   terraform version
   ```

#### Windows - Winget (Alternative)

```powershell
# Install using Windows Package Manager
winget install HashiCorp.Terraform
```

#### macOS - Homebrew

1. **Install Homebrew** (if not already installed):
   ```bash
   /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
   ```

2. **Install Terraform**:
   ```bash
   # Add the HashiCorp tap
   brew tap hashicorp/tap
   
   # Install Terraform
   brew install hashicorp/tap/terraform
   ```

3. **Verify installation**:
   ```bash
   terraform version
   ```

#### Linux - Package Managers

**Ubuntu/Debian**:
```bash
# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and install
sudo apt update && sudo apt install terraform
```

**RHEL/CentOS/Fedora**:
```bash
# Add HashiCorp repository
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo

# Install Terraform
sudo yum -y install terraform
```

### Method 2: Direct Download

1. **Download** from [terraform.io/downloads](https://www.terraform.io/downloads)
2. **Extract** the binary to a directory in your PATH
3. **Make executable** (Linux/macOS): `chmod +x terraform`

### Method 3: Version Manager (Advanced)

For managing multiple Terraform versions:

**tfenv (recommended)**:
```bash
# Install tfenv
git clone https://github.com/tfutils/tfenv.git ~/.tfenv

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/.tfenv/bin:$PATH"

# Install latest Terraform
tfenv install latest
tfenv use latest

# Install specific version
tfenv install 1.6.0
tfenv use 1.6.0
```

## ✅ Verification Steps

After installation, verify everything works:

```bash
# Check version
terraform version

# Verify help system works
terraform --help

# Test basic command
terraform fmt --help
```

Expected output should look like:
```
Terraform v1.6.0
on darwin_amd64
```

## 🔧 Troubleshooting

### Common Issues

**"terraform: command not found"**
- Ensure Terraform is in your system PATH
- Restart your terminal/command prompt
- Check installation directory

**Permission denied (Linux/macOS)**
- Ensure the binary is executable: `chmod +x terraform`
- Check file ownership and permissions

**Version conflicts**
- Use a version manager like tfenv
- Uninstall old versions before installing new ones

### Getting Help

```bash
# General help
terraform --help

# Command-specific help
terraform plan --help

# Version information
terraform version
```

## 🚀 Next Steps

Now that Terraform is installed:
1. ✅ **Complete**: Terraform installation
2. 🔄 **Next**: [VS Code Setup](./2-vscode-install.md)
3. 🎯 **Goal**: Set up your development environment

## 📚 Additional Resources

- [Official Installation Guide](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Terraform Releases](https://releases.hashicorp.com/terraform/)
- [tfenv Documentation](https://github.com/tfutils/tfenv)