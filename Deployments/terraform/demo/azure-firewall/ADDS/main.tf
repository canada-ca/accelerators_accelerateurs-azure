terraform {
  required_version = ">= 0.12.1"
}
provider "azurerm" {
  version = ">= 1.32.0"
  # subscription_id = "2de839a0-37f9-4163-a32a-e1bdb8d6eb7e"
}

data "azurerm_client_config" "current" {}

module "addsvms" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-active-directory?ref=20190801.1"

  ad_domain_name        = "mgmt.demo.gc.ca.local"
  reverse_Zone_Object   = "2.250.10"
  ad_prefix             = "adds"
  resourceGroupName     = "${var.envprefix}-MGMT-ADDS-RG"
  admin_username        = "azureadmin"
  secretPasswordName    = "server2016DefaultPassword"
  subnetName            = "${var.envprefix}-MGMT-APP"
  vnetName              = "${var.envprefix}-Core-NetMGMT-VNET"
  vnetResourceGroupName = "${var.envprefix}-Core-NetMGMT-RG"
  rootDC1IPAddress      = "100.96.122.4"
  rootDC2IPAddress      = "100.96.122.5"
  vm_size               = "Standard_D2_v3"

  keyVaultName              = "${var.envprefix}-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${var.envprefix}-Core-Keyvault-RG"), 0, 8)}"
  keyVaultResourceGroupName = "${var.envprefix}-Core-Keyvault-RG"
}