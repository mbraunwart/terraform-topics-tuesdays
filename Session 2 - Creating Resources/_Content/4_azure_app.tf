# terraform tf

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.0"
    }
  }

  cloud {}
}

provider "azurerm" {
  features {}
}

# main tf

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.prefix}-asp"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  os_type             = "Linux"
  sku_name            = "B1"
}

resource "azurerm_linux_web_app" "web" {
  name                = "${var.prefix}-node-web"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  service_plan_id     = azurerm_service_plan.asp.id


  site_config {
    application_stack {
      docker_image     = "${var.registry_address}/${var.image_name}"
      docker_image_tag = var.image_tag
    }
  }

  app_settings = {
    "DOCKER_REGISTRY_SERVER_PASSWORD" = var.registry_password
    "DOCKER_REGISTRY_SERVER_URL"      = var.registry_address
    "DOCKER_REGISTRY_SERVER_USERNAME" = var.registry_username
    "WEBSITES_PORT"                   = "3000"
  }
}

# variables tf

variable "prefix" {
  type        = string
  default     = "mrb"
  description = "Prefix applied to resource names"
}

variable "resource_group_name" {
  type        = string
  description = "(Required) AzureRM Resource Group Name"
  default     = "mrb-acr"
}

variable "registry_address" {
  type        = string
  description = "(Required) Address to container registry, used for authentication."
  default     = "mrbacr.azurecr.io"
}

variable "registry_username" {
  type        = string
  description = "(Required) Username to access container registry, used for authentication."
  default     = "mrbacr"
}

variable "registry_password" {
  type        = string
  description = "(Required) Password to access container registry, used for authentication."
  default     = "tjAYFWNazcEjsup0AFLTx9QeW6q8jQ/x"
}

variable "image_name" {
  type        = string
  description = "(Required) image name"
  default     = "ttnodeweb"
}

variable "image_tag" {
  type        = string
  description = "(Required) tag of image"
  default     = "latest"
}

# outputs tf

output "app_service_address" {
  value       = "https://${azurerm_linux_web_app.web.default_hostname}"
  description = "HTTPS address of linx web app."
}
