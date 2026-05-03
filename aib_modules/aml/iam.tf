resource "azurerm_user_assigned_identity" "user_identity" {
  location            = var.location
  name                = "uai-aml-ws-${var.name}"
  resource_group_name = var.resource_group_name
}
resource "azurerm_role_assignment" "key_vault_role" {
  scope                = var.key_vault_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_role_assignment" "storage_account_role" {
  scope                = var.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_role_assignment" "storage_account_file_role" {
  scope                = var.storage_account_id
  role_definition_name = "Storage File Data Privileged Contributor"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_role_assignment" "storage_account_role2" {
  scope                = var.storage_account_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_role_assignment" "app_insights_role" {
  scope                = var.application_insights_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_key_vault_access_policy" "user-assigned-identity" {
  key_vault_id = var.key_vault_id
  tenant_id    = var.tenant_id
  object_id    = azurerm_user_assigned_identity.user_identity.principal_id

  // default set by service
  key_permissions = [
    "WrapKey",
    "UnwrapKey",
    "Get",
    "Recover",
  ]


  secret_permissions = [
    "Get",
    "List",
    "Set",
    "Delete",
    "Recover",
    "Backup",
    "Restore"
  ]
}

resource "azurerm_role_assignment" "ai_search_role" {
  scope                = var.aisearch_instance_id
  role_definition_name = "Search Index Data Contributor"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_role_assignment" "ai_search_service_role" {
  scope                = var.aisearch_instance_id
  role_definition_name = "Search Service Contributor"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_role_assignment" "acr-pull" {
  scope                = var.container_registry_id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_role_assignment" "acr-push" {
  scope                = var.container_registry_id
  role_definition_name = "AcrPush"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_role_assignment" "tasks-contributor" {
  scope                = var.container_registry_id
  role_definition_name = "Container Registry Tasks Contributor"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}

resource "azurerm_role_assignment" "acr-reader" {
  scope                = var.container_registry_id
  role_definition_name = "Reader"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}
resource "azurerm_role_assignment" "cicd_container_app_admin" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}"
  role_definition_name = "Container Apps Contributor"
  principal_id         = azurerm_user_assigned_identity.user_identity.principal_id
}
