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