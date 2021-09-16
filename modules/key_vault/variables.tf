variable "location" {
  description = "The location/region where the keyvault is created."
  type        = string
}

variable "location_abbreviation" {
  description = "The short location name, according to DevOps standards."
  type        = string
}

variable "product" {
  description = "The name of the product this keyvault is for."
  type        = string
}

variable "environment" {
  description = "The environment this keyvault resides within."
  type        = string
}

variable "name_suffix" {
  description = "Optional suffix to append to the keyvault name."
  type        = string
  default     = ""
}

variable "resource_group_name" {
  description = "The name of the resource group to create this keyvault in."
  type        = string
}


variable "tags" {
  description = "Tags to apply to this resource."
  type        = map(string)
}

variable "vault_resource_name" {
  description = "String used to identify the type of resource being created"
  type        = string
  default     = "vault"
}

variable "access_policy_object_ids" {
  description = "The object IDs that are allowed to access this key vault"
  type        = list(string)
}

variable "keyvault_secrets" {
  description = "The secrets to add to the vault."
  type = list(object({
    name  = string
    value = string
  }))
  default = []
}


