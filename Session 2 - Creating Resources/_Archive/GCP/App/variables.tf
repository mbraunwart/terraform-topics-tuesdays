variable "container_image_name" {
  type        = string
  description = "(Required) Container Image Name to deploy to Cloud Run Service"
  default     = "mrbacr.azurecr.io/ttnode:latest"
}