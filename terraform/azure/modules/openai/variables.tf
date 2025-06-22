variable "openai_deployment_name" {
  type        = string
  description = "Name of the Open AI resource."
}

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

variable "ip_rules" {
  type        = list(string)
  description = "List of IP addresses to allow access."
}

variable "openai_deployments" {
  description = "(Optional) Specifies the deployments of the Azure OpenAI Service"
  type = list(object({
    name = string
    model = object({
      name    = string
      version = string
    })
    rai_policy_name = string
    sku_name        = string
    capacity        = number
  }))
}