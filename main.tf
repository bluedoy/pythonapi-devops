terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "tf_rg" {
  name     = "RG-NEU-WB-DEV"
  location = "North Europe"
  tags = {
    enviroment = "dev"
    source     = "Terraform"
  }
}

resource "azurerm_container_group" "tf_app_container" {
  name                = "viajump-api"
  location            = azurerm_resource_group.tf_rg.location
  resource_group_name = azurerm_resource_group.tf_rg.name

  ip_address_type = "Public"
  dns_name_label  = "viajump"
  os_type         = "Linux"

  container {
    name   = "viajump-api"
    image  = "bluedoy/viajump-api"
    cpu    = "1"
    memory = "1"
    ports {
      port     = 80
      protocol = "TCP"
    }
  }

  depends_on = [
    azurerm_resource_group.tf_rg
  ]
}