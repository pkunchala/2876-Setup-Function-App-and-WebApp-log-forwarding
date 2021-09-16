# ---------------- METADATA ------------------------

variable "name" {
  description = "Name of topics to create"
  type        = string
}

# ------------- END METADATA -----------------------


# ------------- TOPIC VARIABLES-----------------------------


variable "status" {
  description = "Attribute for service bus topic"
  type        = string
  default     = "Active"
}


variable "default_message_ttl" {
  description = "Attribute for service bus topic"
  type        = string
  default     = "PT14H"
}

variable "enable_batched_operations" {
  description = "Attribute for service bus topic"
  type        = string
  default     = "false"
}

variable "enable_express" {
  description = "Attribute for service bus topic"
  type        = string
  default     = "false"
}

variable "enable_partitioning" {
  description = "Attribute for service bus topic"
  type        = string
  default     = "false"
}

variable "max_size_in_megabytes" {
  description = "Attribute for service bus topic"
  type        = string
}

variable "requires_duplicate_detection" {
  description = "Attribute for service bus topic"
  type        = string
  default     = "false"
}

variable "support_ordering" {
  description = "Attribute for service bus topic"
  type        = string
  default     = "false"
}

variable "duplicate_detection_history_time_window" {
  description = "Attribute for service bus topic"
  type        = string
  default     = "PT10M"
}

variable "listen" {
  description = "Authorisation rules for service bus topic"
  type        = string
  default     = "true"
}

variable "send" {
  description = "Authorisation rules for service bus topic"
  type        = string
  default     = "true"
}

variable "manage" {
  description = "Authorisation rules for service bus topic"
  type        = string
  default     = "false"
}
# ------------- END TOPIC VARIABLES-------------------------
# ------------- DEPENDENCIES -----------------------
variable "resource_group_name" {
  description = "The name of the resource group to create this service bus in."
  type        = string
}
variable "namespace_name" {
  description = "Name of the service bus namespace"
  type        = string
}
# ------------- END DEPENDENCIES -------------------