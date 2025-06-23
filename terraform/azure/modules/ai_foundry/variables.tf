variable "location" {
  type        = string
  description = "The Azure region where AI HUB will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "storage_account_id" {
  type        = string
  description = "The ID of the associated storage account."
}

variable "key_vault_id" {
  type        = string
  description = "The ID of the associated Key Vault."
}

variable "application_insights_id" {
  type        = string
  description = "The ID of the associated Application Insights."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}