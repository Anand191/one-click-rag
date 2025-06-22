resource "azurerm_storage_account" "default" {
  name                            = "${var.prefix}storage${var.suffix}"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  account_tier                    = "Standard"
  account_replication_type        = "GRS"
  allow_nested_items_to_be_public = false
  tags                            = var.tags
}

resource "azurerm_storage_account_network_rules" "storage_network_rules" {
  storage_account_id         = azurerm_storage_account.default.id
  default_action             = "Deny"
  ip_rules                   = var.ip_rules
  virtual_network_subnet_ids = [var.subnet_id]
  bypass                     = ["AzureServices"]
}

resource "azurerm_storage_container" "defaultblob" {
  name                  = "${var.prefix}blob${var.suffix}"
  storage_account_id    = azurerm_storage_account.default.id
  container_access_type = "private"
}

resource "azurerm_storage_container" "fapp_src_blob" {
  name                  = "func-app-src-${var.suffix}"
  storage_account_id    = azurerm_storage_account.default.id
  container_access_type = "private"
}
resource "azurerm_storage_container" "fapp_dest_blob" {
  name                  = "func-app-tgt-${var.suffix}"
  storage_account_id    = azurerm_storage_account.default.id
  container_access_type = "private"
}