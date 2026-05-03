resource "azurerm_virtual_network_peering" "hub-vnet-peering" {
  provider                  = azurerm.hub
  name                      = "spoc-vnet-peering-${var.spoc_resource_group_name}"
  resource_group_name       = var.hub_resource_group_name
  virtual_network_name      = var.hub_virtual_network_name
  remote_virtual_network_id = var.spoc_remote_virtual_network_id
  allow_forwarded_traffic   = true
}

resource "azurerm_virtual_network_peering" "spoc-vnet-peering" {
  provider                  = azurerm
  name                      = "spoc-vnet-peering-${var.hub_resource_group_name}"
  allow_forwarded_traffic   = true
  resource_group_name       = var.spoc_resource_group_name
  virtual_network_name      = var.spoc_virtual_network_name
  remote_virtual_network_id = var.hub_remote_virtual_network_id
}

terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.hub]
    }
  }
}
