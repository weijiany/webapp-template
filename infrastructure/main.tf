provider "azurerm" {
  version                     = "=2.33.0"
  client_id                   = var.authentication.client_id
  subscription_id             = var.authentication.subscription_id
  tenant_id                   = var.authentication.tenant_id
  client_certificate_password = var.authentication.client_certificate_password
  features {}
}

terraform {
  backend "azurerm" {
    resource_group_name  = "terraform_backend"
    storage_account_name = "workshopbackend"
    container_name       = "workshop"
    key                  = "workshop.tfstate"
  }
}

locals {
  location = "Central US"
}

resource "azurerm_resource_group" "workshop" {
  name     = "workshop"
  location = local.location
}

resource "azurerm_sql_server" "webapp-sql-server" {
  administrator_login          = var.sql_server.username
  administrator_login_password = var.sql_server.password
  location                     = local.location
  name                         = "webapp-sql-server"
  resource_group_name          = azurerm_resource_group.workshop.name
  version                      = "12.0"
}

resource "azurerm_sql_database" "webapp-sql-db" {
  location                         = local.location
  name                             = "webapp-sql-db"
  resource_group_name              = azurerm_resource_group.workshop.name
  server_name                      = azurerm_sql_server.webapp-sql-server.name
  requested_service_objective_name = "Basic"
  edition                          = "Basic"
}
