resource "azurerm_virtual_network" "devvm-VNET" {
  name                = "${var.name}-VNET"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.devvm-RG.name}"
  address_space       = ["10.10.10.0/23"]
  tags = "${var.tags}"
}
resource "azurerm_subnet" "devvm-subnet" {
  name                 = "vmsubnet"
  virtual_network_name = "${azurerm_virtual_network.devvm-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.devvm-RG.name}"
  address_prefix       = "10.10.10.0/24"
}