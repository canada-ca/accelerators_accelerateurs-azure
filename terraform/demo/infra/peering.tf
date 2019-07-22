resource azurerm_virtual_network_peering demo-core-netcore-rg__peering-to-Demo-Core-NetMGMT-VNET {
  name                         = "peering-to-Demo-Core-NetMGMT-VNET"
  resource_group_name          = "${azurerm_resource_group.Demo-Core-NetCore-RG.name}"
  virtual_network_name         = "${azurerm_virtual_network.demo-core-netcore-rg__Demo-Core-NetCore-VNET.name}"
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.Demo-Core-NetMGMT-RG.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.demo-core-netmgmt-rg__Demo-Core-NetMGMT-VNET.name}"
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}

resource azurerm_virtual_network_peering demo-core-netmgmt-rg__peering-to-Demo-Core-NetCore-VNET {
  name                         = "peering-to-Demo-Core-NetCore-VNET"
  resource_group_name          = "${azurerm_resource_group.Demo-Core-NetMGMT-RG.name}"
  virtual_network_name         = "${azurerm_virtual_network.demo-core-netmgmt-rg__Demo-Core-NetMGMT-VNET.name}"
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.Demo-Core-NetCore-RG.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.demo-core-netcore-rg__Demo-Core-NetCore-VNET.name}"
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}
