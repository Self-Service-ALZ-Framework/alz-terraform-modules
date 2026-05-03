resource "azurerm_cosmosdb_account" "db" {
  name                = "cosmos-db-account-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  automatic_failover_enabled = false

  consistency_policy {
    consistency_level       = "Session"
    max_interval_in_seconds = 5
    max_staleness_prefix    = 100
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }
  is_virtual_network_filter_enabled = true
  virtual_network_rule {
    id                                   = var.subnet_id
    ignore_missing_vnet_service_endpoint = false
  }
  virtual_network_rule {
    id                                   = var.apps_subnet_id
    ignore_missing_vnet_service_endpoint = false
  }

}

resource "azurerm_private_dns_zone" "cosmosdb" {
  name                = "documents.azure.com"
  resource_group_name = var.resource_group_name
  lifecycle { ignore_changes = [tags] }
}


#  doesn't work for dias
# resource "azurerm_private_dns_zone_virtual_network_link" "vaultcore" {
#   name                  = "cosmosdblink"
#   resource_group_name   = var.resource_group_name
#   private_dns_zone_name = azurerm_private_dns_zone.cosmosdb.name
#   virtual_network_id    = var.vnet_id

#   lifecycle { ignore_changes = [tags] }
# }

resource "azurerm_private_endpoint" "pe" {
  name                = "cosmos-db-account-${var.name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_dns_zone_group {
    name                 = "private-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.cosmosdb.id]
  }

  private_service_connection {
    is_manual_connection           = false
    name                           = "cosmos-db-account-${var.name}-psc"
    private_connection_resource_id = azurerm_cosmosdb_account.db.id
    subresource_names              = ["sql"]
  }
}


terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.hub ]
    }
  }
}