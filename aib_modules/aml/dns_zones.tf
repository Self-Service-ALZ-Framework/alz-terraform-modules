resource "azurerm_private_dns_zone" "azureml" {
  name                = "privatelink.api.azureml.ms"
  resource_group_name = var.resource_group_name

  lifecycle { ignore_changes = [tags] }
}
resource "azurerm_private_dns_zone" "azuremlcert" {
  name                = "privatelink.cert.api.azureml.ms"
  resource_group_name = var.resource_group_name

  lifecycle { ignore_changes = [tags] }
}
resource "azurerm_private_dns_zone" "notebooks" {
  name                = "privatelink.notebooks.azure.net"
  resource_group_name = var.resource_group_name

  lifecycle { ignore_changes = [tags] }
}