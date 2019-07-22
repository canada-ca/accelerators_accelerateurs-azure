resource "azurerm_virtual_network" "demo-core-netcore-rg__Demo-Core-NetCore-VNET" {
  name                = "Demo-Core-NetCore-VNET"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.Demo-Core-NetCore-RG.name}"
  address_space       = ["100.96.112.0/21"]
  tags = "${var.tags}"
}
resource azurerm_subnet demo-core-netcore-rg__Demo-CoreToSpokes {
  name                 = "Demo-CoreToSpokes"
  virtual_network_name = "${azurerm_virtual_network.demo-core-netcore-rg__Demo-Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Demo-Core-NetCore-RG.name}"
  address_prefix       = "100.96.116.0/27"
}
resource azurerm_subnet demo-core-netcore-rg__Demo-HASync {
  name                 = "Demo-HASync"
  virtual_network_name = "${azurerm_virtual_network.demo-core-netcore-rg__Demo-Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Demo-Core-NetCore-RG.name}"
  address_prefix       = "100.96.116.32/27"
}
resource azurerm_subnet demo-core-netcore-rg__Demo-Management {
  name                 = "Demo-Management"
  virtual_network_name = "${azurerm_virtual_network.demo-core-netcore-rg__Demo-Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Demo-Core-NetCore-RG.name}"
  address_prefix       = "100.96.116.64/27"
}
resource azurerm_subnet demo-core-netcore-rg__Demo-Outside {
  name                 = "Demo-Outside"
  virtual_network_name = "${azurerm_virtual_network.demo-core-netcore-rg__Demo-Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Demo-Core-NetCore-RG.name}"
  address_prefix       = "100.96.112.0/23"
}
