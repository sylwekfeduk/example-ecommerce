terraform {
    backend "azurerm" {
        resource_group_name = "AzureResourceGroup"
        storage_account_name = "AzureCourseStorage"
        container_name = "tfstate"
        key = "prod.terraform.tfstate"
    }
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "AzureResourceGroup"
  location = "North Europe"
}