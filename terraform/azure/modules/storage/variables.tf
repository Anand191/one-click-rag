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

variable "subnet_id" {
  type        = string
  description = "The ID of the subnet to associate with the storage account network rules."
}

variable "ip_rules" {
  type        = list(string)
  description = "List of IP addresses to allow access."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}