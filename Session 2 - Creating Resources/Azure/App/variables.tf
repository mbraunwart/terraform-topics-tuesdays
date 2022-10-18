variable "prefix" {
  type        = string
  default     = "mrb"
  description = "Prefix applied to resource names"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) AzureRM Resource Group Name"
  default     = "mrb-acr"
}

variable "registry_address" {
  type        = string
  description = "(Required) Address to container registry, used for authentication."
  default     = "mrbacr.azurecr.io"
}

variable "registry_username" {
  type        = string
  description = "(Required) Username to access container registry, used for authentication."
  default     = "mrbacr"
}

variable "registry_password" {
  type        = string
  description = "(Required) Password to access container registry, used for authentication."
  default     = "goykSkA=7vVxfHXcKz8T3RovopPFdLVi"
}

variable "image_name" {
  type        = string
  description = "(Required) image name"
  default     = "ttnodeweb"
}

variable "image_tag" {
  type        = string
  description = "(Required) tag of image"
  default     = "latest"
}