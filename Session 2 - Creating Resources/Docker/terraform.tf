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
    password = "goykSkA=7vVxfHXcKz8T3RovopPFdLVi"
    username = "mrbacr"
    address  = var.registry_address
  }
}