# ---------------- METADATA ------------------------
variable "location" {
  description = "The location/region where the Function Appsis created."
  type        = string
}

variable "location_abbreviation" {
  description = "The short location name, according to DevOps standards."
  type        = string
}

variable "product" {
  description = "The name of the product this Function Appsis for."
  type        = string
  default     = "pxr"
}

variable "environment" {
  description = "The environment this Function Appsis situated within."
  type        = string
}

variable "name_suffix" {
  description = "Optional suffix to append to the Function Appsname."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to this resource."
  type        = map(string)
}
# ------------- END METADATA -----------------------

#--------------APP SERVICE-------------------------
variable "kind" {
  description = "App service plan kind to this resource."
  type        = string
  default     = "xenon"
}

variable "sku" {
  description = "App Service plan sku block. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service_plan.html#sku"
  type        = map(string)
}
variable "plantype" {
  description = "App Service plan TYRP. Reference values are webapp, function. "
  type        = string
}

#--------------END APP SERVICE-------------------------

# ------------- DEPENDENCIES -----------------------
variable "resource_group_name" {
  description = "The name of the resource group to create this Function Apps in."
  type        = string
}

# ------------- END DEPENDENCIES -------------------