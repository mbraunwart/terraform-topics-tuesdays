variable "workspace_name" {
  type        = string
  description = "(Required) Terraform Cloud Workspace Name"
}

variable "organization_name" {
  type        = string
  description = "(Required) Terrafirn Cloud Organization Name"
}

variable "working_directory" {
  type        = string
  description = "(Optional) Working Directory in repository, defaults to root."
  default     = ""
}

variable "workspace_variables" {
  type = list(object({
    key         = string
    value       = string
    category    = string
    description = optional(string)
    sensitive   = optional(bool)
  }))
  description = "(Optional) List of Variables to make available to the workspace."
  validation {
    condition     = alltrue([for v in var.workspace_variables : contains(["env", "terraform"], v.category)])
    error_message = "Category must be one of `env` or `terraform`."
  }
}