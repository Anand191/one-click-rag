output "resource_group_name" {

  description = "The name of the created resource group."
  value       = azurerm_resource_group.rg.name
}

output "virtual_network_name" {
  description = "The name of the created virtual network."
  value       = module.networking.vnet_name
}

output "subnet_1_name" {
  description = "The name of the created subnet 1."
  value       = module.networking.data_subnet_name
}

output "subnet_2_name" {
  description = "The name of the created subnet 2."
  value       = module.networking.ai_subnet_name
}

output "storage_account_name" {
  description = "The name of the created storage account"
  value       = module.storage.storage_account_name
}

output "azurerm_search_service_name" {
  description = "The name of the created ai search resource"
  value       = module.ai_search.search_service_name
}

output "azurerm_openai_resource_name" {
  description = "The name of the created openai resource"
  value       = module.openai.openai_account_name
}

output "function_app_name" {
  description = "The name of the created function app."
  value       = module.function_app.function_app_name
}
