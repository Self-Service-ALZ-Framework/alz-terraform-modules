resource "azurerm_cognitive_account" "speech" {
  name                          = "speech-${var.name}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                          = "SpeechServices"
  public_network_access_enabled = true
  custom_subdomain_name         = "speech-${var.name}"
  sku_name                      = "S0"
  network_acls {
    default_action = "Deny"
    virtual_network_rules {
      subnet_id = var.subnet_id
    }
  }
}

resource "azurerm_private_endpoint" "speech_pe" {
  name                = "speech_pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "text-analytics-privateserviceconnection"
    private_connection_resource_id = azurerm_cognitive_account.speech.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "speech-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.language_dns_zone.id]
  }
}
