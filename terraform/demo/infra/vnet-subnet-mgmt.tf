resource azurerm_virtual_network core-netmgmt-rg__Core-NetMGMT-VNET {
  name                = "${var.envprefix}-Core-NetMGMT-VNET"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.Core-NetMGMT-RG.name}"
  address_space       = ["100.96.120.0/21"]
  subnet {
    name           = "${var.envprefix}-MGMT-PAZ"
    address_prefix = "100.96.120.0/24"
  }
  subnet {
    name           = "${var.envprefix}-MGMT-APP"
    address_prefix = "100.96.122.0/24"
  }
  subnet {
    name           = "${var.envprefix}-MGMT-DB"
    address_prefix = "100.96.124.0/24"
  }
  tags = "${var.tags}"
}

resource azurerm_subnet core-netmgmt-rg__MGMT-APP {
  name                 = "${var.envprefix}-MGMT-APP"
  virtual_network_name = "${azurerm_virtual_network.core-netmgmt-rg__Core-NetMGMT-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Core-NetMGMT-RG.name}"
  address_prefix       = "100.96.122.0/24"
  route_table_id       = "${azurerm_route_table.core-netmgmt-rg__MGMT-APP-RT.id}"
}
resource azurerm_subnet_route_table_association core-netmgmt-rg__MGMT-APP__MGMT-APP-RT {
  subnet_id      = "${azurerm_subnet.core-netmgmt-rg__MGMT-APP.id}"
  route_table_id = "${azurerm_route_table.core-netmgmt-rg__MGMT-APP-RT.id}"
}
resource azurerm_subnet core-netmgmt-rg__MGMT-DB {
  name                 = "${var.envprefix}-MGMT-DB"
  virtual_network_name = "${azurerm_virtual_network.core-netmgmt-rg__Core-NetMGMT-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Core-NetMGMT-RG.name}"
  address_prefix       = "100.96.124.0/24"
  route_table_id       = "${azurerm_route_table.core-netmgmt-rg__MGMT-DB-RT.id}"
}
resource azurerm_subnet_route_table_association core-netmgmt-rg__MGMT-DB__MGMT-DB-RT {
  subnet_id      = "${azurerm_subnet.core-netmgmt-rg__MGMT-DB.id}"
  route_table_id = "${azurerm_route_table.core-netmgmt-rg__MGMT-DB-RT.id}"
}
resource azurerm_subnet core-netmgmt-rg__MGMT-PAZ {
  name                 = "${var.envprefix}-MGMT-PAZ"
  virtual_network_name = "${azurerm_virtual_network.core-netmgmt-rg__Core-NetMGMT-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Core-NetMGMT-RG.name}"
  address_prefix       = "100.96.120.0/24"
  route_table_id       = "${azurerm_route_table.core-netmgmt-rg__MGMT-PAZ-RT.id}"
}
resource azurerm_subnet_route_table_association core-netmgmt-rg__MGMT-PAZ__MGMT-PAZ-RT {
  subnet_id      = "${azurerm_subnet.core-netmgmt-rg__MGMT-PAZ.id}"
  route_table_id = "${azurerm_route_table.core-netmgmt-rg__MGMT-PAZ-RT.id}"
}
