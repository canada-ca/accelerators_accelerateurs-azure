data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "keyvaultsecrets" {
  name = "Demo-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${var.rgname.keyvault}"),0,8)}"
  resource_group_name = "${var.rgname.keyvault}"
}

data "azurerm_key_vault_secret" "fwpasswordsecret" {
  name         = "fwpassword"
  key_vault_id = "${data.azurerm_key_vault.keyvaultsecrets.id}"
}

data "azurerm_subnet" "Demo-Outside" {
  name                 = "${var.fwsubnets.outside}"
  virtual_network_name = "${var.vnetname.netcore}"
  resource_group_name  = "${var.rgname.netcore}"
}

data "azurerm_subnet" "Demo-CoreToSpokes" {
  name                 = "${var.fwsubnets.inside}"
  virtual_network_name = "${var.vnetname.netcore}"
  resource_group_name  = "${var.rgname.netcore}"
}

data "azurerm_subnet" "Demo-HASync" {
  name                 = "${var.fwsubnets.ha}"
  virtual_network_name = "${var.vnetname.netcore}"
  resource_group_name  = "${var.rgname.netcore}"
}

data "azurerm_subnet" "Demo-Management" {
  name                 = "${var.fwsubnets.mgmt}"
  virtual_network_name = "${var.vnetname.netcore}"
  resource_group_name  = "${var.rgname.netcore}"
}

