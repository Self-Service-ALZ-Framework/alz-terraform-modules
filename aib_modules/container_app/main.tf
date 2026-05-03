resource "azurerm_log_analytics_workspace" "container-app-logs" {
  name                = "law-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_user_assigned_identity" "container-app-uai" {
  location            = var.location
  name                = "uai-${var.name}-container-app"
  resource_group_name = var.resource_group_name
}
data "azurerm_container_registry" "acr" {
  provider            = azurerm.hub
  name                = "aibprdimages"
  resource_group_name = var.hub_rg
}

resource "azurerm_role_assignment" "containerapp" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "acrpull"
  principal_id         = azurerm_user_assigned_identity.container-app-uai.principal_id
  depends_on = [
    azurerm_user_assigned_identity.container-app-uai
  ]
}
resource "azurerm_container_app_environment" "container-app-env" {
  name                               = "ca-env-${var.name}"
  location                           = var.location
  resource_group_name                = var.resource_group_name
  log_analytics_workspace_id         = azurerm_log_analytics_workspace.container-app-logs.id
  internal_load_balancer_enabled     = true
  infrastructure_resource_group_name = "ME_ca-env-${var.name}_${var.resource_group_name}_${var.location}"
  infrastructure_subnet_id           = var.subnet_id
  workload_profile {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
  }
}
resource "azurerm_container_app" "container-app-deployment" {
  name                         = "ca-${var.name}"
  container_app_environment_id = azurerm_container_app_environment.container-app-env.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"
  workload_profile_name        = "Consumption"
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.container-app-uai.id]
  }

  registry {
    server   = data.azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.container-app-uai.id
  }

  ingress {
    allow_insecure_connections = false
    external_enabled           = true
    target_port                = 8080
    traffic_weight {
      percentage      = 100
      latest_revision = true
    }
  }

  template {
    min_replicas = 1
    container {
      name   = "container-${var.name}"
      image  = "${data.azurerm_container_registry.acr.login_server}/${var.image}"
      cpu    = 4
      memory = "8Gi"
      dynamic "env" {
        for_each = var.envs
        content {
          name  = env.key
          value = env.value
        }
      }
      env {
        name  = "PRINCIPAL_ID"
        value = azurerm_user_assigned_identity.container-app-uai.principal_id
      }
      readiness_probe {
        transport = "HTTP"
        port      = 8080
        path      = "/health"
      }

      liveness_probe {
        transport = "HTTP"
        port      = 8080
        path      = "/health"
      }

      startup_probe {
        transport = "HTTP"
        port      = 8080
        path      = "/health"
      }
    }
  }
}



terraform {
  required_providers {
    azurerm = {
      source                = "hashicorp/azurerm"
      configuration_aliases = [azurerm.hub]
    }
  }
}