resource azurerm_virtual_network_peering peering-Core-to-Core-NetMGMT-VNET {
  name                         = "peering-Core-to-Core-NetMGMT-VNET"
  resource_group_name          = "${azurerm_resource_group.Core-NetCore-RG.name}"
  virtual_network_name         = "${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.Core-NetMGMT-RG.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.core-netmgmt-rg__Core-NetMGMT-VNET.name}"
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}

resource azurerm_virtual_network_peering peering-Core-to-CN-Net-VNET {
  name                         = "peering-Core-to-CN-Net-VNET"
  resource_group_name          = "${azurerm_resource_group.Core-NetCore-RG.name}"
  virtual_network_name         = "${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.CN-Net-RG.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.CN-Net-VNET.name}"
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}

resource azurerm_virtual_network_peering peering-MGMT-to-Core-NetCore-VNET {
  name                         = "peering-MGMT-to-Core-NetCore-VNET"
  resource_group_name          = "${azurerm_resource_group.Core-NetMGMT-RG.name}"
  virtual_network_name         = "${azurerm_virtual_network.core-netmgmt-rg__Core-NetMGMT-VNET.name}"
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.Core-NetCore-RG.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}

resource azurerm_virtual_network_peering peering-CN-Net-to-Core-NetCore-VNET {
  name                         = "peering-CN-Net-to-Core-NetCore-VNET"
  resource_group_name          = "${azurerm_resource_group.CN-Net-RG.name}"
  virtual_network_name         = "${azurerm_virtual_network.CN-Net-VNET.name}"
  remote_virtual_network_id    = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.Core-NetCore-RG.name}/providers/Microsoft.Network/virtualNetworks/${azurerm_virtual_network.core-netcore-rg__Core-NetCore-VNET.name}"
  allow_forwarded_traffic      = true
  allow_gateway_transit        = false
  allow_virtual_network_access = true
  use_remote_gateways          = false
}