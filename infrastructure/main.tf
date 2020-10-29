provider "azurerm" {
  version                     = "=2.20.0"
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

resource "azurerm_resource_group" "workshop" {
  name     = "workshop"
  location = "Central US"
}
