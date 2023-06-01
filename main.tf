terraform {
    backend "azurerm" {
        resource_group_name = "AzureResourceGroup"
        storage_account_name = "azurecoursestorage"
        container_name = "tfstate"
        key = "prod.terraform.tfstate"
        access_key = "BX2E7yfU1gJdcXmlgwp2+/ZwAnE+LU/goAWnWitV0vlxdfgIAtcNHxuRnwthhKHKGaDomp/KWqtQ+ASt3GNF/w=="
    }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "AzureResourceGroup"
  location = "North Europe"
}

resource "azurerm_app_service_plan" "example" {
  name                = "myAppServicePlan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku {
    tier = "Free"
    size = "F1"
  }
}

resource "azurerm_app_service" "example" {
  name                = "myWebApp"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.example.id
}