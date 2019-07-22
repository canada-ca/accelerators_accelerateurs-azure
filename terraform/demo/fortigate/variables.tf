variable "location" {
  description = "Location of the network"
  default     = "canadacentral"
}

variable "tags" {
  default = {
    "Organizations"     = "PwP0-CCC-E&O"
    "DeploymentVersion" = "2018-12-14-01"
    "Classification"    = "Unclassified"
    "Enviroment"        = "Sandbox"
    "CostCenter"        = "PwP0-EA"
    "Owner"             = "cloudteam@tpsgc-pwgsc.gc.ca"
  }
}

variable "rgname" {
  default = {
    "fortigate" = "Demo-Core-FWCore-RG"
    "keyvault" = "Demo-Core-Keyvault-RG"
    "netcore" = "Demo-Core-NetCore-RG"
  }
}

variable "vnetname" {
  default = {
    "netcore" = "Demo-Core-NetCore-VNET"
  }
}



variable "fwsubnets" {
  default = {
    "outside" = "Demo-Outside"
    "inside" = "Demo-CoreToSpokes"
    "mgmt" = "Demo-Management"
    "ha" = "Demo-HASync"
  }
  
}
