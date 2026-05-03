##################################################
# RESOURCES                                      #
##################################################
resource "azurerm_role_definition" "custom_role" {
  for_each    = var.custom_role_definitions
  name        = "${each.key} ${var.resource_name}"
  scope       = each.value.scope
  description = each.value.description
  permissions {
    actions          = try(each.value.permissions.actions, [])
    data_actions     = try(each.value.permissions.data_actions, [])
    not_actions      = try(each.value.permissions.not_actions, [])
    not_data_actions = try(each.value.permissions.not_data_actions, [])
  }
  assignable_scopes = each.value.assignable_scopes
  lifecycle {
    ignore_changes = [scope, assignable_scopes]
  }
}
