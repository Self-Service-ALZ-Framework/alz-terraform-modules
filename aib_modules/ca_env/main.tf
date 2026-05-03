resource "azurerm_log_analytics_workspace" "container-app-logs" {
  name                = "law-public-env-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "container-app-env" {
  name                               = "ca-public-env-${var.name}"
  location                           = var.location
  resource_group_name                = var.resource_group_name
  log_analytics_workspace_id         = azurerm_log_analytics_workspace.container-app-logs.id
  internal_load_balancer_enabled     = false
  infrastructure_resource_group_name = "ME_ca-public-env-${var.name}_${var.resource_group_name}_${var.location}"
  infrastructure_subnet_id           = var.subnet_id
  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
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