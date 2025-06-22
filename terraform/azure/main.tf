resource "random_pet" "rg_name" {
  prefix = var.resource_group_name_prefix
}

resource "random_string" "suffix" {
  length  = 4
  special = false
  upper   = false
}

resource "azurerm_resource_group" "rg" {
  location = var.default_location
  name     = random_pet.rg_name.id
  tags     = var.tags
}

data "azurerm_client_config" "current" {}

module "networking" {
  source = "./modules/networking"

  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  vnet_name           = "${random_pet.rg_name.id}-vnet"
  tags                = var.tags
}

module "storage" {
  source = "./modules/storage"

  prefix              = var.prefix
  suffix              = random_string.suffix.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = module.networking.data_subnet_id
  ip_rules            = [var.local_ip, var.static_ip_1, var.static_ip_2, var.portal_ip]
  tags                = var.tags
}

module "key_vault" {
  source = "./modules/key_vault"

  prefix              = var.prefix
  suffix              = random_string.suffix.result
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  tags                = var.tags
}

module "ai_search" {
  source = "./modules/ai_search"

  search_service_name = "${random_pet.rg_name.id}-aisearch"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = var.sku
  replica_count       = var.replica_count
  partition_count     = var.partition_count
  tags                = var.tags
}

module "openai" {
  source = "./modules/openai"

  openai_deployment_name = var.openai_deployment
  location               = var.cognitive_services_location
  resource_group_name    = azurerm_resource_group.rg.name
  tags                   = var.tags
  ip_rules               = [var.local_ip, var.static_ip_1, var.static_ip_2, var.portal_ip]
  openai_deployments     = var.openai_deployments
}

module "function_app" {
  source = "./modules/function_app"

  app_service_plan_name = "${random_pet.rg_name.id}-app-service-plan"
  function_app_name     = "doc-processor-func-app-${random_string.suffix.result}"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = var.default_location
  storage_account_name  = module.storage.storage_account_name
  tags                  = var.tags
}

# ALL RBACs
# --------
// MANAGED IDENTITY SCOPED TO BLOB CONTAINER ASSIGNED TO AI SEARCH
resource "azurerm_role_assignment" "rbac_blob_aisearch" {
  role_definition_name = "Storage Blob Data Contributor"
  scope                = module.storage.storage_account_id
  principal_id         = module.ai_search.search_service_identity_principal_id
}

// MANAGED IDENTITY SCOPED TO BLOB CONTAINER ASSIGNED TO OPENAI
resource "azurerm_role_assignment" "rbac_blob_openai" {
  role_definition_name = "Storage Blob Data Contributor"
  scope                = module.storage.storage_account_id
  principal_id         = module.openai.openai_identity_principal_id
}

// MANAGED IDENTITY SCOPED TO OPENAI ASSIGNED TO AI SEARCH
resource "azurerm_role_assignment" "rbac_openai_aisearch" {
  role_definition_name = "Cognitive Services OpenAI Contributor"
  scope                = module.openai.openai_account_id
  principal_id         = module.ai_search.search_service_identity_principal_id
}

// MANAGED IDENTITY SCOPED TO AI SEARCH ASSIGNED TO OPENAI
resource "azurerm_role_assignment" "rbac_aisearch_openai" {
  role_definition_name = "Search Service Contributor"
  scope                = module.ai_search.search_service_id
  principal_id         = module.openai.openai_identity_principal_id
}

resource "azurerm_role_assignment" "rbac_aisearch_openai_2" {
  role_definition_name = "Search Index Data Contributor"
  scope                = module.ai_search.search_service_id
  principal_id         = module.openai.openai_identity_principal_id
}

resource "azurerm_role_assignment" "rbac_aisearch_openai_3" {
  role_definition_name = "Search Index Data Reader"
  scope                = module.ai_search.search_service_id
  principal_id         = module.openai.openai_identity_principal_id
}

// MANAGED IDENTITY SCOPED TO BLOB CONTAINER ASSIGNED TO FUNCTION APP
resource "azurerm_role_assignment" "rbac_blob_fapp" {
  role_definition_name = "Storage Blob Data Contributor"
  scope                = module.storage.storage_account_id
  principal_id         = module.function_app.function_app_identity_principal_id
}

// MANAGED IDENTITY SCOPED TO OpenAI ASSIGNED TO FUNCTION APP
resource "azurerm_role_assignment" "rbac_openai_fapp" {
  role_definition_name = "Cognitive Services OpenAI Contributor"
  scope                = module.openai.openai_account_id
  principal_id         = module.function_app.function_app_identity_principal_id
}

// MANAGED IDENTITY SCOPED TO AI SEARCH INDEX TO FUNCTION APP
resource "azurerm_role_assignment" "rbac_aisearch_fapp" {
  role_definition_name = "Search Index Data Contributor"
  scope                = module.ai_search.search_service_id
  principal_id         = module.function_app.function_app_identity_principal_id
}
