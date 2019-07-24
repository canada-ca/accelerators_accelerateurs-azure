resource azurerm_virtual_network_peering core-netcore-rg__peering-to-Core-NetMGMT-VNET {
  name                         = "peering-to-Core-NetMGMT-VNET"
  resource_group_name          = "${azurerm_resource_group.Core-NetCore-RG.name}"
  virtual_network_name         = "${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.Core-NetMGMT-RG.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.core-netmgmt-rg__Core-NetMGMT-VNET.name}"
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}

resource azurerm_virtual_network_peering core-netmgmt-rg__peering-to-Core-NetCore-VNET {
  name                         = "peering-to-Core-NetCore-VNET"
  resource_group_name          = "${azurerm_resource_group.Core-NetMGMT-RG.name}"
  virtual_network_name         = "${azurerm_virtual_network.core-netmgmt-rg__Core-NetMGMT-VNET.name}"
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.Core-NetCore-RG.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}
