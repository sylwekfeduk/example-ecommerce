terraform {
    backend "azurerm" {
        resource_group_name = "AzureResourceGroup"
        storage_account_name = "AzureCourseStorage"
        container_name = "tfstate"
        key = "prod.terraform.tfstate"
        access_key = "7fi8Q~IquX5mrwwF~Q4c.2i0sJiBMTNUs3rd3bBD"
    }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "AzureResourceGroup"
  location = "North Europe"
}