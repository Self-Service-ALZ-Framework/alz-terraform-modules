resource "azurerm_container_registry" "acr" {
  name                = "acr${var.name}"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "Premium"
  admin_enabled       = true

  public_network_access_enabled = true
  # Configure with your organization's IP ranges
  network_rule_set {
    default_action = "Allow"
    ip_rule = [
      # Add your organization's IP ranges here. Example:
      # {
      #   action   = "Allow"
      #   ip_range = "<YOUR_ORG_IP_RANGE_1>"  # e.g., "10.0.0.0/24"
      # },
    ]
  }

  lifecycle { ignore_changes = [identity] }
}



terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      # configuration_aliases = [ azurerm.hub ]
    }
  }
}