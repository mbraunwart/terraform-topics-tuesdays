
variable "registry_address" {
  type        = string
  description = "(Required) Address to container registry, used for authentication."
  default     = "mrbacr.azurecr.io"
}

variable "image_name" {
  type        = string
  description = "(Required) image name"
  default     = "ttnodeweb"
}