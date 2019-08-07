terraform {
  required_version = ">= 0.12.1"
}
provider "azurerm" {
  version = ">= 1.32.0"
  # subscription_id = "2de839a0-37f9-4163-a32a-e1bdb8d6eb7e"
}

data "azurerm_client_config" "current" {}

module "rdsvms" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-storage-space-direct?ref=20190802.1"
  #source = "./terraform-azurerm-storage-space-direct"

  vmCount                   = "2"
  vmDiskCount               = "3"
  ad_domain_name            = "mgmt.demo.gc.ca.local"
  name_prefix               = "DAZF"
  resourceGroupName         = "${var.envprefix}-MGMT-RDS-RG"
  admin_username            = "azureadmin"
  secretPasswordName        = "server2016DefaultPassword"
  subnetName                = "${var.envprefix}-MGMT-APP"
  vnetName                  = "${var.envprefix}-Core-NetMGMT-VNET"
  vnetResourceGroupName     = "${var.envprefix}-Core-NetMGMT-RG"
  dnsServers                = ["100.96.122.4", "100.96.122.5"]
  vm_size                   = "Standard_D2s_v3"
  keyVaultName              = "${var.envprefix}-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${var.envprefix}-Core-Keyvault-RG"), 0, 8)}"
  keyVaultResourceGroupName = "${var.envprefix}-Core-Keyvault-RG"
  tags                      = "${var.tags}"
}
