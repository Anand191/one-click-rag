variable "app_service_plan_name" {
  type        = string
  description = "Name for the App Service Plan."
}

variable "function_app_name" {
  type        = string
  description = "Name for the Function App."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
}

variable "storage_account_name" {
  type        = string
  description = "The name of the storage account to link to the function app."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}