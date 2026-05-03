resource "azurerm_cognitive_account" "language" {
  name                                         = "language-${var.name}"
  location                                     = var.location
  resource_group_name                          = var.resource_group_name
  kind                                         = "TextAnalytics"
  public_network_access_enabled                = true
  custom_subdomain_name                        = "language-${var.name}"
  sku_name                                     = "S"
  custom_question_answering_search_service_id  = azurerm_search_service.search.id
  custom_question_answering_search_service_key = azurerm_search_service.search.primary_key
  storage {
    storage_account_id = var.storage_account_id
  }
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_private_endpoint" "language_pe" {
  name                = "language_pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "text-analytics-privateserviceconnection"
    private_connection_resource_id = azurerm_cognitive_account.language.id
    subresource_names              = ["account"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "language-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.language_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "language_dns_zone" {
  name                = "privatelink.cognitiveservices.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "language_vnet_link" {
  name                  = "language-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.language_dns_zone.name
  virtual_network_id    = var.vnet_id
}

resource "azurerm_search_service" "search" {
  #FIXIT
  # for_each                      = var.disable_cognitive_search ? [] : toset([true])
  name                          = "search-${var.name}"
  location                      = var.location
  resource_group_name           = var.resource_group_name
  sku                           = var.cognitive_search_sku
  authentication_failure_mode   = "http401WithBearerChallenge"
  local_authentication_enabled  = true
  public_network_access_enabled = false
  semantic_search_sku           = var.cognitive_search_sku
}

resource "azurerm_role_assignment" "language" {
  scope                = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Search/searchServices/search-${var.name}"
  role_definition_name = "Contributor"
  principal_id         = azurerm_cognitive_account.language.identity.0.principal_id
  depends_on           = [azurerm_cognitive_account.language, azurerm_search_service.search]
}

resource "azurerm_role_assignment" "storage" {
  scope                = var.storage_account_id
  role_definition_name = "Contributor"
  principal_id         = azurerm_cognitive_account.language.identity.0.principal_id
  depends_on           = [azurerm_cognitive_account.language, azurerm_search_service.search]
}

resource "azurerm_private_endpoint" "search_pe" {
  name                = "search_pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = "search-privateserviceconnection"
    private_connection_resource_id = azurerm_search_service.search.id
    subresource_names              = ["searchService"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "search-dns-zone-group"
    private_dns_zone_ids = [azurerm_private_dns_zone.search_dns_zone.id]
  }
}

resource "azurerm_private_dns_zone" "search_dns_zone" {
  name                = "privatelink.search.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "search_vnet_link" {
  name                  = "search-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.search_dns_zone.name
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
