variable "location" {
  description = "The Azure location to create the state backend container in."
  type        = string
}

variable "environment" {
  description = "The environment that this state backend serves. Goes into its name."
  type        = string
}

variable "name" {
  description = "The name of this state backend."
  type        = string
}

variable "tags" {
  description = "The tags to put on state backend components."
  type        = map(string)
}

variable "backend_container_name" {
  description = "The name of the storage container to put state in."
  type        = string
  default     = "tfstate"
}
