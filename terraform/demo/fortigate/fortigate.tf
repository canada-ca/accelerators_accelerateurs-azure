resource azurerm_availability_set availabilityset {
  name                         = "${local.fwprefix}-AvailabilitySet"
  location                     = "${var.location}"
  resource_group_name          = "${local.rgname.fortigate}"
  platform_fault_domain_count  = "2"
  platform_update_domain_count = "2"
  managed                      = "true"
  tags                         = "${var.tags}"
}

resource azurerm_network_security_group NSG {
  name                = "${local.fwprefix}-NSG"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
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


resource azurerm_network_interface FWCore-A-Nic1 {
  name                          = "${local.fwprefix}-A-Nic1"
  location                      = "${var.location}"
  resource_group_name           = "${local.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Outside.id}"
    private_ip_address            = "100.96.112.4"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = "${azurerm_public_ip.FWCore-A-EXT-PubIP.id}"
    primary                       = true
  }
}

resource azurerm_network_interface FWCore-A-Nic2 {
  name                          = "${local.fwprefix}-A-Nic2"
  location                      = "${var.location}"
  resource_group_name           = "${local.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.CoreToSpokes.id}"
    private_ip_address            = "100.96.116.5"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface FWCore-A-Nic3 {
  name                          = "${local.fwprefix}-A-Nic3"
  location                      = "${var.location}"
  resource_group_name           = "${local.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.HASync.id}"
    private_ip_address            = "100.96.116.36"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface FWCore-A-Nic4 {
  name                          = "${local.fwprefix}-A-Nic4"
  location                      = "${var.location}"
  resource_group_name           = "${local.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Management.id}"
    private_ip_address            = "100.96.116.68"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface FWCore-B-Nic1 {
  name                          = "${local.fwprefix}-B-Nic1"
  location                      = "${var.location}"
  resource_group_name           = "${local.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Outside.id}"
    private_ip_address            = "100.96.112.5"
    private_ip_address_allocation = "Static"
    public_ip_address_id          = "${azurerm_public_ip.FWCore-B-EXT-PubIP.id}"
    primary                       = true
  }
}

resource azurerm_network_interface FWCore-B-Nic2 {
  name                          = "${local.fwprefix}-B-Nic2"
  location                      = "${var.location}"
  resource_group_name           = "${local.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.CoreToSpokes.id}"
    private_ip_address            = "100.96.116.6"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface FWCore-B-Nic3 {
  name                          = "${local.fwprefix}-B-Nic3"
  location                      = "${var.location}"
  resource_group_name           = "${local.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.HASync.id}"
    private_ip_address            = "100.96.116.37"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_network_interface FWCore-B-Nic4 {
  name                          = "${local.fwprefix}-B-Nic4"
  location                      = "${var.location}"
  resource_group_name           = "${local.rgname.fortigate}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false
  network_security_group_id     = "${azurerm_network_security_group.NSG.id}"
  ip_configuration {
    name                          = "ipconfig1"
    subnet_id                     = "${data.azurerm_subnet.Management.id}"
    private_ip_address            = "100.96.116.69"
    private_ip_address_allocation = "Static"
    primary                       = true
  }
}

resource azurerm_public_ip FWCore-A-EXT-PubIP {
  name                = "${local.fwprefix}-A-EXT-PubIP"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_public_ip FWCore-A-MGMT-PubIP {
  name                = "${local.fwprefix}-A-MGMT-PubIP"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_public_ip FWCore-B-EXT-PubIP {
  name                = "${local.fwprefix}-B-EXT-PubIP"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_public_ip FWCore-B-MGMT-PubIP {
  name                = "${local.fwprefix}-B-MGMT-PubIP"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_public_ip FWCore-ELB-PubIP {
  name                = "${local.fwprefix}-ELB-PubIP"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
  sku                 = "Standard"
  allocation_method   = "Static"
  tags                = "${var.tags}"
}

resource azurerm_virtual_machine FWCore-A {
  name                = "${local.fwprefix}-A"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
  availability_set_id = "${azurerm_availability_set.availabilityset.id}"
  vm_size             = "Standard_F4"
  network_interface_ids = [
  "${azurerm_network_interface.FWCore-A-Nic1.id}", 
  "${azurerm_network_interface.FWCore-A-Nic2.id}", 
  "${azurerm_network_interface.FWCore-A-Nic3.id}", 
  "${azurerm_network_interface.FWCore-A-Nic4.id}" ]
  primary_network_interface_id     = "${azurerm_network_interface.FWCore-A-Nic1.id}"
  delete_data_disks_on_termination = "true"
  delete_os_disk_on_termination    = "true"
  os_profile {
    computer_name  = "${local.fwprefix}-A"
    admin_username = "fwadmin"
    admin_password = "${data.azurerm_key_vault_secret.fwpasswordsecret.value}"
    custom_data    = "${file("fwconfig/coreA-lic.conf")}"
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
    name          = "${local.fwprefix}-A_OsDisk_1"
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = "2"
  }
  storage_data_disk {
    name          = "${local.fwprefix}-A_DataDisk_1"
    lun           = 0
    caching       = "None"
    create_option = "Empty"
    disk_size_gb  = "30"
  }
  tags = "${var.tags}"
}

resource azurerm_virtual_machine FWCore-B {
  name                = "${local.fwprefix}-B"
  location            = "${var.location}"
  resource_group_name = "${local.rgname.fortigate}"
  availability_set_id = "${azurerm_availability_set.availabilityset.id}"
  vm_size             = "Standard_F4"
  network_interface_ids = [
    "${azurerm_network_interface.FWCore-B-Nic1.id}",
    "${azurerm_network_interface.FWCore-B-Nic2.id}",
    "${azurerm_network_interface.FWCore-B-Nic3.id}",
    "${azurerm_network_interface.FWCore-B-Nic4.id}"]
  primary_network_interface_id     = "${azurerm_network_interface.FWCore-B-Nic1.id}"
  delete_data_disks_on_termination = "true"
  delete_os_disk_on_termination    = "true"
  os_profile {
    computer_name  = "${local.fwprefix}-B"
    admin_username = "fwadmin"
    admin_password = "${data.azurerm_key_vault_secret.fwpasswordsecret.value}"
    custom_data    = "${file("fwconfig/coreB-lic.conf")}"
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
    name          = "${local.fwprefix}-B_OsDisk_1"
    caching       = "ReadWrite"
    create_option = "FromImage"
    os_type       = "Linux"
    disk_size_gb  = "2"
  }
  storage_data_disk {
    name          = "${local.fwprefix}-B_DataDisk_1"
    lun           = 0
    caching       = "None"
    create_option = "Empty"
    disk_size_gb  = "30"
  }
  tags = "${var.tags}"
}
