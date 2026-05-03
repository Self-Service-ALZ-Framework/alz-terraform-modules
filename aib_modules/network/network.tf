resource "azurerm_virtual_network" "core" {
  lifecycle { ignore_changes = [] }
  name                = "vnet-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = [var.vnet_address_space]
}

resource "azurerm_subnet" "bastion" {
  lifecycle { ignore_changes = [] }
  name                              = "AzureBastionSubnet"
  virtual_network_name              = azurerm_virtual_network.core.name
  private_endpoint_network_policies = "Disabled"
  resource_group_name               = var.resource_group_name
  address_prefixes                  = [local.bastion_subnet_address_prefix]
  service_endpoints = [
    "Microsoft.Storage",
  ]

  #   delegation {
  #     name = "dlg-Microsoft.DBforPostgreSQL-flexibleServers"

  #     service_delegation {
  #       actions = [
  #         "Microsoft.Network/virtualNetworks/subnets/join/action",
  #                 ] 
  #               name    = "Microsoft.DBforPostgreSQL/flexibleServers"
  #             }
  # }
}

resource "azurerm_subnet" "azure_firewall" {
  lifecycle { ignore_changes = [] }
  name                              = "AzureFirewallSubnet"
  virtual_network_name              = azurerm_virtual_network.core.name
  resource_group_name               = var.resource_group_name
  private_endpoint_network_policies = "Disabled"
  address_prefixes                  = [local.firewall_subnet_address_space]
  service_endpoints = [
    "Microsoft.Storage",
  ]

  delegation {
    name = "delegation"

    service_delegation {
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
      name = "Microsoft.Web/serverFarms"
    }
  }
}

resource "azurerm_subnet" "shared" {
  lifecycle { ignore_changes = [] }
  name                 = "SharedSubnet"
  virtual_network_name = azurerm_virtual_network.core.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = [local.shared_services_subnet_address_prefix]
  # notice that private endpoints do not adhere to NSG rules
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
  service_endpoints = [
    "Microsoft.Storage",
    "Microsoft.CognitiveServices",
    "Microsoft.AzureCosmosDB"
  ]
}

resource "azurerm_subnet" "cicd_runners" {
  lifecycle { ignore_changes = [] }
  name = "CicdSubnet"
  # if name starts with lab
  for_each             = var.ci_subnet_create ? toset(["CicdSubnet"]) : []
  virtual_network_name = azurerm_virtual_network.core.name
  resource_group_name  = var.resource_group_name
  address_prefixes     = [local.cicd_runners_subnet_address_prefix]
  # notice that private endpoints do not adhere to NSG rules
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = false
  service_endpoints = [
    "Microsoft.Storage",
  ]
  delegation {
    name = "delegation"

    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}

resource "azurerm_subnet" "infra" {
  lifecycle { ignore_changes = [] }
  name                              = "InfraSubnet"
  virtual_network_name              = azurerm_virtual_network.core.name
  resource_group_name               = var.resource_group_name
  private_endpoint_network_policies = "Disabled"
  address_prefixes                  = [local.infra_subnet_address_prefix]
  service_endpoints                 = ["Microsoft.CognitiveServices", "Microsoft.Storage"]
  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}


# This network can be repurposed from usage in logic apps to Function apps. 11 available IPs.
resource "azurerm_subnet" "logicApps" {
  lifecycle { ignore_changes = [] }
  name                              = var.logic_apps_subnet_name
  virtual_network_name              = azurerm_virtual_network.core.name
  resource_group_name               = var.resource_group_name
  private_endpoint_network_policies = "Disabled"
  address_prefixes                  = [local.logic_subnet_address_prefix]
  service_endpoints                 = [
    "Microsoft.Storage",
    "Microsoft.AzureCosmosDB"
  ]
  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.Web/serverFarms"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/action",
      ]
    }
  }
}

# this nework is enabled only on <YOUR_SUBSCRIPTION_NAMING_PREFIX>.prod
# needs to be migrated back to use logic apps
# output "appservice_subnet_id" {
#   value = try(azurerm_subnet.AppServiceSubnet["AppServiceSubnet"].id, "")
# }
# # //custom sub network
# resource "azurerm_subnet" "AppServiceSubnet" {
#   name                 = "AppServiceSubnet"
#   virtual_network_name = azurerm_virtual_network.core.name
#   resource_group_name  = var.resource_group_name
#   private_endpoint_network_policies             = "Disabled"
#   address_prefixes     = [local.logic_subnet_address_prefix]
#   service_endpoints = []
#   delegation {
#     name = "Microsoft.Web/serverFarms"

#     service_delegation {
#       name    = "Microsoft.Web/serverFarms"
#       actions = [
#                   "Microsoft.Network/virtualNetworks/subnets/action",
#                 ]
#     }
#   }
# }


resource "azurerm_subnet" "containerApps" {
  lifecycle { ignore_changes = [] }
  name                              = "AppsSubnet"
  virtual_network_name              = azurerm_virtual_network.core.name
  resource_group_name               = var.resource_group_name
  private_endpoint_network_policies = "Disabled"
  address_prefixes                  = [local.proxy_subnet_address_prefix]
  service_endpoints                 = [
    "Microsoft.Storage",
    "Microsoft.AzureCosmosDB"
  ]
  delegation {
    name = "delegation"

    service_delegation {
      name = "Microsoft.App/environments"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
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
