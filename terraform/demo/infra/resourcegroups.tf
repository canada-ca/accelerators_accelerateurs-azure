resource "azurerm_resource_group" "Demo-Core-Backup-RG" {
  name     = "Demo-Core-Backup-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-DNS-RG" {
  name     = "Demo-Core-DNS-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-FWCore-RG" {
  name     = "Demo-Core-FWCore-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-Keyvault-RG" {
  name     = "Demo-Core-Keyvault-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-LoggingPerf-RG" {
  name     = "Demo-Core-LoggingPerf-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-LoggingSec-RG" {
  name     = "Demo-Core-LoggingSec-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-Monitoring-RG" {
  name     = "Demo-Core-Monitoring-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-NetCore-RG" {
  name     = "Demo-Core-NetCore-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-NetMGMT-RG" {
  name     = "Demo-Core-NetMGMT-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-Core-Storage-RG" {
  name     = "Demo-Core-Storage-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-MGMT-ADDS-RG" {
  name     = "Demo-MGMT-ADDS-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Demo-MGMT-RDS-RG" {
  name     = "Demo-MGMT-RDS-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}