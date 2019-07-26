data "template_file" "cloudconfig" {
  template = "${file("dockerweb-init.sh")}"
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content = "${data.template_file.cloudconfig.rendered}"
  }
}
module "dockerweb" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-basiclinuxvm?ref=20190725.1"
  #source = "./terraform-azurerm-basiclinuxvm"

  name                              = "dockerweb"
  resource_group_name               = "${var.envprefix}-CN-Docker"
  admin_username                    = "azureadmin"
  secretPasswordName                = "linuxDefaultPassword"
  custom_data                       = "${data.template_cloudinit_config.config.rendered}"
  nic_subnetName                    = "${var.envprefix}-CN-Docker"
  nic_vnetName                      = "${var.envprefix}-CN-Net-VNET"
  nic_resource_group_name           = "${var.envprefix}-CN-Net-RG"
  nic_enable_ip_forwarding          = false
  nic_enable_accelerated_networking = false
  nic_ip_configuration = {
    private_ip_address            = ""
    private_ip_address_allocation = "Dynamic"
  }
  vm_size = "Standard_B1s"
  storage_image_reference = {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  storage_os_disk = {
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = "32"
  }

  keyvault = {
    name                = "${var.envprefix}-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${var.envprefix}-Core-Keyvault-RG"), 0, 8)}"
    resource_group_name = "${var.envprefix}-Core-Keyvault-RG"
  }
}