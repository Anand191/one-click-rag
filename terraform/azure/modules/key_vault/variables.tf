variable "prefix" {
  type        = string
  description = "Prefix for resource names."
}

variable "suffix" {
  type        = string
  description = "Random suffix for resource names."
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "tenant_id" {
  type        = string
  description = "The tenant ID for the Key Vault."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}