resource "azurerm_private_endpoint" "mlpe" {
  name                = "mlpe-${azurerm_machine_learning_workspace.ml.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.shared_subnet

  lifecycle { ignore_changes = [tags] }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.azureml.id, azurerm_private_dns_zone.notebooks.id, azurerm_private_dns_zone.azuremlcert.id]
  }

  private_service_connection {
    name                           = "mlpesc-${azurerm_machine_learning_workspace.ml.name}"
    private_connection_resource_id = azurerm_machine_learning_workspace.ml.id
    is_manual_connection           = false
    subresource_names              = ["amlworkspace"]
  }
}