##################################################
# OUTPUTS                                        #
##################################################
output "role_definition_resource_ids" {
  value       = { for key, role_definition in azurerm_role_definition.custom_role : key => role_definition.role_definition_resource_id }
  description = "List of Azure Resource Manager IDs for the resources."
}