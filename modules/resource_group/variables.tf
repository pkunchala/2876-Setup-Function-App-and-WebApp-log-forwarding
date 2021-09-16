variable "location" {
  description = "The location/region where the resource group is created."
  type        = string
}

variable "location_abbreviation" {
  description = "The short location name, according to DevOps standards."
  type        = string
}

variable "product" {
  description = "The name of the product this resource group is for."
  type        = string
  default     = "pxr"
}

variable "environment" {
  description = "The environment this resource group is situated within."
  type        = string
}

variable "name_suffix" {
  description = "Optional suffix to append to the resource group name."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to this resource."
  type        = map(string)
}

