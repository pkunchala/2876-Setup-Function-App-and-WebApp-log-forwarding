# ------------- AZURERM PROVIDER ------------------------
variable "tenant_id" {
  description = "The ID of our Azure tenant"
  type        = string
  default     = "66b904a2-2bfc-4d24-a410-96b77b32bf77"
}

variable "subscription_id" {
  description = "The subscription ID of Phlexrim subscription"
  type        = string
  default     = "e8743f4f-e6b3-48a9-a2b5-1ad457bf6402"
}

variable "client_id" {
  description = "The client ID of Phlexrim subscription"
  type        = string
  default     = "6ad62639-ee80-4f70-9df6-62fb1b884f1d"
}

variable "client_secret" {
  description = "The client secret of Phlexrim subscription"
  type        = string
  default     = "#{phlexrim-dev-sp-secret}#"
}

# ------------- END AZURERM PROVIDER --------------------
variable "acr_password" {
  description = "The Admin password of the container registry."
  type        = string
  default     = "#{pxr-acr-password}#"
}
variable "BaseDBContext" {
  description = "The app setting variable for Functions."
  type        = string
  default     = "#{pxr-intdb-conncstring}#"
}