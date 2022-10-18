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

output "ssh_key_id" {
  value       = tfe_workspace.workspace.ssh_key_id
  description = "SSH Key ID."
}

output "workspace_variables" {
  value = [for wv in tfe_variable.var : wv.key ]
}