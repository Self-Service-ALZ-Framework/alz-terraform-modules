# alz-terraform-modules

> 47+ reusable Terraform modules (23 custom + 24 Azure Verified Modules) consumed by both deploy repos via version-pinned git references.

## What This Repo Does

This is the **shared module library**. Both `alz-platform-deploy` and `alz-usecase-deploy` pull modules from here using git source references with specific version tags. This ensures identical module definitions across all deployments — no divergence.

## Module Categories

### Custom Modules (`aib_modules/`) — 23 modules

| Category | Modules |
|----------|---------|
| **Networking** | `network`, `dns`, `firewall`, `routetable`, `vnet-peering` |
| **Compute** | `aci-runners`, `container_app`, `ca_env`, `app-service` |
| **AI/ML** | `openai`, `cognitive_services`, `aml` |
| **Data** | `storage`, `cosmosdb-account`, `keyvault` |
| **Security** | `iam`, `identity`, `custom_roles`, `role-assignments` |
| **Monitoring** | `azure-monitor` |
| **Integration** | `logic_app` |
| **Operations** | `acr`, `providers_register` |

### Azure Verified Modules (`avm_modules/`) — 24+ modules

Pre-configured Microsoft AVM modules for enterprise-grade resources: naming, AI Foundry, API Management, Container Apps, VMs, Data Factory, Key Vault, Storage, SQL, PostgreSQL, CosmosDB, ML Workspace, Search, and more.

## How Modules Are Consumed

```hcl
module "keyvault" {
  source = "git::https://<YOUR_GIT_HOST>/<YOUR_ORG>/alz-terraform-modules.git//avm_modules/terraform-azurerm-avm-res-keyvault-vault-main?ref=avm-res-keyvault-vault/v0.10.2"
  # ...
}
```

**Tag format:** `<module-short-name>/vX.Y.Z` (e.g., `naming/v0.5.0`)

## Creating Module Tags

```bash
git tag naming/v0.5.0
git tag avm-res-keyvault-vault/v0.10.2
git push origin --tags
```

## Documentation

**Start here →** [Main Consumption Guide](../CONSUMPTION-GUIDE.md)