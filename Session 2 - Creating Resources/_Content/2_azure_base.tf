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

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-acr"
  location = "eastus"
}

resource "azurerm_container_registry" "acr" {
  name                = "${var.prefix}acr"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  sku           = "Basic"
  admin_enabled = true
}

# variables tf

variable "prefix" {
  type        = string
  default     = "mrb"
  description = "Prefix applied to resource names"
}

# outputs

output "acr_login_server" {
  value       = azurerm_container_registry.acr.login_server
  description = "Address of login server."
}

output "acr_name" {
  value       = azurerm_container_registry.acr.name
  description = "Name of Azure Container Registry."
}

output "acr_password" {
  value       = azurerm_container_registry.acr.admin_password
  description = "Admin password."
  sensitive   = true
}

output "acr_username" {
  value       = azurerm_container_registry.acr.admin_username
  description = "Admin username."
}

output "rg_name" {
  value       = azurerm_resource_group.rg.name
  description = "ACR Resource Group Name."
}

output "rg_location" {
  value       = azurerm_resource_group.rg.location
  description = "ACR Resource Group Location."
}
 