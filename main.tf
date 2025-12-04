terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.54.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}


resource "random_integer" "ri" {
  min = 10000
  max = 99999
}


provider "azurerm" {
  # Configuration options
  subscription_id = "b1ed17ca-7e70-4756-a3c1-b85c220a101d"
  features {}
}

resource "azurerm_resource_group" "arg" {
  name     = "${var.resource_group_name}${random_integer.ri.result}"
  location = var.location
}

resource "azurerm_service_plan" "asp" {
  name                = "${var.azurerm_service_plan_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_resource_group.arg.location
  os_type             = "Linux"
  sku_name            = "F1"
}

resource "azurerm_mssql_server" "sqlserver" {
  name                         = "${var.azurerm_mssql_server_name}${random_integer.ri.result}"
  resource_group_name          = azurerm_resource_group.arg.name
  location                     = azurerm_resource_group.arg.location
  version                      = "12.0"
  administrator_login          = var.admin_login
  administrator_login_password = var.admin_password
}


resource "azurerm_mssql_firewall_rule" "frw" {
  name             = var.azurerm_mssql_firewall_rule_name
  server_id        = azurerm_mssql_server.sqlserver.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_database" "sqldb" {
  name                 = "${var.azurerm_mssql_database_name}${random_integer.ri.result}"
  server_id            = azurerm_mssql_server.sqlserver.id
  collation            = "SQL_Latin1_General_CP1_CI_AS"
  license_type         = "LicenseIncluded"
  sku_name             = "S0"
  storage_account_type = "Local"

}


resource "azurerm_linux_web_app" "azlwa" {
  name                = "${var.azurerm_linux_web_app_name}-${random_integer.ri.result}"
  resource_group_name = azurerm_resource_group.arg.name
  location            = azurerm_service_plan.asp.location
  service_plan_id     = azurerm_service_plan.asp.id

  site_config {
    application_stack {
      dotnet_version = var.dotnet_version
    }
    always_on = false

  }

  connection_string {
    name  = "DefaultConnection"
    type  = "SQLAzure"
    value = "Data Source=${azurerm_mssql_server.sqlserver.fully_qualified_domain_name};Initial Catalog=${azurerm_mssql_database.sqldb.name};User ID=${azurerm_mssql_server.sqlserver.administrator_login};Password=${azurerm_mssql_server.sqlserver.administrator_login_password};Trusted_Connection=False; MultipleActiveResultSets=True;"
  }
}

resource "azurerm_app_service_source_control" "github" {
  app_id                 = azurerm_linux_web_app.azlwa.id
  repo_url               = var.azurerm_app_service_source_control_repo_url
  branch                 = "main"
  use_manual_integration = true
}
