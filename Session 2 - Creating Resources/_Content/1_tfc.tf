# Setup Azure Terraform Cloud Workspace

locals {
  workspace_prefix = "mrb-terraform-topics"
}

data "tfe_organization" "org" {
  name = "insight"
}

resource "tfe_workspace" "azure" {
  name         = "${local.workspace_prefix}-azure"
  organization = data.tfe_organization.org.name

  working_directory = "./Session 2 - Creating Resources/Azure/Base"
}

resource "tfe_variable" "arm_subscription_id" {
  key          = "ARM_SUBSCRIPTION_ID"
  value        = "1c6b2cdf-74c6-448e-b9c2-79db4106600b"
  category     = "env"
  description  = "ARM Subscription ID - Visual Studio Enterprise Subscription"
  workspace_id = tfe_workspace.azure.id
}

# Loop through a map of secrets

locals {
  azure_workspace_variables = {
    ARM_SUBSCRIPTION_ID = {
      value       = "1c6b2cdf-74c6-448e-b9c2-79db4106600b"
      description = "ARM Subscription ID - Visual Studio Enterprise Subscription"
    }
    ARM_TENANT_ID = {
      value       = "6c637512-c417-4e78-9d62-b61258e4b619"
      description = "ARM Tenant ID"
    }
    ARM_CLIENT_ID = {
      value       = "efa02987-f044-4bff-b1b4-e3fd6c1cc2a4"
      description = "mrb-terraform-topics client ID"
      sensitive   = true
    }
    ARM_CLIENT_SECRET = {
      value       = "cYz8Q~ejcUnp1Qm2ddN3A3Gqq0eZ_Koyy8kE~cak"
      description = "mrb-terraform-topics client secret"
      sensitive   = true
    }
  }
}

resource "tfe_variable" "var" {
  for_each     = local.azure_workspace_variables
  key          = each.key
  value        = each.value.value
  category     = "env"
  description  = each.value.description
  workspace_id = tfe_workspace.azure.id
  sensitive    = try(each.value.sensitive, false)
}

# Create as module

## variables.tf

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

## main.tf

data "tfe_organization" "org" {
  name = var.organization_name
}

resource "tfe_workspace" "workspace" {
  name         = var.workspace_name
  organization = data.tfe_organization.org.name

  working_directory = var.working_directory
}

resource "tfe_variable" "var" {
  for_each     = { for var in var.workspace_variables : var.key => var }
  key          = each.key
  value        = each.value.value
  category     = each.value.category
  description  = each.value.description
  workspace_id = tfe_workspace.workspace.id
  sensitive    = each.value.sensitive
}

## outputs.tf

output "workspace_id" {
  value       = tfe_workspace.workspace.id
  description = "Generated ID of Workspace"
}

output "workspace_name" {
  value       = tfe_workspace.workspace.name
  description = "Name of workspace"
}

output "terraform_version" {
  value       = tfe_workspace.workspace.terraform_version
  description = "Terraform Version of current workspace."
}

output "workspace_description" {
  value       = tfe_workspace.workspace.description
  description = "Description of workspace."
}

output "name" {
  value       = tfe_workspace.workspace.ssh_key_id
  description = "SSH Key ID."
}


## module modules/workspace

locals {
  workspace_prefix = "mrb-terraform-topics"

  azure_workspace_variables = {
    ARM_SUBSCRIPTION_ID = {
      key         = "ARM_SUBSCRIPTION_ID"
      value       = "1c6b2cdf-74c6-448e-b9c2-79db4106600b"
      description = "ARM Subscription ID - Visual Studio Enterprise Subscription"
    }
    ARM_TENANT_ID = {
      key         = "ARM_TENANT_ID"
      value       = "6c637512-c417-4e78-9d62-b61258e4b619"
      description = "ARM Tenant ID"
    }
    ARM_CLIENT_ID = {
      key         = "ARM_CLIENT_ID"
      value       = "efa02987-f044-4bff-b1b4-e3fd6c1cc2a4"
      description = "mrb-terraform-topics client ID"
      sensitive   = true
    }
    ARM_CLIENT_SECRET = {
      key         = "ARM_CLIENT_SECRET"
      value       = "cYz8Q~ejcUnp1Qm2ddN3A3Gqq0eZ_Koyy8kE~cak"
      description = "mrb-terraform-topics client secret"
      sensitive   = true
    }
  }
}

module "azure_workspace" {
  source = "./modules/workspace"

  workspace_name    = "${local.workspace_prefix}-azure"
  organization_name = "insight"
  working_directory = "./Session 2 - Creating Resources/Azure/Base"
  workspace_variables = [for var in local.azure_workspace_variables :
    {
      key         = var.key
      value       = var.value
      category    = "env"
      description = var.description
      sensitive   = try(var.sensitive, false)
  }]
}

## module with all workspaces

terraform {
  required_providers {
    tfe = {
      version = "~> 0.37.0"
    }
  }

  cloud {}
}

provider "tfe" {}

locals {
  workspace_prefix = "mrb-terraform-topics"

  workspaces = {
    azure-base = {
      working_directory = "./Session 2 - Creating Resources/Azure/Base"
      workspace_variables = {
        ARM_SUBSCRIPTION_ID = {
          key         = "ARM_SUBSCRIPTION_ID"
          value       = "1c6b2cdf-74c6-448e-b9c2-79db4106600b"
          description = "ARM Subscription ID - Visual Studio Enterprise Subscription"
        }
        ARM_TENANT_ID = {
          key         = "ARM_TENANT_ID"
          value       = "6c637512-c417-4e78-9d62-b61258e4b619"
          description = "ARM Tenant ID"
        }
        ARM_CLIENT_ID = {
          key         = "ARM_CLIENT_ID"
          value       = "efa02987-f044-4bff-b1b4-e3fd6c1cc2a4"
          description = "mrb-terraform-topics client ID"
          sensitive   = true
        }
        ARM_CLIENT_SECRET = {
          key         = "ARM_CLIENT_SECRET"
          value       = "4Jd8Q~8zJaohdBthT5OviUZJ2VqHSs5_vphgSc7y"
          description = "mrb-terraform-topics client secret"
          sensitive   = true
        }
      }
    }
    azure-app = {
      working_directory = "./Session 2 - Creating Resources/Azure/App"
      workspace_variables = {
        ARM_SUBSCRIPTION_ID = {
          key         = "ARM_SUBSCRIPTION_ID"
          value       = "1c6b2cdf-74c6-448e-b9c2-79db4106600b"
          description = "ARM Subscription ID - Visual Studio Enterprise Subscription"
        }
        ARM_TENANT_ID = {
          key         = "ARM_TENANT_ID"
          value       = "6c637512-c417-4e78-9d62-b61258e4b619"
          description = "ARM Tenant ID"
        }
        ARM_CLIENT_ID = {
          key         = "ARM_CLIENT_ID"
          value       = "efa02987-f044-4bff-b1b4-e3fd6c1cc2a4"
          description = "mrb-terraform-topics client ID"
          sensitive   = true
        }
        ARM_CLIENT_SECRET = {
          key         = "ARM_CLIENT_SECRET"
          value       = "4Jd8Q~8zJaohdBthT5OviUZJ2VqHSs5_vphgSc7y"
          description = "mrb-terraform-topics client secret"
          sensitive   = true
        }
      }
    }
    aws-base = {
      working_directory = "./Session 2 - Creating Resources/AWS/Base"
      workspace_variables = {
        AWS_ACCESS_KEY_ID = {
          key         = "AWS_ACCESS_KEY_ID"
          value       = "AIDA4VEAXZCXWOQID2NDH"
          description = "terraform-topics-sa access ID"
          sensitive   = true
        }
        AWS_SECRET_ACCESS_KEY = {
          key         = "AWS_SECRET_ACCESS_KEY"
          value       = "xPCZ8b7XCo99SjfvVfJT655UsBJyG/LlT3K3kVCV"
          description = "terraform-topics-sa access secret key"
          sensitive   = true
        }
      }
    }
    aws-app = {
      working_directory = "./Session 2 - Creating Resources/AWS/App"
      workspace_variables = {
        AWS_ACCESS_KEY_ID = {
          key         = "AWS_ACCESS_KEY_ID"
          value       = "AIDA4VEAXZCXWOQID2NDH"
          description = "terraform-topics-sa access ID"
          sensitive   = true
        }
        AWS_SECRET_ACCESS_KEY = {
          key         = "AWS_SECRET_ACCESS_KEY"
          value       = "xPCZ8b7XCo99SjfvVfJT655UsBJyG/LlT3K3kVCV"
          description = "terraform-topics-sa access secret key"
          sensitive   = true
        }
      }
    }
    gcp-base = {
      working_directory = "./Session 2 - Creating Resources/GCP/Base"
      workspace_variables = {
        GOOGLE_CREDENTIALS = {
          key         = "GOOGLE_CREDENTIALS"
          value       = "{ \"type\": \"service_account\", \"project_id\": \"mrb-base-prj\", \"private_key_id\": \"360cb017768a903b53f04b597dd168e10c0ac392\", \"private_key\": \"-----BEGIN PRIVATE KEY-----\\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCs6hGNNfy5HS5j\\nxMI38/9rJ2rrSfRM/hGvbGmKSKvlss5r8glFD8KAh6k0vp7I9600634qRtaYql+d\\n+SRIIHVl3lE9Q7SH3owwZRafA5L1rxH5jKd4BVCIam2Di1ZE6P/yxoj5s3trIQ8H\\nPzjLV415BKwpUbkRWceKVR9c8yhoKFeCDLEp/LjHkbv03GY2e80a9uJluRd0yr68\\n+lmaui9OvtoReNV6iZ5XTNGiBx2TwMI9Q+03oQ74HY4orRa/KZzX70YCd40xk44v\\n3+2ShFQZqjlsHKzeXU++3uQiBsimx5+HkNwExQfR0I6X+38bSW9o1I0ervdq2JIh\\nxYgivRjFAgMBAAECggEAR5pT81BIW1WIqLrJHEd3XOWBQnao6hsJssVnfOJ0AFXH\\nYe7jxMvuZLAIsvU+poTdnjzoTVRxN93RY4bQbee3BZyGsqJvRxYyojWyJN3jhMZe\\n4KJMlQhKXXsI54CTFE0R8/Qfs5sNwAJ8CSm2eInEZTk4m5GiW9t8JD30k1aDxIFE\\nGLH2ChMYHiha2KBp/nZ1Di6AYTgRKO953ACGetnUfMSSgrnxm7cDfTXJ5DELwH5o\\nuj2n0mhInEog6tRxcfUplfW0FIGzAdpBuiL9PF8xIagOxt8ykax5kSWatPSVkxZz\\n7GC+p1VAB1DpgYephumCPRL/7x8DmAGXK7fuQOBa7wKBgQDyqefG8Ha45x+qCcBV\\nI87/hbLwW9PSnJRZ4BE3ld8wBnbgJEnGIwoYpysxOvbtWjvO4dJFqpL40t69FNus\\nomnXloyTkhI1+JXNWEOslStdoOE64veL0+Wanga/NzoKZxjlMBZwHKV3iwJV7I+T\\nVkWD96Knrb2r7PfH7E3U9zLagwKBgQC2aten25s2dX5Rnsi1xDhuePwFsynbq5e4\\nzH5TrQo05i0qMCeNgNGS9VDVYj0iBKBgEBCyI5jFjGdHK7L/5r0pcDyqyW1vJjBG\\ntBtcfQjXv+ng8KeUclIiHMW2nFn3ORffryg/4bqDS8g1nlm1uNPRpYcHo8S/8qE2\\nwKbjomj9FwKBgQCQ/X/lWAw30rESshzfQjQObN5LyzI3ZyMkyELBSaU/Vr10k3oZ\\nDxqbPFcMZUTg8MdHh5pR0edbEPPRWkMfVTOUgvmfuulyogMv3Isi9UYh/VxWCQML\\n4yIPTliNq/vb91nipubhOdyMHtzYZi4rRKLohPAE7ESmE0LBi6m9k64o7QKBgDKQ\\nTxLSRqXDz63kK5Jmv5Wvp3wU+4dOexHYbTPYhTnAi8hj7LLGgFER+sQLJRLm4WV/\\nToFyaIhpsL8Dl+xjExAHcmmMx+7FUSBoECWE6wySv8uAKZN2VNnry8ogcLecdcel\\nD60VbtOyD97887TxdJVqIpG1jXX/VTyODjSO8jclAoGBAJJ9L1A23GgKf/ALbLBv\\nTjB7fn42WJijC96rn8CFIsHMnCs5vVUJd9HEZZelcfj4R32CPvk6Hnws/YVKaNmC\\nJ6IX19RTFNhp399T6iBYoGAc3Cp2wzFxIFYRrtuPXb3fdP4RRUTfG2ihibPCo5de\\naNB4S3j3Fnqreput0N5HQbNF\\n-----END PRIVATE KEY-----\\n\", \"client_email\": \"env-matrix-workflow-sa@mrb-base-prj.iam.gserviceaccount.com\", \"client_id\": \"102547416053711505639\", \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\", \"token_uri\": \"https://oauth2.googleapis.com/token\", \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\", \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/env-matrix-workflow-sa%40mrb-base-prj.iam.gserviceaccount.com\" }"
          description = "Google Credentials created from gcloud cli."
          sensitive   = true
        }
      }
    }
    gcp-app = {
      working_directory = "./Session 2 - Creating Resources/GCP/App"
      workspace_variables = {
        GOOGLE_CREDENTIALS = {
          key         = "GOOGLE_CREDENTIALS"
          value       = "{ \"type\": \"service_account\", \"project_id\": \"mrb-base-prj\", \"private_key_id\": \"360cb017768a903b53f04b597dd168e10c0ac392\", \"private_key\": \"-----BEGIN PRIVATE KEY-----\\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCs6hGNNfy5HS5j\\nxMI38/9rJ2rrSfRM/hGvbGmKSKvlss5r8glFD8KAh6k0vp7I9600634qRtaYql+d\\n+SRIIHVl3lE9Q7SH3owwZRafA5L1rxH5jKd4BVCIam2Di1ZE6P/yxoj5s3trIQ8H\\nPzjLV415BKwpUbkRWceKVR9c8yhoKFeCDLEp/LjHkbv03GY2e80a9uJluRd0yr68\\n+lmaui9OvtoReNV6iZ5XTNGiBx2TwMI9Q+03oQ74HY4orRa/KZzX70YCd40xk44v\\n3+2ShFQZqjlsHKzeXU++3uQiBsimx5+HkNwExQfR0I6X+38bSW9o1I0ervdq2JIh\\nxYgivRjFAgMBAAECggEAR5pT81BIW1WIqLrJHEd3XOWBQnao6hsJssVnfOJ0AFXH\\nYe7jxMvuZLAIsvU+poTdnjzoTVRxN93RY4bQbee3BZyGsqJvRxYyojWyJN3jhMZe\\n4KJMlQhKXXsI54CTFE0R8/Qfs5sNwAJ8CSm2eInEZTk4m5GiW9t8JD30k1aDxIFE\\nGLH2ChMYHiha2KBp/nZ1Di6AYTgRKO953ACGetnUfMSSgrnxm7cDfTXJ5DELwH5o\\nuj2n0mhInEog6tRxcfUplfW0FIGzAdpBuiL9PF8xIagOxt8ykax5kSWatPSVkxZz\\n7GC+p1VAB1DpgYephumCPRL/7x8DmAGXK7fuQOBa7wKBgQDyqefG8Ha45x+qCcBV\\nI87/hbLwW9PSnJRZ4BE3ld8wBnbgJEnGIwoYpysxOvbtWjvO4dJFqpL40t69FNus\\nomnXloyTkhI1+JXNWEOslStdoOE64veL0+Wanga/NzoKZxjlMBZwHKV3iwJV7I+T\\nVkWD96Knrb2r7PfH7E3U9zLagwKBgQC2aten25s2dX5Rnsi1xDhuePwFsynbq5e4\\nzH5TrQo05i0qMCeNgNGS9VDVYj0iBKBgEBCyI5jFjGdHK7L/5r0pcDyqyW1vJjBG\\ntBtcfQjXv+ng8KeUclIiHMW2nFn3ORffryg/4bqDS8g1nlm1uNPRpYcHo8S/8qE2\\nwKbjomj9FwKBgQCQ/X/lWAw30rESshzfQjQObN5LyzI3ZyMkyELBSaU/Vr10k3oZ\\nDxqbPFcMZUTg8MdHh5pR0edbEPPRWkMfVTOUgvmfuulyogMv3Isi9UYh/VxWCQML\\n4yIPTliNq/vb91nipubhOdyMHtzYZi4rRKLohPAE7ESmE0LBi6m9k64o7QKBgDKQ\\nTxLSRqXDz63kK5Jmv5Wvp3wU+4dOexHYbTPYhTnAi8hj7LLGgFER+sQLJRLm4WV/\\nToFyaIhpsL8Dl+xjExAHcmmMx+7FUSBoECWE6wySv8uAKZN2VNnry8ogcLecdcel\\nD60VbtOyD97887TxdJVqIpG1jXX/VTyODjSO8jclAoGBAJJ9L1A23GgKf/ALbLBv\\nTjB7fn42WJijC96rn8CFIsHMnCs5vVUJd9HEZZelcfj4R32CPvk6Hnws/YVKaNmC\\nJ6IX19RTFNhp399T6iBYoGAc3Cp2wzFxIFYRrtuPXb3fdP4RRUTfG2ihibPCo5de\\naNB4S3j3Fnqreput0N5HQbNF\\n-----END PRIVATE KEY-----\\n\", \"client_email\": \"env-matrix-workflow-sa@mrb-base-prj.iam.gserviceaccount.com\", \"client_id\": \"102547416053711505639\", \"auth_uri\": \"https://accounts.google.com/o/oauth2/auth\", \"token_uri\": \"https://oauth2.googleapis.com/token\", \"auth_provider_x509_cert_url\": \"https://www.googleapis.com/oauth2/v1/certs\", \"client_x509_cert_url\": \"https://www.googleapis.com/robot/v1/metadata/x509/env-matrix-workflow-sa%40mrb-base-prj.iam.gserviceaccount.com\" }"
          description = "Google Credentials created from gcloud cli."
          sensitive   = true
        }
      }
    }
  }
}

module "workspaces" {
  for_each = local.workspaces
  source   = "./modules/workspace"

  workspace_name    = "${local.workspace_prefix}-${each.key}"
  organization_name = "insight"
  working_directory = each.value.working_directory
  workspace_variables = [for var in each.value.workspace_variables :
    {
      key         = var.key
      value       = var.value
      category    = try(var.category, "env")
      description = var.description
      sensitive   = try(var.sensitive, false)
  }]
}


output "workspaces" {
  value = module.workspaces
}

output "workspace_ids" {
  value = [for w in module.workspaces : w.workspace_id]
}

output "workspace_names" {
  value = [for w in module.workspaces : w.workspace_name]
}

output "workspace_info" {
  value = [for w in module.workspaces : "Name: ${w.workspace_name}, ID: ${w.workspace_id}"]
}

output "flatten_workspace_info" {
  value = flatten([for w in module.workspaces : {
    workspace_id   = w.workspace_id
    workspace_name = w.workspace_name
  }])
}
