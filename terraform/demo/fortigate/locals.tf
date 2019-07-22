locals {
  fwprefix = "${var.envprefix}FWCore"
  vnetname = {
    "netcore"= "${var.envprefix}-Core-NetCore-VNET"
  }
  rgname = {
    fortigate = "${var.envprefix}-Core-FWCore-RG"
    keyvault = "${var.envprefix}-Core-Keyvault-RG"
    netcore = "${var.envprefix}-Core-NetCore-RG"
  }
  fwsubnets = {
    outside = "${var.envprefix}-Outside"
    inside = "${var.envprefix}-CoreToSpokes"
    mgmt = "${var.envprefix}-Management"
    ha = "${var.envprefix}-HASync"
  }
  tags = {
    Organizations     = "PwP0-CCC-E&O"
    DeploymentVersion = "2018-12-14-01"
    Classification    = "Unclassified"
    Enviroment        = "Sandbox"
    CostCenter        = "PwP0-EA"
    Owner             = "cloudteam@tpsgc-pwgsc.gc.ca"
  }
}