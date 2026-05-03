resource "azurerm_resource_provider_registration" "provider_register" {
  for_each = toset(var.providers_list)
  name     = each.value
}

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.hub ]
    }
  }
}