# Create Azure AI Foundry service
resource "azurerm_ai_foundry" "foundry_hub" {
  name                = "foundry-hub-default"                  # AI Foundry service name
  location            = var.location                           # Location from Vars
  resource_group_name = var.resource_group_name                # Resource group name
  storage_account_id  = var.storage_account_id                 # Associated storage account
  key_vault_id        = var.key_vault_id                       # Associated Key Vault
  application_insights_id = var.application_insights_id        # Application Insights ID
  tags                = var.tags                               # Tags for the resource

  identity {
    type = "SystemAssigned" # Enable system-assigned managed identity
  }
}

# Create an AI Foundry Project within the AI Foundry service
resource "azurerm_ai_foundry_project" "first_foundry_project" {
  name               = "first-foundry-project"                  # Project name
  location           = azurerm_ai_foundry.foundry_hub.location  # Location from AI Foundry service
  ai_services_hub_id = azurerm_ai_foundry.foundry_hub.id        # Associated AI Foundry service
  tags                = var.tags                                # Tags for the resource

  identity {
    type = "SystemAssigned" # Enable system-assigned managed identity
  }
}