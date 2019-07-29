terraform {
  required_version = ">= 0.12.1"
}
provider "azurerm" {
  version = ">= 1.30.0"
  subscription_id = "2de839a0-37f9-4163-a32a-e1bdb8d6eb7e"
}

data "azurerm_client_config" "current" {}