resource azurerm_availability_set demo-core-fwcore-rg__pwptfwcore-availabilityset {
  name                         = "PwPTFWCore-AvailabilitySet"
  location                     = "${var.location}"
  resource_group_name          = "${var.rgname.fortigate}"
  platform_fault_domain_count  = "2"
  platform_update_domain_count = "2"
  managed                      = "true"
  tags                         = "${var.tags}"
}

resource azurerm_network_security_group demo-core-fwcore-rg__PwPTFWCore-2hwmajahfzosu-NSG {
  name                = "PwPTFWCore-2hwmajahfzosu-NSG"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
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


resource azurerm_network_interface demo-core-fwcore-rg__PwPTFWCore-A-Nic1 {
  name                          = "PwPTFWCore-A-Nic1"
  location                      = "${var.location}"
  resource_group_name           = "${var.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.demo-core-fwcore-rg__PwPTFWCore-2hwmajahfzosu-NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Demo-Outside.id}"
    private_ip_address            = "100.96.112.4"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = "${azurerm_public_ip.demo-core-fwcore-rg__PwPTFWCore-A-EXT-PubIP.id}"
    primary                       = true
  }
}

resource azurerm_network_interface demo-core-fwcore-rg__PwPTFWCore-A-Nic2 {
  name                          = "PwPTFWCore-A-Nic2"
  location                      = "${var.location}"
  resource_group_name           = "${var.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.demo-core-fwcore-rg__PwPTFWCore-2hwmajahfzosu-NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Demo-CoreToSpokes.id}"
    private_ip_address            = "100.96.116.5"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface demo-core-fwcore-rg__PwPTFWCore-A-Nic3 {
  name                          = "PwPTFWCore-A-Nic3"
  location                      = "${var.location}"
  resource_group_name           = "${var.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.demo-core-fwcore-rg__PwPTFWCore-2hwmajahfzosu-NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Demo-HASync.id}"
    private_ip_address            = "100.96.116.36"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface demo-core-fwcore-rg__PwPTFWCore-A-Nic4 {
  name                          = "PwPTFWCore-A-Nic4"
  location                      = "${var.location}"
  resource_group_name           = "${var.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.demo-core-fwcore-rg__PwPTFWCore-2hwmajahfzosu-NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Demo-Management.id}"
    private_ip_address            = "100.96.116.68"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface demo-core-fwcore-rg__PwPTFWCore-B-Nic1 {
  name                          = "PwPTFWCore-B-Nic1"
  location                      = "${var.location}"
  resource_group_name           = "${var.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.demo-core-fwcore-rg__PwPTFWCore-2hwmajahfzosu-NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Demo-Outside.id}"
    private_ip_address            = "100.96.112.5"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = "${azurerm_public_ip.demo-core-fwcore-rg__PwPTFWCore-B-EXT-PubIP.id}"
    primary                       = true
  }
}

resource azurerm_network_interface demo-core-fwcore-rg__PwPTFWCore-B-Nic2 {
  name                          = "PwPTFWCore-B-Nic2"
  location                      = "${var.location}"
  resource_group_name           = "${var.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.demo-core-fwcore-rg__PwPTFWCore-2hwmajahfzosu-NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Demo-CoreToSpokes.id}"
    private_ip_address            = "100.96.116.6"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface demo-core-fwcore-rg__PwPTFWCore-B-Nic3 {
  name                          = "PwPTFWCore-B-Nic3"
  location                      = "${var.location}"
  resource_group_name           = "${var.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.demo-core-fwcore-rg__PwPTFWCore-2hwmajahfzosu-NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Demo-HASync.id}"
    private_ip_address            = "100.96.116.37"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface demo-core-fwcore-rg__PwPTFWCore-B-Nic4 {
  name                          = "PwPTFWCore-B-Nic4"
  location                      = "${var.location}"
  resource_group_name           = "${var.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.demo-core-fwcore-rg__PwPTFWCore-2hwmajahfzosu-NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Demo-Management.id}"
    private_ip_address            = "100.96.116.69"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_public_ip demo-core-fwcore-rg__PwPTFWCore-A-EXT-PubIP {
  name                = "PwPTFWCore-A-EXT-PubIP"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_public_ip demo-core-fwcore-rg__PwPTFWCore-A-MGMT-PubIP {
  name                = "PwPTFWCore-A-MGMT-PubIP"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_public_ip demo-core-fwcore-rg__PwPTFWCore-B-EXT-PubIP {
  name                = "PwPTFWCore-B-EXT-PubIP"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_public_ip demo-core-fwcore-rg__PwPTFWCore-B-MGMT-PubIP {
  name                = "PwPTFWCore-B-MGMT-PubIP"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_public_ip demo-core-fwcore-rg__PwPTFWCore-ELB-PubIP {
  name                = "PwPTFWCore-ELB-PubIP"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_virtual_machine demo-core-fwcore-rg__PwPTFWCore-A {
  name                = "PwPTFWCore-A"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
  availability_set_id = "${azurerm_availability_set.demo-core-fwcore-rg__pwptfwcore-availabilityset.id}"
  vm_size             = "Standard_F4"
  network_interface_ids = [
  "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-A-Nic1.id}", 
  "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-A-Nic2.id}", 
  "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-A-Nic3.id}", 
  "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-A-Nic4.id}" ]
  primary_network_interface_id     = "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-A-Nic1.id}"
  delete_data_disks_on_termination = "false"
  delete_os_disk_on_termination    = "false"
  os_profile {
    computer_name  = "PwPTFWCore-A"
    admin_username = "fwadmin"
    admin_password = "${data.azurerm_key_vault_secret.fwpasswordsecret.value}"
    custom_data    = "${file("fwconfig/coreA.conf")}"
  }
  storage_image_reference {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = "fortinet_fg-vm"
    version   = "latest"
  }
  plan {
    name      = "fortinet_fg-vm"
    publisher = "fortinet"
    product   = "fortinet_fortigate-vm_v5"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_os_disk {
    name          = "PwPTFWCore-A_OsDisk_1"
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = "2"
  }
  storage_data_disk {
    name          = "PwPTFWCore-A_DataDisk_1"
    lun           = 0
    caching       = "None"
    create_option = "Empty"
    disk_size_gb  = "30"
  }
  tags = "${var.tags}"
}

resource azurerm_virtual_machine demo-core-fwcore-rg__PwPTFWCore-B {
  name                = "PwPTFWCore-B"
  location            = "${var.location}"
  resource_group_name = "${var.rgname.fortigate}"
  availability_set_id = "${azurerm_availability_set.demo-core-fwcore-rg__pwptfwcore-availabilityset.id}"
  vm_size             = "Standard_F4"
  network_interface_ids = [
    "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-B-Nic1.id}",
    "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-B-Nic2.id}",
    "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-B-Nic3.id}",
    "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-B-Nic4.id}"]
  primary_network_interface_id     = "${azurerm_network_interface.demo-core-fwcore-rg__PwPTFWCore-B-Nic1.id}"
  delete_data_disks_on_termination = "false"
  delete_os_disk_on_termination    = "false"
  os_profile {
    computer_name  = "PwPTFWCore-B"
    admin_username = "fwadmin"
    admin_password = "${data.azurerm_key_vault_secret.fwpasswordsecret.value}"
    custom_data    = "${file("fwconfig/coreB.conf")}"
  }
  storage_image_reference {
    publisher = "fortinet"
    offer     = "fortinet_fortigate-vm_v5"
    sku       = "fortinet_fg-vm"
    version   = "latest"
  }
  plan {
    name      = "fortinet_fg-vm"
    publisher = "fortinet"
    product   = "fortinet_fortigate-vm_v5"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  storage_os_disk {
    name          = "PwPTFWCore-B_OsDisk_1"
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = "2"
  }
  storage_data_disk {
    name          = "PwPTFWCore-B_DataDisk_1"
    lun           = 0
    caching       = "None"
    create_option = "Empty"
    disk_size_gb  = "30"
  }
  tags = "${var.tags}"
}
