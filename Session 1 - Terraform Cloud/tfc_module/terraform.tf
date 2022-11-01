terraform {
  required_providers {
    github = {
      source = "integrations/github"
    }
  }

  cloud {
    # organization = "insight"
    # workspaces {
    #   name = "mrb-terraform-topics-module"
    # }
  }
}

provider "github" {
}

module "repo" {
  source  = "app.terraform.io/insight/repository-management/github"
  version = "0.0.1"

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

  repository_environments = [{
    custom_branches    = false
    name               = "dev"
    protected_branches = false
    team_reviewers     = []
    user_reviewers     = []
    wait_timer         = 1
  }]
}