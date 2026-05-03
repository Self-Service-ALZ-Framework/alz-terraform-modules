output "core_vnet_id" {
  value = azurerm_virtual_network.core.id
}
output "core_vnet_name" {
  value = azurerm_virtual_network.core.name
}

output "bastion_subnet_id" {
  value = azurerm_subnet.bastion.id
}

output "azure_firewall_subnet_id" {
  value = azurerm_subnet.azure_firewall.id
}

output "shared_subnet_id" {
  value = azurerm_subnet.shared.id
}

output "cicd_subnet_id" {
  value = try(azurerm_subnet.cicd_runners["CicdSubnet"].id, null)
}
output "infra_subnet_id" {
  value = azurerm_subnet.infra.id
}

output "logic_subnet_id" {
  value = azurerm_subnet.logicApps.id
}

output "apps_subnet_id" {
  value = azurerm_subnet.containerApps.id
}
