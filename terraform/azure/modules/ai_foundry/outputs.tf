output hub_id {
  description = "The ID of the AI Foundry workspace."
  value       = azurerm_ai_foundry.foundry_hub.id
}

output project_id {
  description = "The ID of the AI Foundry project."
  value       = azurerm_ai_foundry_project.first_foundry_project.id
}

output hub_identity_principal_id {
  description = "The principal ID of the AI Foundry hub's managed identity."
  value       = azurerm_ai_foundry.foundry_hub.identity[0].principal_id
}

output project_identity_principal_id {
  description = "The principal ID of the AI Foundry project's managed identity."
  value       = azurerm_ai_foundry_project.first_foundry_project.identity[0].principal_id
}