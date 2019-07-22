resource "azurerm_resource_group" "Demo-Core-Backup-RG" {
  name     = "${var.envprefix}-Core-Backup-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-DNS-RG" {
  name     = "${var.envprefix}-Core-DNS-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-FWCore-RG" {
  name     = "${var.envprefix}-Core-FWCore-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-Keyvault-RG" {
  name     = "${var.envprefix}-Core-Keyvault-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-LoggingPerf-RG" {
  name     = "${var.envprefix}-Core-LoggingPerf-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-LoggingSec-RG" {
  name     = "${var.envprefix}-Core-LoggingSec-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-Monitoring-RG" {
  name     = "${var.envprefix}-Core-Monitoring-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-NetCore-RG" {
  name     = "${var.envprefix}-Core-NetCore-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-NetMGMT-RG" {
  name     = "${var.envprefix}-Core-NetMGMT-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-Storage-RG" {
  name     = "${var.envprefix}-Core-Storage-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-MGMT-ADDS-RG" {
  name     = "${var.envprefix}-MGMT-ADDS-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-MGMT-RDS-RG" {
  name     = "${var.envprefix}-MGMT-RDS-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}