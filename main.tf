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