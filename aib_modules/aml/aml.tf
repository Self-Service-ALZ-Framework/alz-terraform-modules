resource "azurerm_machine_learning_workspace" "ml" {
  name                           = "ml-${var.name}"
  location                       = var.location
  resource_group_name            = var.resource_group_name
  application_insights_id        = var.application_insights_id
  key_vault_id                   = var.key_vault_id
  storage_account_id             = var.storage_account_id
  container_registry_id          = var.container_registry_id
  primary_user_assigned_identity = azurerm_user_assigned_identity.user_identity.id
  identity {
    type = "UserAssigned"
    identity_ids = [
      azurerm_user_assigned_identity.user_identity.id,
    ]
  }
  # public_access_behind_virtual_network_enabled = false
  public_network_access_enabled = true
  tags = {
    ADMIN_HIDE_SURVEY            = "TRUE"
    AZML_DISABLE_PREVIEW_FEATURE = "TRUE"
  }

  lifecycle { ignore_changes = [tags] }
}

resource "azapi_update_resource" "mlspace-public-access" {
  type        = "Microsoft.MachineLearningServices/workspaces@2024-01-01-preview"
  resource_id = azurerm_machine_learning_workspace.ml.id

  body = jsonencode({
    properties = {
      ipAllowlist = var.ip_allow_list
    }
  })

  depends_on = [
    azurerm_machine_learning_workspace.ml
  ]
}
