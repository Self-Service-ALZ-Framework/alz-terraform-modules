module "custom_roles" {
  source        = "../custom_roles"
  resource_name = var.name
  custom_role_definitions = {
    "CUSTOM - ALZ Network Join" = {
      description = "Allows Data scientists to create ml compute in the preconfigured subnets"
      permissions = {
        actions          = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        data_actions     = []
        not_actions      = []
        not_data_actions = []
      }
      scope             = var.vnet_id
      assignable_scopes = [var.vnet_id]
    },
    "CUSTOM - ALZ WS UAI user" = {
      description = "Allows Data scientists to create ml compute using the uai created for aml"
      permissions = {
        actions          = ["Microsoft.ManagedIdentity/userAssignedIdentities/assign/action"]
        data_actions     = []
        not_actions      = []
        not_data_actions = []
      }
      scope             = var.uai_ws
      assignable_scopes = [var.uai_ws]
    },
    "CUSTOM - ALZ create SFTP users" = {
      description = "Allows Data scientists to create SFTP users on stg accounts"
      permissions = {
        actions = [
          "Microsoft.Storage/storageAccounts/localusers/write",
          "Microsoft.Storage/storageAccounts/localusers/regeneratePassword/action",
          "Microsoft.Storage/storageAccounts/localusers/listKeys/action",
          "Microsoft.Storage/storageAccounts/localusers/read"
        ]
        data_actions     = []
        not_actions      = []
        not_data_actions = []
      }
      scope             = data.azurerm_resource_group.rg.id
      assignable_scopes = [data.azurerm_resource_group.rg.id]
    },
    "CUSTOM - ALZ dev users" = {
      description = "Allows Data scientists to create variuos resources"
      permissions = {
        actions = [
          "Microsoft.Web/sites/*",
          "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/write",
          "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/write",
          "Microsoft.CognitiveServices/accounts/listKeys/action",
          "Microsoft.OperationalInsights/workspaces/write",
          "Microsoft.Web/ServerFarms/write",
          "Microsoft.Web/Sites/write",
          "Microsoft.Storage/storageAccounts/listKeys/action"
          # "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/create",
          # "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/upsert",
          # "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/delete",
          # "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/items/read",
          # "Microsoft.DocumentDB/databaseAccounts/sqlDatabases/containers/executeQuery",
          # "Microsoft.DocumentDB/databaseAccounts/readMetadata"
        ]
        data_actions     = []
        not_actions      = []
        not_data_actions = []
      }
      scope             = data.azurerm_resource_group.rg.id
      assignable_scopes = [data.azurerm_resource_group.rg.id]
    },
    "CUSTOM - ALZ cosmosdb data contributor" = {
      description = "Allows identities to create cosmos db resources"
      permissions = {
        actions = [
          "Microsoft.DocumentDB/databaseAccounts/*",
          # "Microsoft.DocumentDB/databaseAccounts/databases/collections/*",
          # "Microsoft.DocumentDB/databaseAccounts/services/*",
          # "Microsoft.DocumentDB/databaseAccounts/mongodbDatabases/collections/*",
          # "Microsoft.DocumentDB/databaseAccounts/tables/*"
          # Microsoft.DocumentDB/databaseAccounts/apis/databases/containers/write
        ]
        data_actions = [
        ]
        not_actions      = []
        not_data_actions = []
      }
      scope             = data.azurerm_resource_group.rg.id
      assignable_scopes = [data.azurerm_resource_group.rg.id]
    }
  }

}
