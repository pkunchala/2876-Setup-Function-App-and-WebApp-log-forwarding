# ---------------- METADATA ------------------------
variable "product" {
  description = "The name of the product this VNet is for."
  type        = string
  default     = "neuron"
}

variable "environment" {
  description = "The environment this VNet resides within."
  type        = string
}

variable "location_abbreviation" {
  description = "The short location name, according to DevOps standards."
  type        = string
}

# ---------------- END METADATA ------------------------
# ---------------- NETWORK CONFIG ----------------------
variable "address_prefix" {
  type        = list(string)
  description = "Specifies the address prefix for the network subnet"
}

variable "subnet_name" {
  type        = string
  description = "Specifies the name for the network subnet"
}

variable "service_endpoints" {
  type        = list(string)
  description = "List of service endpoints to enable on the subnet, e.g. Microsoft.Storage"
  default     = null
}

variable "subnet_delegation" {
  description = "Configuration delegations on subnet"
  type        = map(list(any))
  default     = {}
}
variable "enforce_private_link_endpoint" {
  description = "Enable or Disable network policies for the private link endpoint on the subnet"
  type        = bool
  default     = false
}
variable "enforce_private_link_service" {
  description = "Enable or Disable network policies for the private link endpoint on the subnet.Conflicts with enforce_private_link_endpoint and either one is specified and not the both"
  type        = bool
  default     = false
}
# ---------------- END NETWORK CONFIG -------------------

# --------------- DEPENDENCIES ------------------------
variable "resource_group_name" {
  description = "Resource group name where the vnet exists"
  type        = string
}

variable "virtual_network_name" {
  type        = string
  description = "Name of virtual network where subnet will be added"
}

# ------------- END DEPENDENCIES -----------------------