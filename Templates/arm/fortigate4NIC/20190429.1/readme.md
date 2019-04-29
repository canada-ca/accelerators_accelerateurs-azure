# Introduction 
This template deploys a 4 NIC Fortigate Firewall resource.

# Parameter format
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "fwObject": {
            "value": {
                "vmKeyVault": {
                    "keyVaultResourceGroupName": "PwS2-validate-fortigate2NIC-RG",
                    "keyVaultName": "PwS2-validate-[unique]"
                },
                "FortiGateName": "validate01",
                "adminUsername": "fwadmin",
                "adminSecret": "fwpassword",
                "FortiGateImageSKU": "fortinet_fg-vm",
                "FortiGateImageVersion": "latest",
                "instanceType": "Standard_F4s",
                "publicIPAddressName": "validate01-publicip",
                "publicIPAddressType": "Static",
                "publicIPNewOrExistingOrNone": "new",
                "publicIPResourceGroup": "PwS2-validate-fortigate2NIC-RG",
                "location": "canadacentral",
                "vnetNewOrExisting": "existing",
                "vnetName": "PwS2-validate-fortigate2NIC-VNET",
                "vnetResourceGroup": "PwS2-validate-fortigate2NIC-RG",
                "Subnet1Name": "outside",
                "Subnet2Name": "inside",
                "FirewallConfig": "Y29uZmlnIHN5c3RlbSBnbG9iYWwKICAgICBzZXQgYWRtaW4tc3BvcnQgODQ0MwplbmQK"
            }
        }
    }
}
```

# Parameter Values
## Main Template
| Name               | Type   | Required | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------ | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| containerSasToken  | string | No       | SAS Token received as a parameter                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| _artifactsLocation | string | No       | Dynamically derived from the deployment template link uri                                                                                                                                                                                                                                                                                                                                                                                                                      |
| _debugLevel        | string | No       | Specifies the type of information to log for debugging. The permitted values are none, requestContent, responseContent, or both requestContent and responseContent separated by a comma. The default is none. When setting this value, carefully consider the type of information you are passing in during deployment. By logging information about the request or response, you could potentially expose sensitive data that is retrieved through the deployment operations. |
| fwObject           | object | Yes      | Array of [Fortigate2NIC objects](##Fortigate2NIC-Object)                                                                                                                                                                                                                                                                                                                                                                                                                       |

## Fortigate2NIC Object
| Name                        | Type   | Required | Value                                                                                                                                |
| --------------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------ |
| vmKeyVault                  | object | Yes      | Keyvault resource information - [Keyvault Object](##Keyvault-Object)                                                                 |
| FortiGateName               | string | Yes      | Name of the firewall Virtual Machine.                                                                                                |
| adminUsername               | string | Yes      | Name of the Fortigate admin user                                                                                                     |
| adminSecret                 | string | Yes      | Name of the keyvault secret containing the Fortigate admin user password                                                             |
| FortiGateImageSKU           | string | Yes      | SKU for the fortigate image - fortinet_fg-vm or fortinet_fg-vm_payg                                                                  |
| FortiGateImageVersion       | string | Yes      | Version of the firewall marketplace image - 5.6.6, 6.0.3, 6.0.4 or latest. Recommended values: latest                                |
| instanceType                | string | Yes      | Virtual Machine size selection. Recommended value: Standard_F4s                                                                      |
| publicIPAddressName         | string | Yes      | Name of the Public IP Address                                                                                                        |
| publicIPAddressType         | string | Yes      | Type of public IP address - dynamic or static. Recommended value: static                                                             |
| publicIPNewOrExistingOrNone | string | Yes      | Indicates whether a Public IP is required - none, new or existing. Recommended value: none unless one is required. In this case: new |
| publicIPResourceGroup       | string | Yes      | Resource Group of the public IP                                                                                                      |
| location                    | string | Yes      | Location of the resource. Either canadacentral or canadaeast                                                                         |
| vnetNewOrExisting           | string | Yes      | Identify whether to use a new or existing vnet - new or existing. Recommended value: existing                                        |
| vnetName                    | string | Yes      | Virtual Network name                                                                                                                 |
| vnetResourceGroup           | string | Yes      | Name of the Resource Group containing the VNET defined above                                                                         |
| authenticationType          | string | Yes      | Type of authentication. Allowed values are password or sshPublicKey                                                                  |
| vmSize                      | string | Yes      | Size of the Virtual Machine. Recommended value is one of Standard_D3 or Standard_D3_v2                                               |
| storageAccountName          | string | Yes      | Storage Account prefix where the Virtual Machine's disks and/or diagnostic files will be placed. Name will be made unique.           |
| storageAccountRG            | string | Yes      | Name of the Resource Group for the storage account defined above                                                                     |
| storageAccountType          | string | Yes      | The type of storage account created. Recommended value is Standard_LRS                                                               |
| storageAccountNewOrExisting | string | Yes      | Should the storage account be created as part of the deployment. Possible value is new or existing. Recommended value is new         |
| publicIPDnsLabel            | string | Yes      | DNS Prefix for the Public IP used to access the Virtual Machine. Will be made unique.                                                |
| publicIPNewOrExisting       | string | Yes      | Indicates whether the Public IP is new or existing                                                                                   |
| publicIPRG                  | string | Yes      | Resource Group of the public IP                                                                                                      |
| publicIPAllocationMethod    | string | Yes      | Enter Dynamic or Static as the type of public IP                                                                                     |
| publicIPsku                 | string | Yes      | Indicates whether the public IP SKU will be of Basic or Standard                                                                     |
| virtualNetworkName          | string | Yes      | Virtual Network name                                                                                                                 |
| virtualNetworkRG            | string | Yes      | Name of the Resource Group containing the VNET defined above                                                                         |
| Subnet1Name                 | string | Yes      | Name of the external subnet                                                                                                          |
| Subnet2Name                 | string | Yes      | Name of the internal subnet                                                                                                          |
| Subnet3Name                 | string | Yes      | Name of the 3rd subnet                                                                                                          |
| Subnet4Name                 | string | Yes      | Name of the 4th subnet                                                                                                          |
| FirewallConfig              | string | Yes      | multipart/mixed Base64 encoded string of [Firewall Config and License](##Firewall-Config-and-License). Leave empty ("") is no firewall configuration is required |

## Keyvault Object
| Name                      | Type                           | Required | Value                                                                    |
| ------------------------- | ------------------------------ | -------- | ------------------------------------------------------------------------ |
| keyVaultResourceGroupName | PwS2-validate-Fortigate2NIC-RG | Yes      | Name of the Resource Group containing the keyvault                       |
| keyVaultName              | PwS2-validate-[unique]         | Yes      | Name of keyvault resource - [Name format options](##Name-Format-Options) |

### Name Format Options

When specifying the name of a keyvault simply include the token [unique] (including the []) as part of the name. The template will replace the [unique] word with a unique string of characters. For example:

| Name                   | Result                     |
| ---------------------- | -------------------------- |
| key-[unique]-deploy    | key-sd8kjdf678k9-deploy    |
| keyvault-test-[unique] | keyvault-test-sd8kjdf678k9 |

This is helpfull to ensure there will be no keyvault duplicates in Azure as it need to be unique.

## Firewall Config and License

Two part mime message comprised of the desired firewall configuration and the fortigate license. Here is an example of the mime message:

```mime
Content-Type: multipart/mixed; boundary="===============0740947994048919689=="
MIME-Version: 1.0

--===============0740947994048919689==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="config"

config system global
    set admin-sport 8443
    set alias "DemoFWCore01"
    set hostname "DemoFWCore01"
    set timezone 04
end
config system interface
    edit "port1"
        set vdom "root"
        set mode dhcp
        set allowaccess ping https ssh http fgfm
        set type physical
        set description "Demo-Core-Outside"
        set alias "Demo-Core-Outside"
        set snmp-index 1
    next
    edit "port2"
        set vdom "root"
        set mode dhcp
        set allowaccess ping https ssh http fgfm
        set type physical
        set description "Demo-Core-CoreToSpokes"
        set alias "Demo-Core-CoreToSpokes"
        set snmp-index 2
        set defaultgw disable
    next
end
config router static
    edit 1
        set dst 10.25.0.0 255.255.0.0
        set gateway 10.10.10.1
        set device "port2"
    next
end
config firewall vip
    edit "Jumpbox01"
        set uuid b309aa80-55aa-51e9-a5af-1429d639831b
        set extip 10.10.10.132
        set extintf "port1"
        set portforward enable
        set mappedip "10.25.4.36"
        set extport 33890
        set mappedport 3389
    next
    edit "DemoRDS01"
        set uuid f1553200-55aa-51e9-dcd8-56b26cc2ea88
        set extip 10.10.10.132
        set extintf "port1"
        set portforward enable
        set mappedip "10.25.4.4"
        set extport 33891
        set mappedport 3389
    next
end
config firewall policy
    edit 1
        set name "Jumpbox-1 RDP"
        set uuid b30a0c8c-55aa-51e9-d793-11db226d151d
        set srcintf "port1"
        set dstintf "port2"
        set srcaddr "all"
        set dstaddr "Jumpbox01"
        set action accept
        set schedule "always"
        set service "RDP"
        set logtraffic all
        set logtraffic-start enable
        set fsso disable
    next
    edit 3
        set name "RDP to DemoRDS01"
        set uuid 385803bc-55ab-51e9-5828-5b31f1c9fd66
        set srcintf "port1"
        set dstintf "port2"
        set srcaddr "all"
        set dstaddr "DemoRDS01"
        set action accept
        set schedule "always"
        set service "RDP"
        set logtraffic all
        set logtraffic-start enable
        set fsso disable
        set comments "Clone of Jumpbox-1 RDP"
    next
    edit 2
        set name "InternetAccess"
        set uuid b30ae666-55aa-51e9-4bde-348b54f97c16
        set srcintf "port2"
        set dstintf "port1"
        set srcaddr "all"
        set dstaddr "all"
        set action accept
        set schedule "always"
        set service "ALL"
        set logtraffic all
        set logtraffic-start enable
        set fsso disable
        set nat enable
    next
end
config log setting
    set fwpolicy-implicit-log enable
end

--===============0740947994048919689==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="license"

-----BEGIN FGT VM LICENSE-----
QAAAAIXJomWFxcL/cRVxBsqMa-LoremIpsum-k7/jH/YbKdjOFeQpN7YB70wW52ZIyOCTkInDh
FVDPhtn7YBw=
-----END FGT VM LICENSE-----

--===============0740947994048919689==--
```

# History

| Date     | Change                                          |
| -------- | ----------------------------------------------- |
| 20181217 | 1st version                                     |
| 20190205 | Cleanup template folder                         |
| 20190328 | Refactor template to support keyvault passwords |
| 20190429 | Update documentation                            |