resource "google_cloud_run_service" "cr" {
  name     = "terraform_topics_nodejs"
  location = "us-central1"
  template {
    spec {
      containers {
        image = var.container_image_name
        # args = 
      }
    }
  }
}