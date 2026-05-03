resource "azurerm_route_table" "rt" {
  name                          = "rt-${var.name}"
  resource_group_name           = var.resource_group_name
  location                      = var.location
  bgp_route_propagation_enabled = false

  lifecycle { ignore_changes = [tags] }

  route {
    name                   = "DefaultRoute"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = var.firewall_private_ip_address
  }
}

resource "azurerm_subnet_route_table_association" "rt_shared_subnet_association" {
  for_each       = var.subnets_assosiaction
  subnet_id      = each.value
  route_table_id = azurerm_route_table.rt.id
}



terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.hub ]
    }
  }
}