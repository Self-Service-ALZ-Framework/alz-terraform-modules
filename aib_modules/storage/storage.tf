resource "azurerm_storage_account" "stg" {
  lifecycle { ignore_changes = [] }
  name                     = lower(replace("stg-${var.name}", "-", ""))
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  network_rules {
    default_action = "Deny"
    ip_rules       = var.vpn_ip_ranges
    bypass         = ["AzureServices"]
    # private_link_access {
    #   endpoint_resource_id = "/subscriptions/${var.subscription_id}/resourcegroups/${var.resource_group_name}/providers/Microsoft.Logic/workflows/*"
    #   endpoint_tenant_id   = "68283f3b-8487-4c86-adb3-a5228f18b893"
    # }
  }
}

resource "azurerm_storage_account" "stg-sftp" {
  lifecycle { ignore_changes = [] }
  name                     = lower(replace("stg-sftp-${var.name}", "-", ""))
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  min_tls_version          = "TLS1_2"
  network_rules {
    default_action = "Deny"
    ip_rules       = var.vpn_ip_ranges
    bypass         = ["AzureServices"]

  }
  sftp_enabled   = true
  is_hns_enabled = true
}

resource "azurerm_private_dns_zone" "filecore" {
  lifecycle { ignore_changes = [] }
  name                = "privatelink.file.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "filecorelink" {
  lifecycle { ignore_changes = [] }
  name                  = "filecorelink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.filecore.name
  virtual_network_id    = var.core_vnet
}

resource "azurerm_private_dns_zone" "blobcore" {
  lifecycle { ignore_changes = [] }
  name                = "privatelink.blob.core.windows.net"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "blobcore" {
  lifecycle { ignore_changes = [] }
  name                  = "blobcorelink"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.blobcore.name
  virtual_network_id    = var.core_vnet
}

resource "azurerm_private_endpoint" "blobpe" {
  lifecycle { ignore_changes = [] }
  name                = "pe-blob-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.shared_subnet

  private_dns_zone_group {
    name                 = "private-dns-zone-group-blobcore"
    private_dns_zone_ids = [azurerm_private_dns_zone.blobcore.id]
  }

  private_service_connection {
    name                           = "psc-stg-${var.name}"
    private_connection_resource_id = azurerm_storage_account.stg.id
    is_manual_connection           = false
    subresource_names              = ["Blob"]
  }
}

resource "azurerm_private_endpoint" "filepe" {
  lifecycle { ignore_changes = [] }
  name                = "pe-file-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.shared_subnet

  private_dns_zone_group {
    name                 = "private-dns-zone-group-filecore"
    private_dns_zone_ids = [azurerm_private_dns_zone.filecore.id]
  }

  private_service_connection {
    name                           = "psc-filestg-${var.name}"
    private_connection_resource_id = azurerm_storage_account.stg.id
    is_manual_connection           = false
    subresource_names              = ["file"]
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