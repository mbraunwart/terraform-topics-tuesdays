# terraform tf

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~>2.0"
    }
  }
}

provider "docker" {
  registry_auth {
    password = "tjAYFWNazcEjsup0AFLTx9QeW6q8jQ/x"
    username = "mrbacr"
    address  = var.registry_address
  }
}

# main tf

## pull image example
resource "docker_image" "ubuntu" {
  name = "vault:latest"
}

## build resources

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

# variables tf

variable "registry_address" {
  type        = string
  description = "(Required) Address to container registry, used for authentication."
  default     = "mrbacr.azurecr.io"
}

variable "image_name" {
  type        = string
  description = "(Required) image name"
  default     = "ttnodeweb"
}

# outputs tf

output "docker_image_location" {
  value = docker_registry_image.registry.name
}

output "docker_image" {
  value = docker_image.node.id
}
