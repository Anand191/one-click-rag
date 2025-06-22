output "openai_account_id" {
  value = azurerm_cognitive_account.openai_resource.id
}

output "openai_account_name" {
  value = azurerm_cognitive_account.openai_resource.name
}

output "openai_identity_principal_id" {
  value = azurerm_cognitive_account.openai_resource.identity[0].principal_id
}