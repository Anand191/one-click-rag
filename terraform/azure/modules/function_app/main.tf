resource "azurerm_service_plan" "asplan" {
  name                = var.app_service_plan_name
  resource_group_name = var.resource_group_name
  location            = var.location
  os_type             = "Linux"
  sku_name            = "Y1"
  tags                = var.tags
}

resource "azurerm_linux_function_app" "doc_processor_fapp" {
  name                = var.function_app_name
  resource_group_name = var.resource_group_name
  location            = var.location

  storage_account_name            = var.storage_account_name
  storage_uses_managed_identity = true
  service_plan_id               = azurerm_service_plan.asplan.id
  identity {
    type = "SystemAssigned"
  }
  site_config {}
  tags = var.tags
}