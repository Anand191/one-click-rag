variable "search_service_name" {
  type        = string
  description = "Name of the AI Search service."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group."
}

variable "location" {
  type        = string
  description = "The Azure region where resources will be created."
}

variable "sku" {
  type        = string
  description = "The pricing tier of the search service."
}

variable "replica_count" {
  type        = number
  description = "Number of replicas."
}

variable "partition_count" {
  type        = number
  description = "Number of partitions."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resources."
  default     = {}
}