resource azurerm_virtual_network CN-Net-VNET {
  name                = "${var.envprefix}-CN-Net-VNET"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.CN-Net-RG.name}"
  address_space       = ["10.250.128.0/17"]
  tags = "${var.tags}"
}

resource azurerm_subnet CN-Docker {
  name                 = "${var.envprefix}-CN-Docker"
  virtual_network_name = "${azurerm_virtual_network.CN-Net-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.CN-Net-RG.name}"
  address_prefix       = "10.250.128.0/24"
  route_table_id       = "${azurerm_route_table.CN-Common-RT.id}"
  network_security_group_id = "${azurerm_network_security_group.Allow-All-NSG.id}"
}
resource azurerm_subnet_route_table_association CN-Common-RT {
  subnet_id      = "${azurerm_subnet.CN-Docker.id}"
  route_table_id = "${azurerm_route_table.CN-Common-RT.id}"
}