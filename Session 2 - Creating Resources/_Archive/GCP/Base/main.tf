locals {
  enabled_apis = {
    "run.googleapis.com"              = {}
    "artifactregistry.googleapis.com" = {}
    # "container.googleapis.com"         = {}
    "containerregistry.googleapis.com" = {}
    "sourcerepo.googleapis.com"        = {}
  }

  location = "us-central1"
}

data "google_client_openid_userinfo" "client" {

}

data "google_project" "prj" {
  project_id = var.google_project_id
}

resource "google_project_service" "apis" {
  for_each = local.enabled_apis
  project  = data.google_project.prj.id
  service  = each.key
}

resource "google_artifact_registry_repository" "arr" {
  location      = local.location
  repository_id = "mrb-terraform-topics"
  description   = "Terraform Topics Tuesday GCP Registry"
  format        = "DOCKER"
  project       = data.google_project.prj.project_id
}

output "registry_id" {
  value = google_artifact_registry_repository.arr.id
}

output "registry_repo_id" {
  value = google_artifact_registry_repository.arr.repository_id
}

output "name" {
  value = google_artifact_registry_repository.arr
}