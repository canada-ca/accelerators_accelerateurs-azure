resource azurerm_network_security_group NSG {
  name                = "${var.name}-NSG"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.devvm-RG.name}"
  security_rule {
    name                       = "AllowAllInbound"
    description                = "Allow all in"
    access                     = "Allow"
    priority                   = "100"
    protocol                   = "*"
    direction                  = "Inbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "AllowAllOutbound"
    description                = "Allow all out"
    access                     = "Allow"
    priority                   = "105"
    protocol                   = "*"
    direction                  = "Outbound"
    source_port_range          = "*"
    source_address_prefix      = "*"
    destination_port_range     = "*"
    destination_address_prefix = "*"
  }
  tags = "${var.tags}"
}
resource azurerm_public_ip PubIP {
  name                = "${var.name}-Nic1-PubIP"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.devvm-RG.name}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}
resource azurerm_network_interface NIC {
  name                          = "${var.name}-Nic1"
  location                      = "${var.location}"
  resource_group_name           = "${azurerm_resource_group.devvm-RG.name}"
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${azurerm_subnet.devvm-subnet.id}"
    private_ip_address_allocation = "Dynamic"
    primary                       = true
    public_ip_address_id          = "${azurerm_public_ip.PubIP.id}"
  }
  tags = "${var.tags}"
}

resource azurerm_virtual_machine VM {
  name                             = "${var.name}"
  location                         = "${var.location}"
  resource_group_name              = "${azurerm_resource_group.devvm-RG.name}"
  vm_size                          = "${var.vm_size}"
  network_interface_ids            = ["${azurerm_network_interface.NIC.id}"]
  primary_network_interface_id     = "${azurerm_network_interface.NIC.id}"
  delete_data_disks_on_termination = "true"
  delete_os_disk_on_termination    = "true"
  os_profile {
    computer_name  = "${var.name}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
    custom_data    = "${file(var.custom_data)}"
  }
  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }
  os_profile_windows_config {
    provision_vm_agent = true
  }
  storage_os_disk {
    name          = "${var.name}-OsDisk_1"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }
  tags = "${var.tags}"
}

resource "azurerm_virtual_machine_extension" "CustomScriptExtension" {

  count                = "${var.custom_data == "" ? 0 : 1}"
  name                 = "CustomScriptExtension"
  location             = "${var.location}"
  resource_group_name  = "${azurerm_resource_group.devvm-RG.name}"
  virtual_machine_name = "${azurerm_virtual_machine.VM.name}"
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
        {   
        "commandToExecute": "powershell -command copy-item \"c:\\AzureData\\CustomData.bin\" \"c:\\AzureData\\CustomData.ps1\";\"c:\\AzureData\\CustomData.ps1 -rdpPort ${var.rdpPort}\""
        }
SETTINGS

  tags = "${var.tags}"
}
