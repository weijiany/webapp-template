provider "azurerm" {
  version         = "=2.33.0"
  client_id       = var.authentication.client_id
  subscription_id = var.authentication.subscription_id
  tenant_id       = var.authentication.tenant_id
  client_secret   = var.authentication.client_secret
  features {
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
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

resource "azurerm_container_registry" "acr" {
  name                = "workshopacrwjy"
  resource_group_name = azurerm_resource_group.workshop.name
  location            = local.location
  sku                 = "Basic"
  admin_enabled       = true
}

resource "azurerm_kubernetes_cluster" "aks" {
  dns_prefix          = "workshop"
  location            = local.location
  name                = "workshopakswjy"
  resource_group_name = azurerm_resource_group.workshop.name
  default_node_pool {
    name       = "pool1"
    vm_size    = "Standard_D2_v2"
    node_count = 1
  }

  service_principal {
    client_id     = var.authentication.client_id
    client_secret = var.authentication.client_secret
  }

  linux_profile {
    admin_username = "ubuntu"
    ssh_key {
      key_data = file("./ssh/id_rsa.pub")
    }
  }
  role_based_access_control {
    enabled = true
  }
}

resource "azurerm_key_vault" "key_vault" {
  location            = local.location
  name                = "key-vault-wjy"
  resource_group_name = azurerm_resource_group.workshop.name
  sku_name            = "standard"
  tenant_id           = var.authentication.tenant_id
  access_policy {
    object_id = var.authentication.object_id
    tenant_id = var.authentication.tenant_id

    secret_permissions = [
      "delete",
      "get",
      "list",
      "set"
    ]
  }
}

resource "azurerm_key_vault_access_policy" "azure_devops" {
  key_vault_id = azurerm_key_vault.key_vault.id
  object_id = "428f8a23-5c92-4e0e-9185-06a93f56d6fa"
  tenant_id = var.authentication.tenant_id
}

module "key_vault_secrets" {
  source = "./modules/key_vault_secret"
  key_vault_id = azurerm_key_vault.key_vault.id
  secrets = {
    DB-HOST = azurerm_sql_server.webapp-sql-server.fully_qualified_domain_name
    DB-USERNAME = azurerm_sql_server.webapp-sql-server.administrator_login
    DB-PASSWORD = azurerm_sql_server.webapp-sql-server.administrator_login_password
    DB-DATABASE = azurerm_sql_database.webapp-sql-db.name
  }
}

// ---------------------------------------------------------------------------
provider "kubernetes" {
  load_config_file       = "false"
  host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
  username               = azurerm_kubernetes_cluster.aks.kube_config.0.username
  password               = azurerm_kubernetes_cluster.aks.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)
}

resource "kubernetes_namespace" "dev" {
  metadata {
    name = "dev"
  }
}

resource "kubernetes_secret" "webapp" {
  metadata {
    name = "webapp"
  }

  data = {
    DB_HOST = azurerm_sql_server.webapp-sql-server.fully_qualified_domain_name
    DB_USERNAME = azurerm_sql_server.webapp-sql-server.administrator_login
    DB_PASSWORD = azurerm_sql_server.webapp-sql-server.administrator_login_password
    DB_DATABASE = azurerm_sql_database.webapp-sql-db.name
  }

  type = "Opaque"
}
