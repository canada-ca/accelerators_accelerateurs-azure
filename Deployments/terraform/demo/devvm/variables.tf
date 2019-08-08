variable "location" {
  description = "Location of the network"
  default     = "canadacentral"
}

variable "name" {
  default = "devvm"
}

variable "admin_username" {
  default = "azureadmin"
}

variable "admin_password" {
  default = "Canada123!"
}

variable "custom_data" {
  default = "script/vmconfig.ps1"
}

variable "rdpPort" {
  default = "3389"
}

variable "vm_size" {
  default = "Standard_D2_v3"
}

variable "tags" {
  default = {
    "Enviroment"        = "Sandbox"
    "Owner"             = "cloudteam@somedomain.com"
  }
}