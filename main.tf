terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.99.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "azurerm" {
  features {}
}
# -----------------------------
# Network (VNet + Subnets)
# -----------------------------
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group
}

resource "azurerm_subnet" "web" {
  name                 = "web-subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "app" {
  name                 = "app-subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_subnet" "db" {
  name                 = "db-subnet"
  resource_group_name  = var.resource_group
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.3.0/24"]
}

# -----------------------------
# Web Tier
# -----------------------------
resource "azurerm_app_service_plan" "web_plan" {
  name                = "${var.web_app_name}-plan"
  location            = var.location
  resource_group_name = var.resource_group
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_web_app" "web_app" {
  name                = var.web_app_name
  location            = var.location
  resource_group_name = var.resource_group
  app_service_plan_id = azurerm_app_service_plan.web_plan.id
}

# -----------------------------
# App Tier
# -----------------------------
resource "azurerm_app_service_plan" "app_plan" {
  name                = "${var.app_service_name}-plan"
  location            = var.location
  resource_group_name = var.resource_group
  sku {
    tier = "Standard"
    size = "S1"
  }
}

resource "azurerm_web_app" "app_service" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group
  app_service_plan_id = azurerm_app_service_plan.app_plan.id
}

# -----------------------------
# DB Tier
# -----------------------------
resource "azurerm_sql_server" "db_server" {
  name                         = var.sql_server_name
  resource_group_name           = var.resource_group
  location                      = var.location
  administrator_login           = var.sql_admin_user
  administrator_login_password  = var.sql_admin_password
}

resource "azurerm_sql_database" "db" {
  name                = var.sql_db_name
  resource_group_name = var.resource_group
  location            = var.location
  server_name         = azurerm_sql_server.db_server.name
  sku_name            = "S0"
}
