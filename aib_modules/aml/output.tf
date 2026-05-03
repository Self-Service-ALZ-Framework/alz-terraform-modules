output "azureml_workspace_name" {
  value = azurerm_machine_learning_workspace.ml.name
}

output "id" {
  value = azurerm_machine_learning_workspace.ml.id
}


output "azureml_workspace_principal_id" {
  value = azurerm_machine_learning_workspace.ml.identity[0].principal_id
}


output "azureml_iam_id" {
  value = azurerm_user_assigned_identity.user_identity.id
}

output "azureml_iam_client_id" {
  value = azurerm_user_assigned_identity.user_identity.client_id
}
