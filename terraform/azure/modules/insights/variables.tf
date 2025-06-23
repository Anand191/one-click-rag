variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}