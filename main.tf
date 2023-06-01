provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "AzureResourceGroup"
  location = "North Europe"
}