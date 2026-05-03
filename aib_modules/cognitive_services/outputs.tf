output "endpoint" {
  value = azurerm_cognitive_account.language.endpoint
}

output "access_key" {
  value = azurerm_cognitive_account.language.primary_access_key
}

output "aisearch_id" {
  value = azurerm_search_service.search.id
}

output "language_id" {
  value = azurerm_cognitive_account.language.id
}