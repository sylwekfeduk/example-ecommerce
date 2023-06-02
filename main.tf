terraform {
    backend "azurerm" {
        resource_group_name = "AzureResourceGroup2"
        storage_account_name = "azurecoursestorage"
        container_name = "tfstate"
        key = "prod.terraform.tfstate"
        access_key = "BX2E7yfU1gJdcXmlgwp2+/ZwAnE+LU/goAWnWitV0vlxdfgIAtcNHxuRnwthhKHKGaDomp/KWqtQ+ASt3GNF/w=="
    }

    required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.15.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azuread" {
  tenant_id = "19618cfd-7df8-403a-9774-2bf8ad068e3b"
}

locals {
  location  = "northeurope"
}

resource "azurerm_resource_group" "example" {
  name     = "AzureResourceGroup2"
  location = local.location
}

resource "azurerm_app_service_plan" "example" {
  name                = "myAzureCourseAppServicePlan"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_application_insights" "example" {
  name                = "myAzureCourseAppInsights"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name
  application_type    = "web"
}

resource "azurerm_app_service" "example" {
  name                = "myAzureCourseApp"
  location            = local.location
  resource_group_name = azurerm_resource_group.example.name
  app_service_plan_id = azurerm_app_service_plan.example.id

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY" = azurerm_application_insights.example.instrumentation_key,
    "ConnectionStrings:DefaultConnection" = "Server=tcp:${azurerm_sql_server.example.name},1433;Initial Catalog=${azurerm_sql_database.example.name};Persist Security Info=False;User ID=${azurerm_sql_server.example.administrator_login};Password=${azurerm_sql_server.example.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }

  connection_string {
    name  = "DBConnectionString"
    type  = "SQLAzure"
    value = "Server=tcp:${azurerm_sql_server.example.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_sql_database.example.name};Persist Security Info=False;User ID=${azurerm_sql_server.example.administrator_login};Password=${azurerm_sql_server.example.administrator_login_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  }
}

resource "azurerm_sql_server" "example" {
  name                         = "myazurecoursesqlserver"
  location                     = local.location
  resource_group_name          = azurerm_resource_group.example.name
  version                      = "12.0"
  administrator_login          = "qperioradmin"
  administrator_login_password = "Qperior29!AzureCourse"
}

resource "azurerm_sql_database" "example" {
  name                = "myAzureCourseDatabase"
  resource_group_name = azurerm_resource_group.example.name
  server_name         = azurerm_sql_server.example.name
  location            = local.location
  edition             = "Basic"
}

resource "azurerm_storage_account" "example" {
  name                     = "mycoursestorageaccount2"
  resource_group_name      = azurerm_resource_group.example.name
  location = local.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  account_kind = "StorageV2"
}

resource "azurerm_storage_container" "example" {
  name = "mycoursecontainer2"
  storage_account_name = azurerm_storage_account.example.name
  container_access_type = "private"
}

resource "azuread_application" "example" {
  display_name = "myAzureCourseApp"
  homepage     = "https://myAzureCourseApp.azurewebsites.net"
  identifier_uris = [
    "https://myAzureCourseApp.azurewebsites.net"
  ]
}

resource "azuread_service_principal" "example" {
  application_id = azuread_application.example.application_id
}