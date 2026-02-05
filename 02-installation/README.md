# Install Terraform

You need Terraform installed on your machine to follow this tutorial. Here's how to get it.

## Windows

Use the Windows Package Manager for the fastest installation:

```powershell
winget install Hashicorp.Terraform
```

Alternatively, if you use Chocolatey:

```powershell
choco install terraform
```

## macOS

Use Homebrew to install Terraform:

```bash
# Add the HashiCorp tap
brew tap hashicorp/tap

# Install Terraform
brew install hashicorp/tap/terraform
```

## Linux

Use your distribution's package manager. For Ubuntu/Debian:

```bash
# Add HashiCorp GPG key
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg

# Add HashiCorp repository
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list

# Update and install
sudo apt update && sudo apt install terraform
```

## Verify installation

Check that Terraform installed correctly:

```bash
terraform version
```

You should see output showing the Terraform version. You're ready to start deploying infrastructure on Azure.