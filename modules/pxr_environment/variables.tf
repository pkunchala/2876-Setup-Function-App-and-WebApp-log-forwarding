# ------------- AZURERM PROVIDER ------------------------
variable "tenant_id" {
  description = "The ID of our Azure tenant"
  type        = string
  default     = "66b904a2-2bfc-4d24-a410-96b77b32bf77"
}

variable "subscription_id" {
  description = "The subscription ID of ACR subscription"
  type        = string
  default     = "9112a00a-0803-4a73-9c46-b0712f05833c"
}

variable "client_id" {
  description = "The client ID of ACR subscription"
  type        = string
  default     = "6ad62639-ee80-4f70-9df6-62fb1b884f1d"
}

variable "client_secret" {
  description = "The client secret of ACR subscription"
  type        = string
  default     = "#{phlexrim-dev-sp-secret}#"
}

# ------------- END AZURERM PROVIDER --------------------
#------------- METADATA --------------------------------
variable "environment" {
  description = "The name of the environment we're creating."
  type        = string
}

variable "location" {
  description = "The Azure location to create this environment in."
  type        = string
}
variable "product" {
  description = "The name of the product this Function Appsis for."
  type        = string
}

variable "location_abbreviation" {
  description = "The short location name, according to DevOps standards."
  type        = string
}

variable "cost_centre" {
  description = "The cost centre of this environment."
  type        = string
  default     = "Technology"
}
# ------------ END METADATA ----------------------------
#--------------APP SERVICE-----------------------------
variable "appsvc_names" {
  description = "The name of web app"
  type        = list(string)

}

variable "appsvc_kind" {
  description = "App service plan kind to this resource."
  type        = string
  default     = "xenon"
}
variable "slot_name" {
  description = "Slot name for Web app"
  type        = string
  default     = "dev"
}
#APP SERVICE PLAN FOR WEBAPP CONTAINER
variable "appsvc_sku" {
  description = " App Service Plan SKU ."
  type        = string
  default     = "PremiumV3" #"PremiumContainer"
}

variable "appsvc_size" {
  description = "App Service Plan Size"
  type        = string
  default     = "P2v3"
}
#APP SERVICE PLAN FOR FUNCTION APP
variable "func_kind" {
  description = "App service plan kind to this resource."
  type        = string
  default     = "Windows"
}
variable "func_sku" {
  description = " App Service Plan SKU ."
  type        = string
  default     = "Standard"
}

variable "func_size" {
  description = "App Service Plan Size"
  type        = string
  default     = "S1"
}

variable "web_authorized_ips" {
  description = "IPs restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "web_authorized_subnet_ids" {
  description = "Subnets restriction for App Service. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}
variable "app_vnetint_enable" {
  type        = bool
  description = "This will enable VNET Integration for App Service if set to true"
  default     = false
}
variable "app_subnet_id" {
  description = "Name of the subnet id"
  type        = string
  default     = null
}
#--------------END APP SERVICE-------------------------
#------------ACR---------------------------------------
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
#------------END ACR------------------------------------
#------------- FUNCTION SETTINGS------------------------

variable "function_language" {
  description = "Language of the Function App on Linux hosting, can be \"dotnet\", \"node\" or \"python\""
  type        = string
  default     = "dotnet"
}

variable "os_type" {
  description = "A string indicating the Operating System type for this function app."
  type        = string
  default     = "windows"
}
variable "BaseDBContext" {
  description = "The app setting variable for Functions."
  type        = string
  default     = ""
}
variable "func_Environment" {
  description = "The app setting variable for Functions."
  type        = string
  default     = "dev"
}
variable "max_app_scaleout" {
  description = "The app setting variable for Functions."
  type        = string
  default     = "10"
}
variable "func_authorized_ips" {
  description = "IPs restriction for Function App. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}

variable "func_authorized_subnet_ids" {
  description = "Subnets restriction for Function App. See documentation https://www.terraform.io/docs/providers/azurerm/r/app_service.html#ip_restriction"
  type        = list(string)
  default     = []
}
variable "func_vnetint_enable" {
  type        = bool
  description = "This will enable VNET Integration for Function App if set to true"
  default     = false
}
variable "func_subnet_id" {
  description = "Name of the subnet id"
  type        = string
  default     = null
}
#------------- END FUNCTION SETTINGS-------------------
#--------------SERVICE BUS ----------------------------
variable "servicebus" {
  description = "Servicebus topics & subscription details"
  type        = any
  default = {
    topic-cunesoft-engine  = ["sub-cunesoft-engine"]
    topic-cunesoft-service = ["sub-cunesoft-service"]

  }
}
#--------------END SERVICE BUS ----------------------------
# ------------ CONFIG ----------------------------------

variable "is_production" {
  description = "Whether or not this environment is a production environment."
  type        = bool
  default     = false
}


# ------------ END CONFIG -----------------------------

# ------------- AZURE AD OBJECT IDS ---------------------
variable "devops_security_group" {
  description = "Object ID of the DevOps group"
  type        = string
  default     = "63327d3e-03b5-43a8-a43b-707df2382c95"
}

variable "software_tester_security_group" {
  description = "Object ID of the Software Tester group"
  type        = string
  default     = "4cf7bed4-93a8-4a90-af53-410086748257"
}

variable "developer_security_group" {
  description = "Object ID of the Developer group"
  type        = string
  default     = "034222fb-2f60-4854-aeda-85f60f135702"
}
variable "developer_ness_security_group" {
  description = "Object ID of the Developer group"
  type        = string
  default     = "d3fbd574-147c-4ac6-82ae-2273399a8afe"
}

# ------------- END AZURE AD OBJECT IDS -----------------
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
variable "fileshare_name" {
  description = "name of fileshare"
  type        = string
}
variable "quota" {
  description = "Fileshare size in GB"
  type        = number
  default     = 50
}