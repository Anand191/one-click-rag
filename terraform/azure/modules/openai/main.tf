resource "azurerm_cognitive_account" "openai_resource" {
  name                  = var.openai_deployment_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  kind                  = "OpenAI"
  sku_name              = "S0"
  tags                  = var.tags
  custom_subdomain_name = "oai-common-rag-${random_string.subdomain_suffix.result}"

  identity {
    type = "SystemAssigned"
  }

  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
    ip_rules       = var.ip_rules
  }
}

resource "azurerm_cognitive_deployment" "deployment" {
  for_each             = { for deployment in var.openai_deployments : deployment.name => deployment }
  name                 = each.key
  cognitive_account_id = azurerm_cognitive_account.openai_resource.id
  model {
    format  = "OpenAI"
    name    = each.value.model.name
    version = each.value.model.version
  }

  sku {
    name     = each.value.sku_name
    capacity = each.value.capacity
  }
}

resource "random_string" "subdomain_suffix" {
  length  = 6
  special = false
  upper   = false
}