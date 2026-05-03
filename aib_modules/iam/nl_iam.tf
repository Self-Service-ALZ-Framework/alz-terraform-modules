# <YOUR_DOCS_URL>/iam-reference

#
# Data Scientists
#

resource "azurerm_role_assignment" "ds-rg-reader-nlv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.nl_filter, var.name)) ? local.all_users : {}
  principal_id         = each.value.object_id
  role_definition_name = "Reader"
  scope                =  data.azurerm_resource_group.rg.id
}
# shared with MLOPS and MLE

# this is Reader on nl/lv RG it is managed in LV IAM to avoid state conflicts. Azure will only allow one referece in state.
# @see modules/iam/live_iam.tf: Data Scientists
#
# # Azure OpenAI Model	Reader	Resource Group
# resource "azurerm_role_assignment" "ds-openai-rg-reader-nlv" {
#   for_each             = can(regex(var.nl_filter, var.name)) ? local.all_users : {}
#   principal_id         = each.value.object_id
#   role_definition_name = "Reader"
#   scope                = var.openai_rg_id
# }



#
# MLE
#

# NL Reader	Resource Group
# shared with ds
#  Not listed
# # Azure OpenAI Model	Reader	Resource Group
# resource "azurerm_role_assignment" "mle-openai-rg-reader-nlv" {
#   count                = can(regex(var.nl_filter, var.name)) ? 0: length(data.azuread_users.users_ml.object_ids)
#   principal_id         = data.azuread_users.users_ml.object_ids[count.index]
#   role_definition_name = "Reader"
#   scope                = data.azurerm_resource_group.openai-rg.id
# }

# AzureML Data Scientist Resource
resource "azurerm_role_assignment" "aml-nlv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.nl_filter, var.name)) ? local.users_ml : {}
  principal_id         = each.value.object_id
  role_definition_name = "AzureML Data Scientist"
  scope                = var.aml_id
}
# Storage Blob Data Contributor	Resource
resource "azurerm_role_assignment" "stg-blob-cont-nlv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.nl_filter, var.name)) ? local.users_ml : {}
  principal_id         = each.value.object_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.azurerm_resource_group.rg.id
}
# Data Factory Contributor	Resource
resource "azurerm_role_assignment" "df-cont-nlv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.nl_filter, var.name)) ? local.users_ml : {}
  principal_id         = each.value.object_id
  role_definition_name = "Data Factory Contributor"
  scope                = data.azurerm_resource_group.rg.id
}
# AzureML Compute Operator Resource
resource "azurerm_role_assignment" "aml-compute-operator-nlv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.nl_filter, var.name)) ? local.users_ml : {}
  principal_id         = each.value.object_id
  role_definition_name = "AzureML Compute Operator"
  scope                = var.aml_id
}
# Monitoring Contributor Resource
resource "azurerm_role_assignment" "monitoring-nlv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.nl_filter, var.name)) ? local.users_ml : {}
  principal_id         = each.value.object_id
  role_definition_name = "Monitoring Contributor"
  scope                = var.analytics_workspace_id
}
# Key Vault Contributor	Resource
resource "azurerm_role_assignment" "kv-contributor-nlv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.nl_filter, var.name)) ? local.users_ml : {}
  principal_id         = each.value.object_id
  role_definition_name = "Key Vault Contributor"
  scope                = var.kv_id
}

# needed to join the network
resource "azurerm_role_assignment" "nl-network-join" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each           = can(regex(var.nl_filter, var.name)) ? local.users_ml : {}
  principal_id       = each.value.object_id
  scope              = var.vnet_id
  role_definition_id = module.custom_roles.role_definition_resource_ids["CUSTOM - ALZ Network Join"]
}


#
# MLO
#

# shared with DS

# Lab Reader	Resource Group
# Azure OpenAI Model	Reader	Resource Group
