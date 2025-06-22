resource "azurerm_virtual_network" "rg_vnet" {
  name                = var.vnet_name
  address_space       = ["10.1.0.0/24"]
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags
}

resource "azurerm_subnet" "data_subnet" {
  name                 = "data"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.rg_vnet.name
  address_prefixes     = ["10.1.0.0/27"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.CognitiveServices"]

  private_endpoint_network_policies = "Enabled"
}

resource "azurerm_subnet" "ai_subnet" {
  name                 = "ai"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.rg_vnet.name
  address_prefixes     = ["10.1.0.32/27"]
  service_endpoints    = ["Microsoft.Storage", "Microsoft.CognitiveServices"]

  private_endpoint_network_policies = "Enabled"
}