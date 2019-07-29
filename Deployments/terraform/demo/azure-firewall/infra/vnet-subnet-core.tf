resource "azurerm_virtual_network" "core-netcore-rg__Core-NetCore-VNET" {
  name                = "${var.envprefix}-Core-NetCore-VNET"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.Core-NetCore-RG.name}"
  address_space       = ["10.10.10.0/23"]
  tags = "${var.tags}"
}
resource "azurerm_subnet" "AzureFirewallSubnet" {
  name                 = "AzureFirewallSubnet"
  virtual_network_name = "${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  resource_group_name  = "${azurerm_resource_group.Core-NetCore-RG.name}"
  address_prefix       = "10.10.10.0/26"
}