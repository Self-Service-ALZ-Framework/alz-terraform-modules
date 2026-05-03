terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.hub ]
    }
    azapi = {
      source  = "azure/azapi"
      version = "1.15.0"
    }
  }
}