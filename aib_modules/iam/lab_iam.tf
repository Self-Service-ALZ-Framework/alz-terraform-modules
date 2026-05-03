# <YOUR_DOCS_URL>/iam-reference

#
# Data Scientists
#

# AzureML Data Scientist
# Resource	
resource "azurerm_role_assignment" "aml-ds-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  role_definition_name = "AzureML Data Scientist"
  scope                = var.aml_id
}
# AzureML Compute Operator
# Resource
resource "azurerm_role_assignment" "aml-compute-operator-ds-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  role_definition_name = "AzureML Compute Operator"
  scope                = var.aml_id
}
# Reader	
# Resource Group
# shared with MLOPS and MLE
resource "azurerm_role_assignment" "rg-reader-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.all_users : {}
  principal_id         = each.value.object_id
  role_definition_name = "Reader"
  scope                = data.azurerm_resource_group.rg.id
}

# Log Analytics Reader
# Resource	
resource "azurerm_role_assignment" "log-analytics-reader-ds-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  role_definition_name = "Log Analytics Reader"
  scope                = data.azurerm_resource_group.rg.id
}
# Storage Blob Data Contributor 	
# Resource	
resource "azurerm_role_assignment" "stg-blob-cont-ds-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  role_definition_name = "Storage Blob Data Contributor"
  scope                = data.azurerm_resource_group.rg.id
}
# Key Vault Secrets User	
# Resource	
resource "azurerm_role_assignment" "kv-user-ds-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  role_definition_name = "Key Vault Secrets User"
  scope                = data.azurerm_resource_group.rg.id
}

# Application Insights Reader 	
# Resource

resource "azurerm_role_assignment" "ai-user-ds-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  role_definition_name = "Reader"
  scope                = var.application_insights_id
}

# Cosmos DB Account Reader Role 	
# Resource
resource "azurerm_role_assignment" "cdb-reder-ds-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  role_definition_name = "Cosmos DB Account Reader Role"
  scope                = data.azurerm_resource_group.rg.id
}
# Data Factory Contributor
# Resource
resource "azurerm_role_assignment" "df-cont-ds-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  role_definition_name = "Data Factory Contributor"
  scope                = data.azurerm_resource_group.rg.id
}
# Data Lake Analytics Developer	
# Resource
resource "azurerm_role_assignment" "dla-dev-ds-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  role_definition_name = "Data Lake Analytics Developer"
  scope                = data.azurerm_resource_group.rg.id
}

# Azure OpenAI Model	
# Reader

resource "azurerm_role_assignment" "openai-rg-reader-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.all_users : {}
  principal_id         = each.value.object_id
  role_definition_name = "Reader"
  scope                = var.openai_rg_id
}

# resource "azurerm_role_assignment" "openai-rg-reader-lab" {
#  lifecycle {
#    ignore_changes = [principal_id, scope]
#  }
#   for_each                = local.users_ds
#   principal_id         = each.value.object_id
#   role_definition_name = "Reader"
#   scope                = data.azurerm_resource_group.openai-rg.id
# }



# DIAS

resource "azurerm_role_assignment" "lab-speech-user-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Cognitive Services Speech User"
}

resource "azurerm_role_assignment" "lab-speech-contributor-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each             = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id         = each.value.object_id
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Cognitive Services Speech Contributor"
}

# custom env setup

resource "azurerm_role_assignment" "lab-network-join-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each           = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id       = each.value.object_id
  scope              = var.vnet_id
  role_definition_id = module.custom_roles.role_definition_resource_ids["CUSTOM - ALZ Network Join"]
}



resource "azurerm_role_assignment" "lab-uai-user-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each           = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id       = each.value.object_id
  scope              = var.uai_ws
  role_definition_id = module.custom_roles.role_definition_resource_ids["CUSTOM - ALZ WS UAI user"]
}

resource "azurerm_role_assignment" "lab-sftp-user-create-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each           = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id       = each.value.object_id
  scope              = data.azurerm_resource_group.rg.id
  role_definition_id = module.custom_roles.role_definition_resource_ids["CUSTOM - ALZ create SFTP users"]
}

resource "azurerm_role_assignment" "lab-ds-user-lab" {
  lifecycle {
    ignore_changes = [principal_id, scope]
  }
  for_each           = can(regex(var.lab_filter, var.name)) ? local.users_ds : {}
  principal_id       = each.value.object_id
  scope              = data.azurerm_resource_group.rg.id
  role_definition_id = module.custom_roles.role_definition_resource_ids["CUSTOM - ALZ dev users"]
}




#
# MLE
#
# shared with DS


# Lab Reader	Resource Group
# Azure OpenAI Model	Reader	Resource Group

#
# MLO
#

# shared with DS

# Lab Reader	Resource Group
# Azure OpenAI Model	Reader	Resource Group


terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.hub ]
    }
  }
}
