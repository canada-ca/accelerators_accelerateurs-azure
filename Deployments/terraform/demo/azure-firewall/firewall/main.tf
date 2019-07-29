terraform {
  required_version = ">= 0.12.1"
}

provider "azurerm" {
  version         = ">= 1.32.0"
  # subscription_id = "2de839a0-37f9-4163-a32a-e1bdb8d6eb7e"
}

module "fortigateap" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-firewall?ref=20190726.1"
  #source = "./terraform-azurerm-firewall"

  location                = "canadacentral"
  fwprefix                = "${var.envprefix}-FW"
  vnet_name               = "${var.envprefix}-Core-NetCore-VNET"
  vnet_resourcegroup_name = "${var.envprefix}-Core-NetCore-RG"
}