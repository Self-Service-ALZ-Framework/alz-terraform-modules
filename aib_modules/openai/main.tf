resource "azurerm_resource_group" "openai-rg" {
  lifecycle { ignore_changes = [] }
  location = var.region
  name     = "rg-openai-${var.name}"
  tags = {
    project = "Aibooster"
    name    = var.name
  }
}

resource "azurerm_cognitive_account" "open-ai-instance" {
  lifecycle { ignore_changes = [] }
  kind                               = "OpenAI"
  location                           = var.region
  name                               = "oi-${var.prefix}-${var.name}-ai-${var.program}-openai"
  resource_group_name                = azurerm_resource_group.openai-rg.name
  sku_name                           = "S0"
  custom_subdomain_name              = "${var.prefix}-${var.name}-${replace(lower(var.region), " ", "-")}"
  outbound_network_access_restricted = true
  public_network_access_enabled      = true
  identity {
    type = "SystemAssigned"
  }
  network_acls {
    default_action = "Deny"
    ip_rules       = var.ips
  }
}



resource "azurerm_cognitive_deployment" "cognitive_deployment" {
  lifecycle { ignore_changes = [] }
  for_each = { for deployment in var.cognitive_deployments : deployment.model_name => deployment }

  cognitive_account_id = azurerm_cognitive_account.open-ai-instance.id
  name                 = each.value.model_name
  rai_policy_name      = each.value.policy

  model {
    format  = "OpenAI"
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = each.value.sku_name
    capacity = each.value.capacity
  }
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.15.0"
    }
  }
}



resource "azapi_resource" "no_moderation_policy" {
  type      = "Microsoft.CognitiveServices/accounts/raiPolicies@2023-06-01-preview"
  name      = "aibContentFilter"
  parent_id = azurerm_cognitive_account.open-ai-instance.id

  schema_validation_enabled = false

  body = jsonencode(var.moderation_policy)
}
