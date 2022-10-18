# resource "docker_image" "ubuntu" {
#   name = "vault:latest"
# }

locals {
  latest_tag = "${var.registry_address}/${var.image_name}:latest"
}

resource "docker_image" "node" {
  name = var.image_name
  build {
    path = "../_node_web_app/"
    tag  = [local.latest_tag]
    label = {
      author : "mrb"
    }
  }
}

resource "docker_registry_image" "registry" {
  name = local.latest_tag

  depends_on = [
    docker_image.node
  ]
}