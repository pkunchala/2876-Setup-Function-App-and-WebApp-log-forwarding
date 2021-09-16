# ---------------- METADATA ------------------------
variable "location" {
  description = "The location/region where the VNet is created."
  type        = string
}

variable "location_abbreviation" {
  description = "The short location name, according to DevOps standards."
  type        = string
}

variable "product" {
  description = "The name of the product this VNet is for."
  type        = string
  default     = "test"
}

variable "environment" {
  description = "The environment this VNet resides within."
  type        = string
}

variable "name_suffix" {
  description = "Optional suffix to append to the VNet name."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to this resource."
  type        = map(string)
}



# ---------------- END METADATA ------------------------

# --------------- DEPENDENCIES ------------------------

variable "vnet_names" {
  description = "Names of the both virtual networks peered provided in list format."
  type        = list(any)
}

variable "resource_group_names" {
  description = "Names of both Resources groups of the respective virtual networks provided in list format"
  type        = list(any)
}

variable "subscription_ids" {
  description = "List of two subscription ID's provided in cause of allow_cross_subscription_peering set to true."
  type        = list(any)
  default     = ["", ""]
}

variable "allow_virtual_network_access" {
  description = "Controls if the VMs in the remote virtual network can access VMs in the local virtual network. Defaults to false."
  type        = bool
  default     = false
}

variable "allow_forwarded_traffic" {
  description = "Controls if forwarded traffic from VMs in the remote virtual network is allowed. Defaults to false."
  type        = bool
  default     = true
}

variable "allow_gateway_transit" {
  description = "Controls gatewayLinks can be used in the remote virtual network’s link to the local virtual network. Must be set to false for Global VNET peering."
  type        = bool
  default     = true
}

variable "use_remote_gateways" {
  description = "(Optional) Controls if remote gateways can be used on the local virtual network. If the flag is set to true, and allow_gateway_transit on the remote peering is also true, virtual network will use gateways of remote virtual network for transit. Defaults to false."
  type        = bool
  default     = false
}

variable "tenant_id_pri" {
  description = "The ID for tenant 1"
  type        = string
  default     = "66b904a2-2bfc-4d24-a410-96b77b32bf77"
}

variable "tenant_id_sec" {
  description = "The ID for tenant 2"
  type        = string
  default     = "26698389-6e88-4d87-a2d9-88f7e7efc539"
}

variable "client_id_pri" {
  description = "Service principal client ID in tenant 1(Phlexglobal)"
  type        = string
}

variable "secret_pri" {
  description = "Service principal secret in tenant 1(Phlexglobal)"
  type        = string
}

variable "peer_names" {
  description = "Names that will be applied to the peering members to define the full name of the peering relationship"
  type        = list(string)
}
# ------------- END DEPENDENCIES -----------------------