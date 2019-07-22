resource "azurerm_key_vault" "demo-core-keyvault-rg__Demo-Core-KV" {
  name                            = "Demo-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}Demo-Core-Keyvault-RG"),0,8)}"
  location                        = "${var.location}"
  resource_group_name             = "${azurerm_resource_group.Demo-Core-Keyvault-RG.name}"
  sku_name                        = "standard"
  tenant_id                       = "${data.azurerm_client_config.current.tenant_id}"
  enabled_for_deployment          = true
  enabled_for_disk_encryption     = true
  enabled_for_template_deployment = true
  access_policy {
    tenant_id = "${data.azurerm_client_config.current.tenant_id}"
    object_id = "267cced3-2154-43ff-b79b-b12c331ad1d1"
    key_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]
    secret_permissions = [
      "Get",
      "List",
      "Set",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
    ]
    certificate_permissions = [
      "Get",
      "List",
      "Update",
      "Create",
      "Import",
      "Delete",
      "Recover",
      "Backup",
      "Restore",
      "ManageContacts",
      "ManageIssuers",
      "GetIssuers",
      "ListIssuers",
      "SetIssuers",
      "DeleteIssuers",
    ]
  }
  tags = "${var.tags}"
}

resource "azurerm_key_vault_secret" "test1" {
  name         = "server2016DefaultPassword"
  value        = "Canada123!"
  key_vault_id = "${azurerm_key_vault.demo-core-keyvault-rg__Demo-Core-KV.id}"

  tags = "${var.tags}"
}
resource "azurerm_key_vault_secret" "test2" {
  name         = "linuxDefaultPassword"
  value        = "Canada123!"
  key_vault_id = "${azurerm_key_vault.demo-core-keyvault-rg__Demo-Core-KV.id}"

  tags = "${var.tags}"
  depends_on = ["azurerm_key_vault_secret.test1"]
}
resource "azurerm_key_vault_secret" "test3" {
  name         = "adDefaultPassword"
  value        = "Canada123!"
  key_vault_id = "${azurerm_key_vault.demo-core-keyvault-rg__Demo-Core-KV.id}"

  tags = "${var.tags}"
  depends_on = ["azurerm_key_vault_secret.test2"]
}
resource "azurerm_key_vault_secret" "test4" {
  name         = "defaultAdminUsername"
  value        = "Canada123!"
  key_vault_id = "${azurerm_key_vault.demo-core-keyvault-rg__Demo-Core-KV.id}"

  tags = "${var.tags}"
  depends_on = ["azurerm_key_vault_secret.test3"]
}
resource "azurerm_key_vault_secret" "test5" {
  name         = "fwpassword"
  value        = "Canada123!"
  key_vault_id = "${azurerm_key_vault.demo-core-keyvault-rg__Demo-Core-KV.id}"

  tags = "${var.tags}"
  depends_on = ["azurerm_key_vault_secret.test4"]
}