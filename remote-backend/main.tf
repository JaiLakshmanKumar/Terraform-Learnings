# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.1.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = "05f2fe32-26a2-4fb0-921c-9aef6f3da248"
}

resource "azurerm_resource_group" "rg" {
  name     = "test-rg-using-remote-backend-concept"
  location = "westus2"
}

