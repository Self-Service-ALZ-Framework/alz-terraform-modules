resource "azurerm_private_endpoint" "acrpe" {
  name                = "acrpe-${azurerm_container_registry.acr.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.shared_subnet

  lifecycle { ignore_changes = [tags] }

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.azurecr.id]
  }

  private_service_connection {
    name                           = "acrpesc-${azurerm_container_registry.acr.name}"
    private_connection_resource_id = azurerm_container_registry.acr.id
    is_manual_connection           = false
    subresource_names              = ["registry"]
  }
}