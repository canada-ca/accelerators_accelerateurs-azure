resource "azurerm_resource_group" "Core-Backup-RG" {
  name     = "${var.envprefix}-Core-Backup-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Core-DNS-RG" {
  name     = "${var.envprefix}-Core-DNS-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Core-FWCore-RG" {
  name     = "${var.envprefix}-Core-FWCore-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Core-Keyvault-RG" {
  name     = "${var.envprefix}-Core-Keyvault-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Core-LoggingPerf-RG" {
  name     = "${var.envprefix}-Core-LoggingPerf-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Core-LoggingSec-RG" {
  name     = "${var.envprefix}-Core-LoggingSec-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Core-Monitoring-RG" {
  name     = "${var.envprefix}-Core-Monitoring-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Core-NetCore-RG" {
  name     = "${var.envprefix}-Core-NetCore-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Core-NetMGMT-RG" {
  name     = "${var.envprefix}-Core-NetMGMT-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "Core-Storage-RG" {
  name     = "${var.envprefix}-Core-Storage-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "MGMT-ADDS-RG" {
  name     = "${var.envprefix}-MGMT-ADDS-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}
resource "azurerm_resource_group" "MGMT-RDS-RG" {
  name     = "${var.envprefix}-MGMT-RDS-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}

# Clients

resource "azurerm_resource_group" "CN-Docker" {
  name     = "${var.envprefix}-CN-Docker"
  location = "${var.location}"
  tags = "${var.tags}"
}

resource "azurerm_resource_group" "CN-Net-RG" {
  name     = "${var.envprefix}-CN-Net-RG"
  location = "${var.location}"
  tags = "${var.tags}"
}