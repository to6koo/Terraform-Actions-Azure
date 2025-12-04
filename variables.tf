variable "resource_group_name" {
  description = "The name of the resource group"
  type        = string
}

variable "location" {
  description = "The Azure region to deploy resources"
  type        = string
  default     = "France Central"
}

variable "admin_login" {
  description = "The administrator login for the SQL server"
  type        = string
  default     = "4dm1n157r470r"
}

variable "admin_password" {
  description = "The administrator password for the SQL server"
  type        = string
  default     = "4-v3ry-53cr37-p455w0rd"
}

variable "dotnet_version" {
  description = "The .NET version for the web app"
  type        = string
  default     = "6.0"
}


variable "azurerm_service_plan_name" {
  description = "The name of the Azure App Service Plan"
  type        = string
  default     = "task-board-asp"
}

variable "azurerm_mssql_server_name" {
  description = "The name of the Azure SQL Server"
  type        = string
  default     = "sqlserver1"
}

variable "azurerm_mssql_firewall_rule_name" {
  description = "The name of the Azure SQL Server Firewall Rule"
  type        = string
  default     = "FirewallRule1"
}

variable "azurerm_mssql_database_name" {
  description = "The name of the Azure SQL Database"
  type        = string
  default     = "mysqldb1"
}

variable "azurerm_linux_web_app_name" {
  description = "The name of the Azure Linux Web App"
  type        = string
  default     = "webapp-task-board"
}

variable "azurerm_app_service_source_control_repo_url" {
  description = "The URL of the source control repository for the Azure App Service"
  type        = string
  default     = "https://github.com/to6koo/TaskBoardAppTerra"
}