terraform {
  required_version = ">= 0.12.1"
}
provider "azurerm" {
  version = ">= 1.32.0"
  # subscription_id = "2de839a0-37f9-4163-a32a-e1bdb8d6eb7e"
}

data "azurerm_client_config" "current" {}

module "rdsvms" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-remote-desktop-service?ref=20190801.1"
  #source = "./terraform-azurerm-remote-desktop-service"

  ad_domain_name            = "mgmt.demo.gc.ca.local"
  rds_prefix                = "DAZF"
  resourceGroupName         = "${var.envprefix}-MGMT-RDS-RG"
  admin_username            = "azureadmin"
  secretPasswordName        = "server2016DefaultPassword"
  pazSubnetName             = "${var.envprefix}-MGMT-PAZ"
  appSubnetName             = "${var.envprefix}-MGMT-APP"
  vnetName                  = "${var.envprefix}-Core-NetMGMT-VNET"
  vnetResourceGroupName     = "${var.envprefix}-Core-NetMGMT-RG"
  externalfqdn              = "rds.pws1.pspc-spac.ca"
  dnsServers                = ["100.96.122.4", "100.96.122.5"]
  rdsGWIPAddress            = "100.96.120.10"
  rdsBRKIPAddress           = "100.96.122.10"
  rdsSSHIPAddresses         = ["100.96.122.11", "100.96.122.12"]
  broker_gateway_vm_size    = "Standard_D2s_v3"
  session_hosts_vm_size     = "Standard_D4s_v3"
  keyVaultName              = "${var.envprefix}-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${var.envprefix}-Core-Keyvault-RG"), 0, 8)}"
  keyVaultResourceGroupName = "${var.envprefix}-Core-Keyvault-RG"
}
