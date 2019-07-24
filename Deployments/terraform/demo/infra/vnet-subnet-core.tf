resource "azurerm_virtual_network" "core-netcore-rg__Core-NetCore-VNET" {
  name                = "${var.envprefix}-Core-NetCore-VNET"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.Core-NetCore-RG.name}"
  address_space       = ["100.96.112.0/21"]
  tags = "${var.tags}"
}
resource azurerm_subnet core-netcore-rg__CoreToSpokes {
  name                 = "${var.envprefix}-CoreToSpokes"
  virtual_network_name = "${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Core-NetCore-RG.name}"
  address_prefix       = "100.96.116.0/27"
}
resource azurerm_subnet core-netcore-rg__HASync {
  name                 = "${var.envprefix}-HASync"
  virtual_network_name = "${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Core-NetCore-RG.name}"
  address_prefix       = "100.96.116.32/27"
}
resource azurerm_subnet core-netcore-rg__Management {
  name                 = "${var.envprefix}-Management"
  virtual_network_name = "${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Core-NetCore-RG.name}"
  address_prefix       = "100.96.116.64/27"
}
resource azurerm_subnet core-netcore-rg__Outside {
  name                 = "${var.envprefix}-Outside"
  virtual_network_name = "${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Core-NetCore-RG.name}"
  address_prefix       = "100.96.112.0/23"
}

resource azurerm_subnet core-netcore-rg__Outside2 {
  name                 = "${var.envprefix}-Outside2"
  virtual_network_name = "${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Core-NetCore-RG.name}"
  address_prefix       = "100.96.114.0/24"
}