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
