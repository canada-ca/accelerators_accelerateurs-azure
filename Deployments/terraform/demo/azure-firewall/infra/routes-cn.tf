resource azurerm_route_table CN-Common-RT {
  name                = "${var.envprefix}-CN-Common-RT"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.CN-Net-RG.name}"
  route {
		 name = "${var.envprefix}-Core-VNET"
		 address_prefix = "100.96.112.0/21"
		 next_hop_type = "VirtualAppliance"
		 next_hop_in_ip_address = "10.10.10.4"
	 }
	 route {
		 name = "default"
		 address_prefix = "0.0.0.0/0"
		 next_hop_type = "VirtualAppliance"
		 next_hop_in_ip_address = "10.10.10.4"
	 }
  tags = "${var.tags}"
}