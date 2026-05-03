resource "azurerm_private_endpoint" "openai_pe" {
  for_each            = var.private_endpoint_connections
  name                = "openai_pe_${each.value.resource_group_name}"
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = each.value.subnet_id

  private_service_connection {
    name                           = "openai-privateserviceconnection-${each.value.resource_group_name}"
    private_connection_resource_id = azurerm_cognitive_account.open-ai-instance.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "openai-dns-zone-group-${each.value.resource_group_name}"
    private_dns_zone_ids = [azurerm_private_dns_zone.openai_dns_zone[each.key].id]
  }
}

resource "azurerm_private_dns_zone" "openai_dns_zone" {
  for_each            = var.private_endpoint_connections
  name                = "privatelink.openai.azure.com"
  resource_group_name = each.value.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "openai_vnet_link" {
  for_each              = var.private_endpoint_connections
  name                  = "openai-link-${each.value.resource_group_name}"
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.openai_dns_zone[each.key].name
  virtual_network_id    = each.value.vnet_id
}
