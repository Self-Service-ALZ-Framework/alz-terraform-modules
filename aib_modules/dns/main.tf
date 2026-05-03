resource "azurerm_private_dns_zone" "container-app-private-dns-zone" {
  name                = "westeurope.azurecontainerapps.io"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_a_record" "proxy_container-app-record-set" {
  for_each            = var.container_apps
  name                = trimprefix(trimsuffix(each.value.url, ".${azurerm_private_dns_zone.container-app-private-dns-zone.name}"), "https://")
  zone_name           = azurerm_private_dns_zone.container-app-private-dns-zone.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = [each.value.ip]
}

resource "azurerm_private_dns_zone_virtual_network_link" "pdz-vnl-container-apps" {
  name                  = "pdz-vnl-${var.name}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.container-app-private-dns-zone.name
  registration_enabled  = true
  virtual_network_id    = var.vnet_id
}

# repo for non west europe
resource "azurerm_private_dns_zone" "container-app-private-dns-zone-non-westeurope" {
  for_each            = { for name in [var.location] : name => name if var.location != "westeurope" }
  name                = "${var.location}.azurecontainerapps.io"
  resource_group_name = var.resource_group_name
}


resource "azurerm_private_dns_zone_virtual_network_link" "pdz-vnl-container-apps-non-westeurope" {
  for_each              = { for name in [var.location] : name => name if var.location != "westeurope" }
  name                  = "pdz-vnl-${var.name}-${var.location}"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.container-app-private-dns-zone-non-westeurope[var.location].name
  registration_enabled  = false
  virtual_network_id    = var.vnet_id
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.hub ]
    }
  }
}