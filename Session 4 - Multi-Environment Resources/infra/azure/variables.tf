variable "prefix" {
  type        = string
  default     = "mrb"
  description = "Prefix applied to resource names"
}

variable "environment" {
  type        = string
  description = "Environment selector."
  default     = "dev"
}
