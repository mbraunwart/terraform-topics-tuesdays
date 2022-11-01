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