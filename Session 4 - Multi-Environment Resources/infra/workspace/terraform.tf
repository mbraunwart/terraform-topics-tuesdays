terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }  
  
  backend "azurerm" {
    # container_name       = "terraform"
    # sas_token            = "?sv=2020-08-04&se=2022-11-15T19%3A43%3A00Z&sr=c&sp=racwdl&sig=twpJ8pExuZG3XsvK795vldx1plsswZfczhQiaiaZ%2Fvc%3D"
    # key                  = "terraform_topics_01.tfstate"
    # storage_account_name = "mrbtfbackend"
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