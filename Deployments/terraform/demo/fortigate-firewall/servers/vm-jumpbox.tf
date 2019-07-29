module "jumpbox" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-basicwindowsvm?ref=20190725.1"
  #source = "./terraform-azurerm-basicwindowsvm"

  name                              = "jumpbox"
  resource_group_name               = "${var.envprefix}-MGMT-RDS-RG"
  admin_username                    = "azureadmin"
  secretPasswordName                = "server2016DefaultPassword"
  nic_subnetName                    = "${var.envprefix}-MGMT-PAZ"
  nic_vnetName                      = "${var.envprefix}-Core-NetMGMT-VNET"
  nic_resource_group_name           = "${var.envprefix}-Core-NetMGMT-RG"
  nic_enable_ip_forwarding          = false
  nic_enable_accelerated_networking = false
  nic_ip_configuration = {
    private_ip_address            = ""
    private_ip_address_allocation = "Dynamic"
  }
  vm_size = "Standard_D2_v3"
  storage_image_reference = {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  keyvault = {
    name                = "${var.envprefix}-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${var.envprefix}-Core-Keyvault-RG"), 0, 8)}"
    resource_group_name = "${var.envprefix}-Core-Keyvault-RG"
  }
}
