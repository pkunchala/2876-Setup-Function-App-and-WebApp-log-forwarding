# ---------------- METADATA ------------------------
variable "location" {
  description = "The Azure region to create the identity in"
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

#--------------IDENTITY-------------------------


variable "identity_name" {
  description = "The name to give the user assigned managed identity"
  type        = string
}


#-------------END IDENTITY APP-------------------------

# ------------- DEPENDENCIES -----------------------
variable "resource_group_name" {
  description = "The name of the resource group to create this Function Apps in."
  type        = string
}


# ------------- END DEPENDENCIES -------------------