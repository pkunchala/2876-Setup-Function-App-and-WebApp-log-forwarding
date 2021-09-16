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

variable "webapp_name" {
  description = "The name of web app"
  type        = string

}

variable "planid" {
  description = "id of the app service plan"
  type        = string
}
variable "https_only" {
  description = "Enable/Disable https forapp service plan"
  type        = string
  default = "true"
}
variable "mount_points" {
  description = "Storage Account mount points. Name is generated if not set and default type is AzureFiles. See https://www.terraform.io/docs/providers/azurerm/r/app_service.html#storage_account"
  type        = list(map(string))
  default     = []
}
variable "slot_name" {
  description = "App Service slot name"
  type        = string
}

variable "site_config" {
  description = "Site config for App Service."
  type        = any
  default     = {}
}
variable "identity_ids" {
  description = "Specifies a list of user managed identity ids to be assigned"
  default     = null
}
variable "container_type" {
  type        = string
  default     = "docker"
  description = "Type of container. The options are: `docker`, `compose` or `kube`."
}

variable "authorized_ips" {
  description = "IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "authorized_subnet_ids" {
  description = "Subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}
variable "service_tags_allowed" {
  description = "Restrict Service Tags for App Service"
  type        = list(string)
  default     = []
}
variable "storage_container_name" {
  description = "Name of the Storage account to attach to webapp"
  type        = string
  default     = null
}
variable "vnetint_enable" {
  type        = bool
  description = "This will enable VNET Integration for App Service if set to true"
  default     = false
}
variable "subnet_id" {
  description = "Name of the subnet id"
  type        = string
}
#--------------END APP SERVICE-------------------------
#-------------ACR---------------------
variable "acr_username" {
  description = "The User name of the container registry."
  type        = string
}

variable "acr_password" {
  description = "The Admin password of the container registry."
  type        = string
}
variable "acr_name" {
  description = "The name of the container registry."
  type        = string
}

#-------------ACR---------------------
#--------------- Password Rotating-------------
variable "password_end_date" {
  description = "The relative duration or RFC3339 rotation timestamp after which the password expire"
  default     = null
}

variable "password_rotation_in_years" {
  description = "Number of years to add to the base timestamp to configure the password rotation timestamp. Conflicts with password_end_date and either one is specified and not the both"
  default     = "1"
}
#---------------END Password Rotating-------------


# ------------- DEPENDENCIES -----------------------
variable "resource_group_name" {
  description = "The name of the resource group to create this webapp  in."
  type        = string
}
variable "storage_account_name" {
  description = "Name of the Storage account to attach to webapp"
  type        = string
  default     = null
}

variable "connection_string" {
  description = "Name of the Storage accountconnection_string  to attach to webapp"
  type        = string
  default     = null
}
# ------------- END DEPENDENCIES -------------------