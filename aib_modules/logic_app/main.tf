resource "azurerm_storage_account" "logic_app_stg" {
  name                     = "logicappstf${var.name}"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_app_service_plan" "logic_app_service_plan" {
  name                = "logic-apps-service-plan-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  kind                = "elastic"

  sku {
    tier = "WorkflowStandard"
    size = "WS1"
  }
}
resource "azurerm_service_plan" "logic_app_service_plan" {
  name                = "logic-apps-service-plan-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name

  os_type  = "Linux"
  sku_name = "WS1"
}

resource "azurerm_logic_app_standard" "logic-app" {
  name                       = "logic-app-instance-${var.name}"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  app_service_plan_id        = azurerm_service_plan.logic_app_service_plan.id
  storage_account_name       = azurerm_storage_account.logic_app_stg.name
  storage_account_access_key = azurerm_storage_account.logic_app_stg.primary_access_key
  virtual_network_subnet_id  = var.subnet_id

  site_config {
    vnet_route_all_enabled = true
  }
  identity {
    type         = "SystemAssigned, UserAssigned"
    identity_ids = var.identity_ids
  }
}

resource "azurerm_logic_app_integration_account" "logic-app-integration-account" {
  name                = "logic-app-integration-account-${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = "Standard"
}

#"/subscriptions/0cfe5748-b21c-43b8-aeda-4a7f930c7e5c/resourceGroups/rg-lab4861/providers/Microsoft.Logic/integrationAccounts/dias-vis-eg"

data "azurerm_cosmosdb_account" "cosmos-account" {
  name                = var.cosmosdb_name
  resource_group_name = var.resource_group_name
}
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_role_assignment" "blob_contributor" {
  scope                = data.azurerm_resource_group.rg.id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_logic_app_standard.logic-app.identity[0].principal_id
}

resource "azurerm_role_assignment" "cosmos-contributor" {
  principal_id         = azurerm_logic_app_standard.logic-app.identity[0].principal_id
  scope                = data.azurerm_cosmosdb_account.cosmos-account.id
  role_definition_name = "Contributor"
}