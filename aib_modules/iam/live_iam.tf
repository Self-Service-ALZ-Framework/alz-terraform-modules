# <YOUR_DOCS_URL>/iam-reference

#
# Data Scientists
#

# shared with MLOPS and MLE

resource "azurerm_role_assignment" "ds-rg-reader-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.all_users : {}
  principal_id         = each.value.object_id
  role_definition_name = "Reader"
  scope                = data.azurerm_resource_group.rg.id
}
# Azure OpenAI Model	Reader	Resource Group
resource "azurerm_role_assignment" "ds-openai-rg-reader-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.all_users : {}
  principal_id         = each.value.object_id
  role_definition_name = "Reader"
  scope                = var.openai_rg_id
}





#
# MLE
#

# shared with DS

# lv Reader	Resource Group
# Azure OpenAI Model	Reader	Resource Group


#
# MLO
#

# shared with DS

# lv Reader	Resource Group
# Azure OpenAI Model	Reader	Resource Group

# Contributor	Resource Group	
resource "azurerm_role_assignment" "mlo-rg-contributor-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_mlops : {}
  principal_id         = each.value.object_id
  role_definition_name = "Contributor"
  scope                = data.azurerm_resource_group.rg.id
}


# AzureML Data Scientist Resource	
resource "azurerm_role_assignment" "aml-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_mlops : {}
  principal_id         = each.value.object_id
  role_definition_name = "AzureML Data Scientist"
  scope                = var.aml_id
}
# Reader and Data Access Resource storage account
resource "azurerm_role_assignment" "storage-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_mlops : {}
  principal_id         = each.value.object_id
  role_definition_name = "Reader and Data Access"
  scope                = var.storage_id
}
# Storage Blob Data Contributor	Resource
resource "azurerm_role_assignment" "storage-blob-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_mlops : {}
  principal_id         = each.value.object_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = var.storage_id
}
# Application Insights Reader	Resource
resource "azurerm_role_assignment" "ai-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_mlops : {}
  principal_id         = each.value.object_id
  role_definition_name = "Reader"
  scope                = var.application_insights_id
}
# Monitoring Reader	Resource
resource "azurerm_role_assignment" "monitoring-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_mlops : {}
  principal_id         = each.value.object_id
  role_definition_name = "Monitoring Reader"
  scope                = var.analytics_workspace_id
}
# Key Vault Reader	Resource
resource "azurerm_role_assignment" "kv-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_mlops : {}
  principal_id         = each.value.object_id
  role_definition_name = "Key Vault Reader"
  scope                = var.kv_id
}
# Log Analytics Reader	Resource
# not clear what resource would that be, TBC
resource "azurerm_role_assignment" "la-lv" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lv_filter, var.name)) ? local.users_mlops : {}
  principal_id         = each.value.object_id
  role_definition_name = "Log Analytics Reader"
  scope                = var.analytics_workspace_id
}

# GitHub Actions Runner	Resource
# this permission does not exist
# resource "azurerm_role_assignment" "gar-lv" {
#  lifecycle {
#    ignore_changes = [principal_id, scope]
#  }
#   for_each                = can(regex(var.lv_filter, var.name)) ? local.users_mlops : {}
#   principal_id         = each.value.object_id
#   role_definition_name = "GitHub Actions Runner"
#   scope                = data.azurerm_resource_group.rg.id
# }



