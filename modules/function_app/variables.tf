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

#--------------FUNCTION APP-------------------------

variable "func_name" {
  description = "The list of function apps to deploy"
  type        = string
  default     = ""
}

variable "function_version" {
  description = "The runtime version associated with the Function App."
  type        = string
  default     = "~3"
}


variable "https_only" {
  description = "Disable http procotol and keep only https"
  type        = bool
  default     = true
}
variable "os_type" {
  description = "A string indicating the Operating System type for this function app."
  type        = string
  default     = null
}
variable "site_config" {
  description = "Site config for App Service."
  type        = any
  default     = {}
}
variable "app_settings" {
  type        = map(any)
  description = "App settings"
  default = {
    ServiceBusConnection                      = ""
    FUNCTIONS_EXTENSION_VERSION               = "~3"
    FUNCTIONS_WORKER_RUNTIME                  = ""
    WEBSITE_MAX_DYNAMIC_APPLICATION_SCALE_OUT = ""
    HttpTimeOut                               = ""
    BaseDBContext                             = ""
    Environment                               = ""
    JobConfigurationQuery                     = ""
    LogPath                                   = ""
    WEBSITE_CONTENTAZUREFILECONNECTIONSTRING  = ""
    WEBSITE_CONTENTSHARE                      = ""
  }
}
variable "fileshare_name" {
  description = "Name of the file share"
  type        = string
}
variable "quota" {
  description = "Fileshare size in GB"
  type        = number
  default     = 50
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
variable "vnetint_enable" {
  type        = bool
  description = "This will create a VNET Integration for Function App if set to true"
  default     = false
}
variable "subnet_id" {
  description = "Name of the subnet id"
  type        = string
}
#-------------END FUNCTION APP-------------------------

# ------------- DEPENDENCIES -----------------------
variable "resource_group_name" {
  description = "The name of the resource group to create this Function Apps in."
  type        = string
}
variable "func_app_service_plan_id" {
  description = "Id of the App Service Plan for Function App hosting"
  type        = string
}
variable "storage_account_name" {
  description = "Name of the Storage account to attach to function"
  type        = string
  default     = null
}

variable "storage_account_access_key" {
  description = "Access key the storage account to use. If null a new storage account is created"
  type        = string
  default     = null
}

# ------------- END DEPENDENCIES -------------------