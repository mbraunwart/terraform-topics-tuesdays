locals {

  non_prod = ["dev", "test"]
  prod = ["stage", "prod"]

  scope = contains(local.non_prod, var.environment) ? "non_prod" : (contains(local.prod, var.environment) ? true : false) ? "prod" : "non_approved_environment"

  failover = {
    non_prod = {
      enable = false
    }
    prod = {
      enable = true
      name = "p_server"
    }
  }

  env_failovers = { 
    for k, v in local.failover: k => v 
    if k == local.scope && v.enable
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}-terraform-topics"
  location = "eastus"
}

resource "azurerm_mssql_server" "primary" {
  name                         = "${var.prefix}-primary"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "terraformtopics"
  administrator_login_password = "sUp3rEncryp7ed!"
}

resource "azurerm_mssql_server" "secondary" {
  for_each = local.env_failovers

  name                         = "${var.prefix}-secondary"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = azurerm_resource_group.rg.location
  version                      = "12.0"
  administrator_login          = "terraformtopics"
  administrator_login_password = "sUp3rEncryp7ed!"
}

resource "azurerm_mssql_database" "db" {
  name        = "${var.prefix}topicsdb"
  server_id   = azurerm_mssql_server.primary.id
  sku_name    = "S1"
  max_size_gb = "200"
}

resource "azurerm_mssql_failover_group" "fo" {
  for_each = local.env_failovers

  name      = "${var.prefix}-failover-${each.value.name}"
  server_id = azurerm_mssql_server.primary.id
  databases = [
    azurerm_mssql_database.db.id
  ]

  partner_server {
    id = azurerm_mssql_server.secondary[local.scope].id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 80
  }
}
