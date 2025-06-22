output "search_service_id" {
  value = azurerm_search_service.defaultsearch.id
}

output "search_service_name" {
  value = azurerm_search_service.defaultsearch.name
}

output "search_service_identity_principal_id" {
  value = azurerm_search_service.defaultsearch.identity[0].principal_id
}