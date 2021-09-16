# ---------------- METADATA ------------------------
variable "location" {
  description = "The location/region where the service bus is created."
  type        = string
}

variable "location_abbreviation" {
  description = "The short location name, according to DevOps standards."
  type        = string
}

variable "product" {
  description = "The name of the product this service bus is for."
  type        = string
  default     = "pxr"
}

variable "environment" {
  description = "The environment this service bus is situated within."
  type        = string
}

variable "name_suffix" {
  description = "Optional suffix to append to the service bus name."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to this resource."
  type        = map(string)
}
# ------------- END METADATA -----------------------
#--------------SERVICE BUS------------------------
variable "sb_sku" {
  description = "SKU for Service Bus, Supported values are Standard, Premium"
  type        = string
  default     = "Standard"
}

variable "sb_capacity" {
  description = "Capacity for Service Bus"
  type        = string
  default     = "0"
}

variable "listen" {
  description = "Authorisation rules for service bus namespace"
  type        = string
  default     = "true"
}

variable "send" {
  description = "Authorisation rules for service bus namespace"
  type        = string
  default     = "true"
}

variable "manage" {
  description = "Authorisation rules for service bus namespace"
  type        = string
  default     = "false"
}

#--------------END SERVICE BUS----------------------

# ------------- DEPENDENCIES -----------------------
variable "resource_group_name" {
  description = "The name of the resource group to create this service bus in."
  type        = string
}
# ------------- END DEPENDENCIES -------------------
