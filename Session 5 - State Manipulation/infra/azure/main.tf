locals {
  location = "CentralUS"

  storage_accounts = {
    mrbtest1 = {
      account_kind             = "Storage"
      account_tier             = "Standard"
      account_replication_type = "LRS"
    },
    mrbtest2 = {
      account_kind             = "Storage"
      account_tier             = "Standard"
      account_replication_type = "LRS"
    }
  }

  app_plans = {
    asp1 = {
      name     = "ASP-terraformtopicsnov-8d06"
      os_type  = "Linux"
      sku_name = "Y1"
    },
    asp2 = {
      name     = "ASP-terraformtopicsnov-bd6e"
      os_type  = "Windows"
      sku_name = "Y1"
    }
  }

  app_insights = {
    appin1 = {
      name         = "mrb-function-app-1"
      workspace_id = "/subscriptions/1c6b2cdf-74c6-448e-b9c2-79db4106600b/resourceGroups/DefaultResourceGroup-CUS/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-1c6b2cdf-74c6-448e-b9c2-79db4106600b-CUS"
    },
    appin2 = {
      name         = "mrb-function-app-2"
      workspace_id = "/subscriptions/1c6b2cdf-74c6-448e-b9c2-79db4106600b/resourceGroups/DefaultResourceGroup-CUS/providers/Microsoft.OperationalInsights/workspaces/DefaultWorkspace-1c6b2cdf-74c6-448e-b9c2-79db4106600b-CUS"
    }
  }
}

resource "azurerm_resource_group" "rg" {
  name     = "terraform-topics-nov"
  location = "eastus"
}

resource "azurerm_storage_account" "fx_sa" {
  for_each = local.storage_accounts

  name                = each.key
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  # location            = azurerm_resource_group.rg.location

  account_kind             = each.value.account_kind
  account_tier             = each.value.account_tier
  account_replication_type = each.value.account_replication_type
}

resource "azurerm_service_plan" "fx_asp" {
  for_each = local.app_plans

  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location

  os_type  = each.value.os_type
  sku_name = each.value.sku_name
}

resource "azurerm_linux_function_app" "fapp1" {
  name                = "mrb-function-app-1"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  service_plan_id            = azurerm_service_plan.fx_asp["asp1"].id
  storage_account_name       = azurerm_storage_account.fx_sa["mrbtest1"].name
  storage_account_access_key = azurerm_storage_account.fx_sa["mrbtest1"].primary_access_key

  site_config {
    application_insights_connection_string = azurerm_application_insights.appin["appin1"].connection_string
    application_insights_key               = azurerm_application_insights.appin["appin1"].instrumentation_key

    application_stack {
      dotnet_version              = "6.0"
      use_dotnet_isolated_runtime = false
    }

    cors {
      allowed_origins     = ["https://portal.azure.com"]
      support_credentials = false
    }
  }
}

resource "azurerm_windows_function_app" "fapp2" {
  name                = "mrb-function-app-2"
  location            = local.location
  resource_group_name = azurerm_resource_group.rg.name

  service_plan_id            = azurerm_service_plan.fx_asp["asp2"].id
  storage_account_name       = azurerm_storage_account.fx_sa["mrbtest2"].name
  storage_account_access_key = azurerm_storage_account.fx_sa["mrbtest2"].primary_access_key

  site_config {
    application_insights_connection_string = azurerm_application_insights.appin["appin2"].connection_string
    application_insights_key               = azurerm_application_insights.appin["appin2"].instrumentation_key

    cors {
      allowed_origins     = ["https://portal.azure.com"]
      support_credentials = false
    }
  }
}

resource "azurerm_application_insights" "appin" {
  for_each = local.app_insights

  name                = each.value.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = local.location
  application_type    = "web"

  workspace_id = each.value.workspace_id
}

moved {
  from = azurerm_application_insights.appin1
  to   = azurerm_application_insights.appin["appin1"]
}

moved {
  from = azurerm_application_insights.appin2
  to   = azurerm_application_insights.appin["appin2"]
}
