output "function_app_id" {
  value = azurerm_linux_function_app.doc_processor_fapp.id
}

output "function_app_name" {
  value = azurerm_linux_function_app.doc_processor_fapp.name
}

output "function_app_identity_principal_id" {
  value = azurerm_linux_function_app.doc_processor_fapp.identity[0].principal_id
}