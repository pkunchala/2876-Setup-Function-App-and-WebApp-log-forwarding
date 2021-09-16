
variable "location" {
  description = "The region where the infrastructure will be bootstrapped."
  type        = string
  default     = "North Europe"
}

variable "tenant_id" {
  description = "The ID of our Azure tenant"
  type        = string
  default     = "66b904a2-2bfc-4d24-a410-96b77b32bf77"
}

variable "dev_subscription_id" {
  description = "The subscription ID of dev phlexrim subscription"
  type        = string
  default     = "e8743f4f-e6b3-48a9-a2b5-1ad457bf6402"
}

variable "dev_client_id" {
  description = "The client ID of dev phlexrim subscription"
  type        = string
  default     = "6ad62639-ee80-4f70-9df6-62fb1b884f1d"
}

variable "dev_client_secret" {
  description = "The client secret of dev phlexrim subscription"
  type        = string
  default     = "#{phlexrim-dev-sp-secret}#"
}
