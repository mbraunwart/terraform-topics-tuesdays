terraform {
  required_providers {
    tfe = {
      version = "~> 0.37.0"
    }
  }

  cloud {}
}

provider "tfe" {}