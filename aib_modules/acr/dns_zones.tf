resource "azurerm_private_dns_zone" "azurecr" {
  name                = "privatelink.azurecr.io"
  resource_group_name = var.resource_group_name

  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_private_dns_a_record" "prd-images" {
  name                = "aibprdimages"
  zone_name           = azurerm_private_dns_zone.azurecr.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = ["10.0.1.5"]
}

resource "azurerm_private_dns_a_record" "prd-images-data" {
  name                = "aibprdimages.westeurope.data"
  zone_name           = azurerm_private_dns_zone.azurecr.name
  resource_group_name = var.resource_group_name
  ttl                 = 300
  records             = ["10.0.1.4"]
}