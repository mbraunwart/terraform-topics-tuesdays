terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  cloud {

  }

}

provider "azurerm" {
  features {}
}

# provider "azurerm" {
#   alias = "west"
#   region = "westus"
#   features {}
# }
