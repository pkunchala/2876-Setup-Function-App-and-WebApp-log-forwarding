# ---------------- METADATA ------------------------
variable "location" {
  description = "The location/region where the storage account is created."
  type        = string
}

variable "location_abbreviation" {
  description = "The short location name, according to DevOps standards."
  type        = string
}

variable "product" {
  description = "The name of the product this storage account is for."
  type        = string
  default     = "pxr"
}

variable "environment" {
  description = "The environment this storage account is situated within."
  type        = string
}

variable "name_suffix" {
  description = "Optional suffix to append to the storage account name."
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to this resource."
  type        = map(string)
}

variable "sa_name" {
  description = "storage name to identify different accounts"
  type        = string
}


variable "tier" {
  description = "Name of the storage tier."
  type        = string
  default     = "Standard"
}
variable "replication_type" {
  description = "replication type of the storage ."
  type        = string
  default     = "LRS"
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
variable "container_name" {
  description = "The name of the storage container to put state in."
  type        = string
  default     = "logs"
}

# ------------- END METADATA -----------------------

# ------------- DEPENDENCIES -----------------------
variable "resource_group_name" {
  description = "The name of the resource group to create this storage account in."
  type        = string
}
# ------------- END DEPENDENCIES -------------------