terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }

  cloud {
    # organization = "insight"
    # workspaces {
    #   name = "mrb-terraform-topics"
    # }
  }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "mrb-terraform-topics"
  location = "eastus"
}
