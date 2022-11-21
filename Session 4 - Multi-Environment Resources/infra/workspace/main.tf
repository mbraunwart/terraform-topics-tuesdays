locals {
  enable_failover = terraform.workspace != "dev" ? true : false
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
  count = local.enable_failover ? 1 : 0

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
  count = local.enable_failover ? 1 : 0

  name      = "${var.prefix}-failover"
  server_id = azurerm_mssql_server.primary.id
  databases = [
    azurerm_mssql_database.db.id
  ]

  partner_server {
    id = azurerm_mssql_server.secondary[0].id
  }

  read_write_endpoint_failover_policy {
    mode          = "Automatic"
    grace_minutes = 80
  }
}
