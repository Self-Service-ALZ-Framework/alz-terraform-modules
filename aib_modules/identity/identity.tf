data "azurerm_subscription" "current" {
  provider = azurerm
}

resource "azurerm_user_assigned_identity" "managed_identity" {
  name                = "aml-${local.subscription_name}-${var.resource_group_name}-${var.name}-sp"
  location            = var.location
  resource_group_name = var.resource_group_name
}

locals {
  # "<YOUR_SUBSCRIPTION_NAMING_PREFIX>.dev" -> <use-case-name>
  subscription_name = regex("^.*\\.([^.]+)\\.[^.]+$", data.azurerm_subscription.current.display_name)[0]

  roles = {
    "Reader" = {
      role  = "Reader"
      scope = data.azurerm_resource_group.rg.id
    },
    "ContainerAppsContributor" = {
      role  = "Container Apps Contributor"
      scope = data.azurerm_resource_group.rg.id
    },
    "ContainerAppJobsContributor" = {
      role  = "Container Apps Jobs Contributor"
      scope = data.azurerm_resource_group.rg.id
    },
    # additional roles to manage resources created by github runners
    "AzureMLDataScientist" = {
      role  = "AzureML Data Scientist"
      scope = var.scopes.azure_machine_learning_workspace
    },
    "AzureMLComputeOperator" = {
      role  = "AzureML Compute Operator"
      scope = var.scopes.azure_machine_learning_workspace
    },
    "LogAnalyticsContributor" = {
      role  = "Log Analytics Contributor"
      scope = var.scopes.log_analytics_workspace
    },
    "StorageBlobDataContributor" = {
      role  = "Storage Blob Data Contributor"
      scope = var.scopes.storage_account
    },
    "StorageAccountContributor" = {
      role  = "Storage Account Contributor"
      scope = var.scopes.storage_account
    },
    "DataFactoryContributor" = {
      role  = "Data Factory Contributor"
      scope = var.scopes.data_factory
    },
    "ApplicationInsightsComponentContributor" = {
      role  = "Application Insights Component Contributor"
      scope = var.scopes.application_insights
    },
    "LogicAppContributor" = {
      role  = "Logic App Contributor"
      scope = var.scopes.logic_app
    },
    "RedisCacheContributor" = {
      role  = "Redis Cache Contributor"
      scope = var.scopes.azure_cache_for_redis_instance
    },
    "CosmosDBOperator" = {
      role  = "Cosmos DB Operator"
      scope = var.scopes.azure_cosmos_db_account
    },
    "SQLDBContributor" = {
      role  = "SQL DB Contributor"
      scope = var.scopes.azure_sql_database
    },
    "SQLManagedInstanceContributor" = {
      role  = "SQL Managed Instance Contributor"
      scope = var.scopes.azure_sql_managed_instance
    },
    "CognitiveServicesSpeechUserLanguage" = {
      role  = "Cognitive Services Speech User"
      scope = var.scopes.cognitive_services_account_language
    },
    "CognitiveServicesUserSearch" = {
      role  = "Search Index Data Contributor"
      scope = var.scopes.cognitive_services_account_search
    },
    "CognitiveServicesUserSearchService" = {
      role  = "Search Service Contributor"
      scope = var.scopes.cognitive_services_account_search
    },
    "CognitiveServicesSpeechUserRecognizer" = {
      role  = "Cognitive Services Contributor"
      scope = var.scopes.cognitive_services_account_di
    },
    "LogAnalyticsReader" = {
      role  = "Log Analytics Reader"
      scope = var.scopes.log_analytics_workspace
    },
    "AzureContainerStorageContributor" = {
      role  = "Azure Container Storage Contributor"
      scope = var.scopes.azure_container_storage
    },
    "StorageQueueDataContributor" = {
      role  = "Storage Queue Data Contributor"
      scope = var.scopes.storage_account
    },
    "StorageTableDataContributor" = {
      role  = "Storage Table Data Contributor"
      scope = var.scopes.storage_account
    },
    "DocumentDBAccountContributor" = {
      role  = "DocumentDB Account Contributor"
      scope = var.scopes.azure_cosmos_db_account
    },
    "KeyVaultSecretsUser" = {
      role  = "Key Vault Secrets User"
      scope = var.scopes.key_vault
    },
    "DataLakeAnalyticsDeveloper" = {
      role  = "Data Lake Analytics Developer"
      scope = var.scopes.data_lake_analytics_account
    },
    "AzureEventHubsDataReceiver" = {
      role  = "Azure Event Hubs Data Receiver"
      scope = var.scopes.event_hubs_namespace
    },
    "AzureEventHubsDataSender" = {
      role  = "Azure Event Hubs Data Sender"
      scope = var.scopes.event_hubs_namespace
    },
    "AzureContainerRegistryContributor" = {
      role  = "Contributor"
      scope = var.scopes.container_registry
    },
    # "StorageBlobDataContributor"     = "Storage Blob Data Contributor",
    # "StorageQueueDataContributor"     = "Storage Queue Data Contributor",
    # "StorageTableDataContributor"     = "Storage Table Data Contributor",
    # "CosmosDBOperator"                = "Cosmos DB Operator",
    # "DataFactoryContributor"          = "Data Factory Contributor",
    # "DataLakeAnalyticsDeveloper"      = "Data Lake Analytics Developer",
    # "EventHubsDataReceiver"           = "Azure Event Hubs Data receiver",
    # "EventHubsDataSender"             = "Azure Event Hubs Data sender",
    # "KeyVaultSecretsUser"             = "Key Vault Secrets User",
    # "AppInsightsComponentContributor" = "Application Insights Component Contributor",
    # "ContainerAppContributor"         = "Container Apps Contributor", # eg-kb
    # "CognitiveServicesContributor"    = "Cognitive Services Contributor", # eg-vro
    # "RedisCacheContributor"           = "Redis Cache Contributor", # eg-vro
  }

}
# those are approved resource permissions, but we don't really create all of those resources. 
# <YOUR_DOCS_URL>/iam-reference

# actual roles
# AzureML Data Scientist
# AzureML Compute Operator (Exact role: "AzureML Compute Operator")
# Log Analytics Contributor (Exact role: "Log Analytics Contributor")
# Storage Blob Data Contributor (Exact role: "Storage Blob Data Contributor")
# Storage Account Contributor (Exact role: "Storage Account Contributor")
# Data Factory Contributor (Exact role: "Data Factory Contributor")
# Application Insights Component Contributor (Exact role: "Application Insights Component Contributor")
# Logic App Contributor (Exact role: "Logic App Contributor")
# Redis Cache Contributor (Exact role: "Redis Cache Contributor")
# Cosmos DB Operator (Exact role: "Cosmos DB Operator" - this is a data plane role)
# SQL DB Contributor (Exact role: "SQL DB Contributor")
# SQL Managed Instance Contributor (Exact role: "SQL Managed Instance Contributor")
# Cognitive Services Speech User (Exact role: "Cognitive Services Speech User")
# Log Analytics Reader (Exact role: "Log Analytics Reader")
# Azure Container Storage Contributor (Exact role: "Azure Container Storage Contributor" - This is for the Azure Container Storage service, not ACR typically)
# Storage Queue Data Contributor (Exact role: "Storage Queue Data Contributor")
# Storage Table Data Contributor (Exact role: "Storage Table Data Contributor")
# DocumentDB Account Contributor (Exact role: "DocumentDB Account Contributor" - Note: "Cosmos DB Account Contributor" is the more modern equivalent for managing Cosmos DB accounts, but "DocumentDB Account Contributor" is still listed for SQL API accounts.)
# Key Vault Secrets User ("Key Vault Secrets User" )
# Data Lake Analytics Developer ("Data Lake Analytics Developer") listed 2x
# Azure Event Hubs Data Receiver ("Azure Event Hubs Data Receiver")
# Azure Event Hubs Data Sender
# Azure Container Registry Contributor - "Contributor"  on registry


# Define variables
variable "scopes" {
  type = object({
    application_insights                = string
    azure_cache_for_redis_instance      = string
    azure_container_storage             = string
    azure_cosmos_db_account             = string
    azure_machine_learning_workspace    = string
    azure_sql_database                  = string
    azure_sql_managed_instance          = string
    cognitive_services_account_language = string
    cognitive_services_account_search   = string
    cognitive_services_account_di       = string
    data_factory                        = string
    data_lake_analytics_account         = string
    event_hubs_namespace                = string
    key_vault                           = string
    log_analytics_workspace             = string
    logic_app                           = string
    storage_account                     = string
    container_registry                  = string
  })
  description = "resources to be permissioned for managed indentity."
  default = {
    application_insights                = null
    azure_cache_for_redis_instance      = null
    azure_container_storage             = null
    azure_cosmos_db_account             = null
    azure_machine_learning_workspace    = null
    azure_sql_database                  = null
    azure_sql_managed_instance          = null
    cognitive_services_account_language = null
    cognitive_services_account_search   = null
    cognitive_services_account_di       = null
    data_factory                        = null
    data_lake_analytics_account         = null
    event_hubs_namespace                = null
    key_vault                           = null
    log_analytics_workspace             = null
    logic_app                           = null
    storage_account                     = null
    container_registry                  = null
  }
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "assignments" {
  for_each = { for k, v in local.roles : k => v if v.scope != null }

  principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
  role_definition_name = each.value.role
  scope                = each.value.scope
}




# resource "azurerm_role_assignment" "acr" {
#   principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
#   role_definition_name = "Contributor"
#   scope                = var.acr_id
# }

# resource "azurerm_role_assignment" "aml" {
#   principal_id         = azurerm_user_assigned_identity.managed_identity.principal_id
#   role_definition_name = "Contributor"
#   scope                = var.aml_id
# }



terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.hub ]
    }
  }
}
