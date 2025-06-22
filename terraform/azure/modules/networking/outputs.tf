output "vnet_id" {
  value = azurerm_virtual_network.rg_vnet.id
}

output "vnet_name" {
  value = azurerm_virtual_network.rg_vnet.name
}

output "data_subnet_id" {
  value = azurerm_subnet.data_subnet.id
}

output "data_subnet_name" {
  value = azurerm_subnet.data_subnet.name
}

output "ai_subnet_id" {
  value = azurerm_subnet.ai_subnet.id
}

output "ai_subnet_name" {
  value = azurerm_subnet.ai_subnet.name
}