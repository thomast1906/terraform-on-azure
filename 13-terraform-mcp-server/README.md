# Terraform MCP Server

Get real-time Terraform provider documentation, module details, and registry information directly in GitHub Copilot. The Terraform Model Context Protocol (MCP) server connects your AI assistant to the Terraform Registry.

## What you get

- **Provider docs**: Latest versions, capabilities, and resource examples
- **Module search**: Find and inspect public/private modules
- **Current info**: Always up-to-date from the live registry
- **In-editor**: No context switching to browsers

## Setup

This repo includes an MCP configuration at [.vscode/mcp.json](../.vscode/mcp.json). If you have GitHub Copilot with MCP support, it should load automatically.

### Configuration

```json
{
  "servers": {
    "terraform": {
      "command": "docker",
      "args": [
        "run", "-i", "--rm",
        "-e", "TFE_TOKEN=${input:tfe_token}",
        "-e", "TFE_ADDRESS=${input:tfe_address}",
        "hashicorp/terraform-mcp-server:0.4.0"
      ] 
    }
  }
}
```

**Requirements:**
- Docker installed and running
- GitHub Copilot with MCP support
- Optional: HCP Terraform token for private registry access

### Verify setup

Ask Copilot:
```
"What's the latest version of the azurerm provider?"
```

If you get a version number, MCP is working.

## Usage examples

### Get provider versions

```
"What's the latest Azure provider version?"
```

Returns current version for your `required_providers` block.

### Resource documentation

```
"Show me azurerm_kubernetes_cluster arguments"
"How do I create an Azure Container Registry with geo-replication?"
```

Gets current resource schema with examples.

### Module discovery

```
"Find Azure networking modules"
"Show inputs for Azure/vnet/azurerm module"
```

Searches registry and retrieves module documentation.

### Capabilities check

```
"What resources are available in the azurerm provider?"
"Does the AzureRM provider support Azure Container Apps?"
```

Returns available resource types and data sources.

## Workflow example

**1. Start a new configuration**
```
You: "Create an AKS cluster with the latest best practices"
```
Copilot queries MCP for:
- Latest azurerm provider version
- Current azurerm_kubernetes_cluster schema
- Recommended settings and examples

**2. Add a module**
```
You: "Find a verified module for Azure Key Vault"
```
Copilot searches the registry and gives you options with:
- Module source path
- Input variables
- Usage examples

**3. Check compatibility**
```
You: "Does that module work with azurerm 4.0?"
```
Copilot checks the module's provider requirements.

## Troubleshooting

**MCP not responding:**
- Check Docker is running: `docker ps`
- Reload VS Code window
- Check GitHub Copilot extension is updated

**Token errors:**
- TFE_TOKEN is only needed for private registries
- Leave blank for public registry only
- Get token from https://app.terraform.io/app/settings/tokens

**Rate limits:**
- Public registry limits apply
- Use HCP Terraform token for higher limits

## Without MCP

If MCP isn't available, use these directly:
- Providers: https://registry.terraform.io/browse/providers
- Modules: https://registry.terraform.io/browse/modules  
- Docs: https://developer.hashicorp.com/terraform

## Benefits

✅ Always current documentation  
✅ No manual registry searches  
✅ Faster code generation  
✅ Discover modules easily  
✅ Verify compatibility quickly  

## Next steps

Try asking Copilot to generate a complete Terraform configuration using the latest provider versions and modules. See [8-terraform-testing](../8-terraform-testing) to learn how to validate your code.
