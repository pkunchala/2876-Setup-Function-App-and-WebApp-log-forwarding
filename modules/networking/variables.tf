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
}

variable "environment" {
  description = "The environment this VNet resides within."
  type        = string
}
variable "cost_centre" {
  description = "The cost centre of this environment."
  type        = string
  default     = "technology"
}
# ---------------- END METADATA ------------------------

# --------------- DEPENDENCIES ------------------------
variable "resource_group_name" {
  description = "The name of the resource group to create this VNet in."
  type        = string
}

# ------------- END DEPENDENCIES -----------------------

# ---------------- NETWORK CONFIG ----------------------

variable "vnet_address_space" {
  description = "The network address space of this VNet."
  type        = list(string)
}
variable "subnet_names" {
  description = "Names to add to the subnet"
  type        = any

}
# ---------------- END NETWORK CONFIG -------------------