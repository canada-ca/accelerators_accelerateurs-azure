terraform {
  required_version = ">= 0.12.1"
}

provider "azurerm" {
  version         = "= 1.31.0"
  subscription_id = "2de839a0-37f9-4163-a32a-e1bdb8d6eb7e"
}

data "azurerm_client_config" "current" {}

variable "envprefix" {
  description = "Prefix for the environment"
  default     = "Demo"
}

module "fortigateap" {
  source = "github.com/canada-ca-terraform-modules/terraform-azurerm-fortigateap?ref=20190724.1"

  location  = "canadacentral"
  envprefix = "Demo"
  
  keyvault = {
    name                = "${var.envprefix}-Core-KV-${substr(sha1("${data.azurerm_client_config.current.subscription_id}${var.envprefix}-Core-Keyvault-RG"),0,8)}"
    resource_group_name = "${var.envprefix}-Core-Keyvault-RG"
  }

  secretPasswordName = "fwpassword"
  
  FW-A = {
    nic1 = {
      private_ip_address = "100.96.112.4"
    }
    nic2 = {
      private_ip_address = "100.96.116.5"
    }
    nic3 = {
      private_ip_address = "100.96.116.36"
    }
    nic4 = {
      private_ip_address = "100.96.116.68"
    }
    vm_size     = "Standard_F4"
    custom_data = "fwconfig/coreA-lic.conf"

  }
  FW-B = {
    nic1 = {
      private_ip_address = "100.96.112.5"
    }
    nic2 = {
      private_ip_address = "100.96.116.6"
    }
    nic3 = {
      private_ip_address = "100.96.116.37"
    }
    nic4 = {
      private_ip_address = "100.96.116.69"
    }
    vm_size     = "Standard_F4"
    custom_data = "fwconfig/coreB-lic.conf"
  }
}
