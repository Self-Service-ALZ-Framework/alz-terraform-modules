data "azurerm_client_config" "current" {}

data "external" "upload_script" {
  program = ["bash", "${path.module}/upload-files.sh"]

  query = {
    DATASTORE_NAME                = "workspaceworkingdirectory"
    MACHINE_LEARNING_SERVICE_NAME = "ml-${var.name}"
    SUBSCRIPTION_ID               = data.azurerm_client_config.current.subscription_id
    RESOURCE_GROUP_NAME           = var.resource_group_name
    STORAGE_ACCOUNT_NAME          = var.storage_account_name
    MODULE_PATH                   = path.module
  }
  depends_on = [azurerm_machine_learning_workspace.ml]
}
