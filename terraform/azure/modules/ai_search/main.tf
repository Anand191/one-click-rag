resource "azurerm_search_service" "defaultsearch" {
  name                         = var.search_service_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  sku                          = var.sku
  replica_count                = var.replica_count
  partition_count              = var.partition_count
  local_authentication_enabled = true
  authentication_failure_mode  = "http403"

  public_network_access_enabled = true
  network_rule_bypass_option    = "AzureServices"
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}