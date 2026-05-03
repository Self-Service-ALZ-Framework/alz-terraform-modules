resource "azurerm_role_assignment" "ops-rg-reader-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_operations : {}
  principal_id         = each.value.object_id
  role_definition_name = "Reader"
  scope                = data.azurerm_resource_group.rg.id
}

resource "azurerm_role_assignment" "ops-rg-monitoring-contributor-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_operations : {}
  principal_id         = each.value.object_id
  role_definition_name = "Monitoring Contributor"
  scope                = data.azurerm_resource_group.rg.id
}

resource "azurerm_role_assignment" "ops-rg-aib-operations" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each           = can(regex(var.lv_filter, var.name)) ? local.users_operations : {}
  principal_id       = each.value.object_id
  scope              = data.azurerm_resource_group.rg.id
  role_definition_id = module.custom_lv["remedy"].role_definition_resource_ids["CUSTOM - Aibooster Operations User"]
}


module "custom_lv" {
  source        = "../custom_roles"
  for_each      = can(regex(var.lv_filter, var.name)) ? { "remedy" = "true" } : {}
  resource_name = var.name
  custom_role_definitions = {
    "CUSTOM - PCS Azure Remedy Customer E2E integration" = {
      description = "PCS Azure Remedy Customer E2E integration"
      permissions = {
        actions = [
          "Microsoft.Resources/subscriptions/read",
          "Microsoft.Resources/subscriptions/resourceGroups/write",
          "Microsoft.Resources/subscriptions/resourceGroups/read",
          "Microsoft.Resources/subscriptions/resourceGroups/resources/read",
          "Microsoft.Resources/deployments/*",
          "Microsoft.Logic/workflows/*",
          "microsoft.insights/actionGroups/*"
        ]
        data_actions = []
        not_actions = [
          "Microsoft.Logic/workflows/delete",
          "Microsoft.Logic/workflows/regenerateAccessKey/action",
          "Microsoft.Logic/workflows/move/action",
          "Microsoft.Logic/workflows/suspend/action",
          "Microsoft.Logic/workflows/disable/action",
          "Microsoft.Logic/workflows/accessKeys/*",
          "Microsoft.Logic/workflows/runs/delete",
          "Microsoft.Logic/workflows/runs/cancel/action",
          "Microsoft.Insights/ActionGroups/Delete",
          "Microsoft.Resources/deployments/delete",
          "Microsoft.Resources/deployments/cancel/action",
          "Microsoft.Resources/deployments/exportTemplate/action"
        ]
        not_data_actions = []
      }
      scope             = "/subscriptions/${data.azurerm_client_config.config.subscription_id}"
      assignable_scopes = ["/subscriptions/${data.azurerm_client_config.config.subscription_id}"]
    },
    "CUSTOM - Aibooster Operations User" = {
      description = "CUSTOM - Aibooster Operations User"
      permissions = {
        actions = [
          "Microsoft.Portal/Dashboards/Write"
        ]
        data_actions     = []
        not_actions      = []
        not_data_actions = []
      }
      scope             = data.azurerm_resource_group.rg.id
      assignable_scopes = [data.azurerm_resource_group.rg.id]
    }
  }
}



# @see <YOUR_DOCS_URL>/custom-roles-reference
module "custom_devops" {
  source        = "../custom_roles"
  resource_name = var.rg_name
  custom_role_definitions = {
    "Platform DevOps" = {
      description = "General role for DevOps use cases, cannot set IAM permissions."
      permissions = {
        actions      = ["*"]
        data_actions = []
        not_actions = [
          "Microsoft.Authorization/*/Delete", # Delete roles, policy assignments, policy definitions and policy set definitions
          "Microsoft.Authorization/*/Write",
          "Microsoft.Authorization/elevateAccess/Action", # Grants the caller User Access Administrator access at the tenant scope
          "Microsoft.Blueprint/*/write",
          "Microsoft.Blueprint/*/delete",
          "Microsoft.Management/managementGroups/*",
          "Microsoft.ManagedIdentity/userAssignedIdentities/delete", # Deletes an existing user assigned identity
          "Microsoft.Resources/subscriptions/resourceGroups/delete",
          "Microsoft.KeyVault/vaults/*/delete",
          "Microsoft.SaaS/saasresources/write",
          "Microsoft.SaaS/saasresources/delete",
          "Microsoft.AzureActiveDirectory/b2cDirectories/write",
          "Microsoft.AzureActiveDirectory/b2cDirectories/delete",
          "Microsoft.Billing/billingAccounts/write",
          "Microsoft.Billing/billingAccounts/billingProfiles/write",
          "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections/write",
          "Microsoft.Billing/billingAccounts/billingRoleAssignments/write",
          "Microsoft.Billing/billingAccounts/departments/billingRoleAssignments/write",
          "Microsoft.Billing/billingAccounts/enrollmentAccounts/billingRoleAssignments/write",
          "Microsoft.Billing/billingProperty/write"
        ]
        not_data_actions = []
      }
      scope             = "/subscriptions/${data.azurerm_client_config.config.subscription_id}"
      assignable_scopes = ["/subscriptions/${data.azurerm_client_config.config.subscription_id}"]
    },
    "Platform DevOpsLead" = {
      description = "DevOps role with ability to setIAMPolicy permissions for Azure services."
      permissions = {
        actions = [
          "*"
        ]
        not_actions = [
          "Microsoft.Blueprint/*/write",
          "Microsoft.Blueprint/*/delete",
          "Microsoft.Management/managementGroups/*",
          "Microsoft.AzureActiveDirectory/b2cDirectories/write",
          "Microsoft.AzureActiveDirectory/b2cDirectories/delete",
          "Microsoft.Billing/billingAccounts/write",
          "Microsoft.Billing/billingAccounts/billingProfiles/write",
          "Microsoft.Billing/billingAccounts/billingProfiles/invoiceSections/write",
          "Microsoft.Billing/billingAccounts/billingRoleAssignments/write",
          "Microsoft.Billing/billingAccounts/departments/billingRoleAssignments/write",
          "Microsoft.Billing/billingAccounts/enrollmentAccounts/billingRoleAssignments/write",
          "Microsoft.Billing/billingProperty/write"
        ]
        data_actions     = []
        not_data_actions = []
      }
      scope             = data.azurerm_resource_group.rg.id
      assignable_scopes = [data.azurerm_resource_group.rg.id]
    }
  }
}

# assign roles for lab only
# TODO automatic expiration

resource "azurerm_role_assignment" "devops-rg-aib" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each           = can(regex(var.lab_filter, var.name)) ? local.users_devops : {}
  principal_id       = each.value.object_id
  scope              = data.azurerm_resource_group.rg.id
  role_definition_id = module.custom_devops.role_definition_resource_ids["Platform DevOps"]
}
