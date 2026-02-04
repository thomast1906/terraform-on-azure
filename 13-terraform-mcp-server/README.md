# Use the Terraform MCP server

The Terraform Model Context Protocol (MCP) server provides AI assistants with real-time access to Terraform documentation, provider details, and module information. This helps generate accurate, up-to-date Terraform code.

## What is MCP

MCP (Model Context Protocol) is a standard way for AI assistants to connect to external data sources. The Terraform MCP server exposes the Terraform Registry as tools that AI can query.

## Available capabilities

The Terraform MCP server provides:

- Provider information, including latest versions, capabilities, and resource documentation
- Module discovery for public and private modules, plus documentation and examples
- Policy management for Terraform Cloud policies and requirements

## Setup in VS Code

If you're using GitHub Copilot in VS Code, the Terraform MCP server may already be available. Check your MCP configuration:

```bash
cat ~/.vscode-insiders/extensions/ms-azuretools.vscode-azure-github-copilot-*/mcp-config.json
```

Look for terraform-related MCP servers in the configuration.

## Using MCP with Copilot

When working with Terraform, mention what you need:

**Get latest provider version:**
> "What's the latest version of the Azure provider?"

**Find resource documentation:**
> "Show me how to create an Azure Container Registry using the latest API"

**Search for modules:**
> "Find a module for Azure Key Vault"

**Get module details:**
> "Show me the inputs for the Azure/vnet/azurerm module"

The AI queries the MCP server automatically and provides current information.

## Example workflow

Here's how MCP helps when building Terraform configurations:

### 1. Start with provider versions

Ask: "What's the latest Azure provider version?"

MCP returns the current version so you can set the provider constraint correctly.

### 2. Find resource documentation

Ask: "Show me how to create an Azure Storage Account with current recommendations"

MCP fetches current documentation including new properties and recommended configurations.

### 3. Discover modules

Ask: "Find modules for Azure networking"

MCP searches the registry and returns relevant modules with download counts and verification status.

### 4. Get module details

Ask: "Show me the inputs for module Azure/vnet/azurerm"

MCP retrieves the module's variables, outputs, and usage examples.

## Benefits over manual lookup

- MCP queries live data from the Terraform Registry, so results are current.
- Access to providers, modules, and their documentation in one place.
- Works directly in your editor alongside your code.
- Fewer context switches to web browsers or documentation sites.

## Best practices

- Ask for exact resource types or providers.
	Example: "Latest azurerm provider documentation for azurerm_kubernetes_cluster"
- Ask for working code samples.
	Example: "Show me a complete example of Azure AKS with the network plugin"
- Check that generated code uses appropriate provider versions.
- Verify module compatibility with your provider version.

## Limitations

- MCP primarily accesses the public Terraform Registry; private module access depends on configuration.
- Some Terraform Cloud/Enterprise features may require additional setup.
- Heavy usage may hit registry API limits.

## Alternative: Manual registry access

If MCP isn't available, use the Terraform Registry directly:

- Providers: https://registry.terraform.io/browse/providers
- Modules: https://registry.terraform.io/browse/modules
- Documentation: https://developer.hashicorp.com/terraform/docs

## Next steps

With MCP-assisted development:
1. Generate configurations faster
2. Use current guidance automatically
3. Discover relevant modules quickly
4. Stay updated on new Azure resources

Continue to the testing section to learn how to validate your Terraform configurations.
