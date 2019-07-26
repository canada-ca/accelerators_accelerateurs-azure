terraform {
  required_version = ">= 0.12.1"
}

provider "azurerm" {
  version         = "= 1.31.0"
  subscription_id = "2de839a0-37f9-4163-a32a-e1bdb8d6eb7e"
}

data "azurerm_client_config" "current" {}

variable "envprefix" {
  description = "Prefix for the environment"
  default     = "Demo"
}

module "fortigateap" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-fortigateap?ref=20190725.1"
  #source = "./terraform-azurerm-fortigateap"

  location  = "canadacentral"
  envprefix = "${var.envprefix}"
  
  keyvault = {
    name                = "${var.envprefix}-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${var.envprefix}-Core-Keyvault-RG"),0,8)}"
    resource_group_name = "${var.envprefix}-Core-Keyvault-RG"
  }
  
  firewall = {
    fwprefix = "${var.envprefix}-FW"
    vm_size     = "Standard_F4"
    adminName = "fwadmin"
    secretPasswordName = "fwpassword"
    vnet_name = "${var.envprefix}-Core-NetCore-VNET"
    fortigate_resourcegroup_name = "${var.envprefix}-Core-FWCore-RG"
    keyvault_resourcegroup_name = "${var.envprefix}-Core-Keyvault-RG"
    vnet_resourcegroup_name = "${var.envprefix}-Core-NetCore-RG"
    fwa_custom_data = "fwconfig/coreA-lic.conf"
    fwb_custom_data = "fwconfig/coreB-lic.conf"
    # Associated to Nic1
    outside_subnet_name = "${var.envprefix}-Outside"
    # Associated to Nic2
    inside_subnet_name = "${var.envprefix}-CoreToSpokes"
    # Associated to Nic3
    mgmt_subnet_name = "${var.envprefix}-Management"
    # Associated to Nic4
    ha_subnet_name = "${var.envprefix}-HASync"
    # Firewall A NIC Private IPs
    fwa_nic1_private_ip_address = "100.96.112.4"
    fwa_nic2_private_ip_address = "100.96.116.5"
    fwa_nic3_private_ip_address = "100.96.116.36"
    fwa_nic4_private_ip_address = "100.96.116.68"
    # Firewall B NIC Private IPs
    fwb_nic1_private_ip_address = "100.96.112.5"
    fwb_nic2_private_ip_address = "100.96.116.6"
    fwb_nic3_private_ip_address = "100.96.116.37"
    fwb_nic4_private_ip_address = "100.96.116.69"
    storage_image_reference = {
      publisher = "fortinet"
      offer     = "fortinet_fortigate-vm_v5"
      sku       = "fortinet_fg-vm"
      version   = "latest"
    }
    plan = {
      name      = "fortinet_fg-vm"
      publisher = "fortinet"
      product   = "fortinet_fortigate-vm_v5"
    }
  }
}