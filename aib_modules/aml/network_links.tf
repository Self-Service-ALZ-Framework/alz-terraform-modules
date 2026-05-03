resource "azurerm_private_dns_zone_virtual_network_link" "azuremllink" {
  name                  = "azuremllink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.azureml.name
  virtual_network_id    = var.core_vnet

  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_private_dns_zone_virtual_network_link" "azuremlcertlink" {
  name                  = "azuremlcertlink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.azuremlcert.name
  virtual_network_id    = var.core_vnet

  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_private_dns_zone_virtual_network_link" "notebookslink" {
  name                  = "notebookslink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.notebooks.name
  virtual_network_id    = var.core_vnet

  lifecycle { ignore_changes = [tags] }
}
