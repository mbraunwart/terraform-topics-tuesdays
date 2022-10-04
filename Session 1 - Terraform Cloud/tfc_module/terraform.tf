terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }

  cloud {
    # organization = "insight"
    # workspaces {
    #   name = "mrb-terraform-topics"
    # }
  }
}

provider "github" {
}

module "repo" {

  application_name       = "test-repo"
  repository_prefix      = "terraform"
  repository_description = "Testing Repository Management Module."
  cloud_provider         = "azure"

  repository_features = {
    allow_merge_commits    = false
    allow_rebase_merges    = false
    allow_squash_merges    = true
    delete_branch_on_merge = true
    enable_issues          = true
    enable_projects        = false
    enable_wiki            = true
    visibility             = "internal"
    vulnerability_alerts   = true
  }
}