resource "azurerm_public_ip" "fwpip" {
  name                = "pip-fw-${var.name}"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Standard"

  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_firewall" "fw" {
  depends_on          = [azurerm_public_ip.fwpip]
  name                = "fw-${var.name}"
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"
  resource_group_name = var.resource_group_name
  location            = var.location
  ip_configuration {
    name                 = "fw-ip-configuration"
    subnet_id            = data.azurerm_subnet.firewall.id
    public_ip_address_id = azurerm_public_ip.fwpip.id
  }

  lifecycle { ignore_changes = [tags] }
}

resource "azurerm_firewall_application_rule_collection" "shared_subnet" {
  name                = "arc-shared_subnet"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_firewall.fw.resource_group_name
  priority            = 100
  action              = "Allow"

  rule {
    name             = "admin-resources"
    source_addresses = data.azurerm_subnet.shared.address_prefixes
    target_fqdns     = local.allowed_general_urls

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "allowMLrelated"
    source_addresses = data.azurerm_subnet.shared.address_prefixes
    target_fqdns     = local.allowed_aml_urls

    protocol {
      port = "443"
      type = "Https"
    }
  }

  rule {
    name             = "allowADrelated"
    source_addresses = data.azurerm_subnet.shared.address_prefixes
    target_fqdns     = local.allowed_ad_urls

    protocol {
      port = "443"
      type = "Https"
    }
  }

}

resource "azurerm_firewall_network_rule_collection" "shared_nrc" {
  name                = "shared"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_firewall.fw.resource_group_name
  priority            = 101
  action              = "Allow"

  rule {
    name = "allowStorage"

    source_addresses = data.azurerm_subnet.shared.address_prefixes


    destination_ports = [
      "*"
    ]

    destination_addresses = local.allowed_service_tags

    protocols = [
      "TCP"
    ]
  }

  depends_on = [
    azurerm_firewall_network_rule_collection.general
  ]
}


# ---
# ---
resource "azurerm_firewall_network_rule_collection" "ws-setup" {
  name                = "ws-rules"
  azure_firewall_name = azurerm_firewall.fw.name
  resource_group_name = azurerm_firewall.fw.resource_group_name
  priority            = 102
  action              = "Allow"

  rule {
    name              = "__SYS_ST_AzureResourceManager_TCP"
    destination_ports = ["443"]
    protocols         = ["TCP"]
    source_addresses  = data.azurerm_subnet.shared.address_prefixes

    destination_addresses = [
      "AzureResourceManager", "BatchNodeManagement", "MicrosoftContainerRegistry.westeurope", "AzureMonitor", "AzureMachineLearning"
    ]
  }

  rule {
    name              = "__SYS_ST_AzureMachineLearning_UDP"
    destination_ports = ["5831"]
    protocols         = ["UDP"]
    source_addresses  = data.azurerm_subnet.shared.address_prefixes
    destination_addresses = [
      "AzureMachineLearning"
    ]
  }

  rule {
    name              = "__SYS_ST_AzureFrontDoor"
    destination_ports = ["*"]
    protocols         = ["Any"]
    source_addresses  = data.azurerm_subnet.shared.address_prefixes
    destination_addresses = [
      "AzureFrontDoor.FirstParty"
    ]
  }

  rule {
    name              = "__SYS_ST_AzureActiveDirectory"
    destination_ports = ["80", "443"]
    protocols         = ["TCP"]
    source_addresses  = data.azurerm_subnet.shared.address_prefixes
    destination_addresses = [
      "AzureActiveDirectory"
    ]
  }
}
