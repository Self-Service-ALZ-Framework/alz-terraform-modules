output "openai_deployment" {
  value = azurerm_cognitive_account.open-ai-instance.id
}

output "endpoint" {
  value = azurerm_cognitive_account.open-ai-instance.endpoint
}

output "key" {
  value = azurerm_cognitive_account.open-ai-instance.primary_access_key
}

output "rg_id" {
  value = azurerm_resource_group.openai-rg.id
}
