data "azurerm_client_config" "config" {}

resource "azurerm_user_assigned_identity" "mi-vf-aib-gcp-openai-proxy" {
  name                = "mi-vf-${var.name}-ai-${var.program}-identity-proxy"
  location            = var.region
  resource_group_name = azurerm_resource_group.openai-rg.name
}

resource "azurerm_role_assignment" "openai-user-permission" {
  scope                = "/subscriptions/${data.azurerm_client_config.config.subscription_id}"
  role_definition_name = "Cognitive Services OpenAI Contributor"
  principal_id         = azurerm_user_assigned_identity.mi-vf-aib-gcp-openai-proxy.principal_id
}