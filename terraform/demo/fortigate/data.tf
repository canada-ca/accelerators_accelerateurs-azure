data "azurerm_client_config" "current" {}

data "azurerm_key_vault" "keyvaultsecrets" {
  name = "${var.envprefix}-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${local.rgname.keyvault}"),0,8)}"
  resource_group_name = "${local.rgname.keyvault}"
}

data "azurerm_key_vault_secret" "fwpasswordsecret" {
  name         = "fwpassword"
  key_vault_id = "${data.azurerm_key_vault.keyvaultsecrets.id}"
}

data "azurerm_subnet" "Outside" {
  name                 = "${local.fwsubnets.outside}"
  virtual_network_name = "${local.vnetname.netcore}"
  resource_group_name  = "${local.rgname.netcore}"
}

data "azurerm_subnet" "CoreToSpokes" {
  name                 = "${local.fwsubnets.inside}"
  virtual_network_name = "${local.vnetname.netcore}"
  resource_group_name  = "${local.rgname.netcore}"
}

data "azurerm_subnet" "HASync" {
  name                 = "${local.fwsubnets.ha}"
  virtual_network_name = "${local.vnetname.netcore}"
  resource_group_name  = "${local.rgname.netcore}"
}

data "azurerm_subnet" "Management" {
  name                 = "${local.fwsubnets.mgmt}"
  virtual_network_name = "${local.vnetname.netcore}"
  resource_group_name  = "${local.rgname.netcore}"
}

