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

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "West Europe"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestoraccount1209"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  account_kind             = "StorageV2"
  access_tier              = "Hot"

  tags = {
    environment = "development"
  }
}

resource "azurerm_storage_container" "example" {
  name                  = "tfstate"
  storage_account_name   = azurerm_storage_account.example.name
  container_access_type = "private"
}

