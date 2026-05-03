data "azuread_users" "users_ds" {
  user_principal_names = var.data_scientist
}

data "azuread_users" "users_ml" {
  user_principal_names = var.ml_engineer
}

data "azuread_users" "users_mlops" {
  user_principal_names = var.mlops
}

data "azuread_users" "users_operations" {
  user_principal_names = var.operations
}

data "azuread_users" "users_devops" {
  user_principal_names = var.devops
}

data "azuread_users" "users_devops_lead" {
  user_principal_names = var.devops_lead
}

locals {
  user_lookup       = { for user in distinct(concat(data.azuread_users.users_ds.users, data.azuread_users.users_ml.users, data.azuread_users.users_mlops.users, data.azuread_users.users_operations.users, data.azuread_users.users_devops.users, data.azuread_users.users_devops_lead.users)) : lower(user.user_principal_name) => user }
  users_ds          = { for email in var.data_scientist : lower(email) => lookup(local.user_lookup, lower(email), { "object_id" = "" }) }
  users_ml          = { for email in var.ml_engineer : lower(email) => lookup(local.user_lookup, lower(email), { "object_id" = "" }) }
  users_mlops       = { for email in var.mlops : lower(email) => lookup(local.user_lookup, lower(email), { "object_id" = "" }) }
  users_operations  = { for email in var.operations : lower(email) => lookup(local.user_lookup, lower(email), { "object_id" = "" }) }
  users_devops      = { for email in var.devops : lower(email) => lookup(local.user_lookup, lower(email), null) }
  users_devops_lead = { for email in var.devops_lead : lower(email) => lookup(local.user_lookup, lower(email), { "object_id" = "" }) }

  all_users = { for email in toset(concat(var.data_scientist, var.ml_engineer, var.mlops)) : lower(email) => lookup(local.user_lookup, lower(email), null) }
}

data "azurerm_resource_group" "rg" {
  name = var.rg_name
}


data "azurerm_client_config" "config" {}


# data "azurerm_resource_group" "nl-rg" {
#   name = var.nl_rg_name
# }

# data "azurerm_resource_group" "live-openai-rg" {
#   name = var.live_openai_rg_name
# }

# data "azurerm_resource_group" "live-rg" {
#   name = var.live_rg_name
# }
