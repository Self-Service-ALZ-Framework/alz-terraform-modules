data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "runner_uai" {
  name                = "self-hosted-runners-uai"
  resource_group_name = var.resource_group_name
  location            = var.location
}

data "azurerm_key_vault" "key_vault" {
  name                = var.key_vault_name
  resource_group_name = var.key_vault_rg
}

resource "azurerm_key_vault_access_policy" "access_key_vault" {
  key_vault_id = data.azurerm_key_vault.key_vault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.runner_uai.principal_id


  // Specify permissions as required, e.g., for secrets:
  secret_permissions = [
    "Get",
    "List",
  ]
}



resource "azurerm_container_group" "self_hosted_runners" {
  name                = "github-runners"
  location            = var.location
  resource_group_name = var.resource_group_name
  ip_address_type     = "Private"

  os_type    = "Linux"
  subnet_ids = var.subnet_ids
  identity {
    type = "UserAssigned"
    # identity_ids = [azurerm_user_assigned_identity.runner_uai.id, var.CICD_CLIENT_ID["lab"], var.CICD_CLIENT_ID["nl"], var.CICD_CLIENT_ID["live"]]
    identity_ids = concat([azurerm_user_assigned_identity.runner_uai.id], values(var.CICD_CLIENT_ID))
  }

  dynamic "container" {
    for_each = var.CICD_CLIENT_ID
    content {
      name   = "${container.key}-runner"
      image  = "${var.acr_name}.azurecr.io/${var.image}"
      cpu    = "1"
      memory = "1.5"

      environment_variables = {
        "GH_ORG" : var.gh_org,
        "GH_REPO" : var.gh_repo,
        "RUNNER_LABELS" : "az${container.key},${container.key}",
        "RUNNER_NAME" : "azure-${container.key}"
        "CICD_RUNNER_GROUP" : "runner${var.runner_group}"
      }
      secure_environment_variables = {
        CLIENT_ID      = azurerm_user_assigned_identity.runner_uai.client_id
        KEY_VAULT_NAME = var.key_vault_name
        SECRET_NAME    = var.secret_name
        CICD_CLIENT_ID = container.value
      }
      ports {
        port     = 80 # Not open as private but required for tf creation
        protocol = "TCP"
      }
    }
  }
  image_registry_credential {
    user_assigned_identity_id = azurerm_user_assigned_identity.runner_uai.id
    server                    = "${var.acr_name}.azurecr.io"
  }
  depends_on = [azurerm_role_assignment.acr_pull_role] # Wait for the role propagation
}


resource "azurerm_role_assignment" "acr_pull_role" {
  principal_id         = azurerm_user_assigned_identity.runner_uai.principal_id
  role_definition_name = "AcrPull"
  scope                = var.acr_id
}


terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.hub ]
    }
  }
}
