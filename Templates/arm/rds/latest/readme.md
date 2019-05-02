# Remote Desktop Service

## Introduction

This template deploys a Microsaoft Remote Desktop Service infrastructure comprised of one Gateway, one Broker and one or many Session Hosts.

## Security Controls

The following security controls can be met through configuration of this template:

* None documented yet

## Dependancies

* [Resource Groups](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md)
* [Keyvault](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/keyvaults/latest/readme.md)
* [VNET-Subnet](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/vnet-subnet/latest/readme.md)

## Parameter format

```json
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "keyVaultResourceGroupName": {
            "value": "Demo-Infra-Keyvault-RG"
        },
        "keyVaultName": {
            "value": "Demo-Infra-KV-[unique]"
        },
        "adminUsername": {
            "value": "azureadmin"
        },
        "adminPasswordSecret": {
            "value": "server2016DefaultPassword"
        },
        "adDomainName": {
            "value": "mgmt.demo.gc.ca.local"
        },
        "dnsServerPrivateIp": {
            "value": [
                "10.25.8.20",
                "10.25.8.21"
            ]
        },
        "rdsVnetRG": {
            "value": "Demo-Infra-NetMGMT-RG"
        },
        "rdsVnetName": {
            "value": "Demo-Infra-NetMGMT-VNET"
        },
        "rdsPAZSubnetName": {
            "value": "Demo-MGMT-PAZ-RDS"
        },
        "rdsAPPSubnetName": {
            "value": "Demo-MGMT-APP-RDS"
        },
        "rdsGatewayName": {
            "value": "DEMORDSGW"
        },
        "rdsBrokerName": {
            "value": "DEMORDSCBRK"
        },
        "rdsSessionHostNamePrefix": {
            "value": "DEMORDSSH"
        },
        "numberOfRdshInstances": {
            "value": 2
        },
        "imageSKU": {
            "value": "2016-Datacenter"
        },
        "rdshVmSize": {
            "value": "Standard_A4_v2"
        },
        "tagValues": {
            "value": {
                "Owner": "cloudteam@tpsgc-pwgsc.gc.ca",
                "CostCenter": "Demo-EA",
                "Enviroment": "Sandbox",
                "Classification": "Unclassified",
                "Organizations": "Demo-CCC-E&O"
            }
        }
    }
}
```

## Parameter Values

### Main Template

| Name                      | Type    | Required | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------------- | ------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| containerSasToken         | string  | No       | SAS Token received as a parameter                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| _artifactsLocation        | string  | No       | Dynamically derived from the deployment template link uri                                                                                                                                                                                                                                                                                                                                                                                                                      |
| _debugLevel               | string  | No       | Specifies the type of information to log for debugging. The permitted values are none, requestContent, responseContent, or both requestContent and responseContent separated by a comma. The default is none. When setting this value, carefully consider the type of information you are passing in during deployment. By logging information about the request or response, you could potentially expose sensitive data that is retrieved through the deployment operations. |
| keyVaultResourceGroupName | string  | Yes      | The name of the resource group containing the keyvault.                                                                                                                                                                                                                                                                                                                                                                                                                        |
| keyVaultName              | string  | Yes      | The name of the keyvault containing the secret.                                                                                                                                                                                                                                                                                                                                                                                                                                |
| adminUsername             | string  | Yes      | The name of the administrator of the new VM and the domain. Exclusion list: 'administrator'. For example azureadmin                                                                                                                                                                                                                                                                                                                                                            |
| adminPasswordSecret       | string  | Yes      | The name of the keyvault secret containing the password for the adminUsername                                                                                                                                                                                                                                                                                                                                                                                                  |
| adDomainName              | string  | Yes      | The name of the AD domain. For example contoso.com                                                                                                                                                                                                                                                                                                                                                                                                                             |
| dnsServerPrivateIp        | array   | No       | Array of strings of IP address of Domain DNS servers                                                                                                                                                                                                                                                                                                                                                                                                                           |
| rdsVnetRG                 | string  | Yes      | The Resource Group containing the RDS Virtual Network resource                                                                                                                                                                                                                                                                                                                                                                                                                 |
| rdsVnetName               | string  | Yes      | The vnet name for the RDS servers. For example Demo-Infra-NetMGMT-VNET                                                                                                                                                                                                                                                                                                                                                                                                         |
| rdsPAZSubnetName          | string  | Yes      | The subnet name for RDS PAZ servers. For example PAZ-AD                                                                                                                                                                                                                                                                                                                                                                                                                        |
| rdsAPPSubnetName          | string  | Yes      | The subnet name for RDS APP servers. For example APP-AD                                                                                                                                                                                                                                                                                                                                                                                                                        |
| rdsGatewayName            | string  | Yes      | The name for the RDS Gateway server. Max 12 characters. For example DemoRDSGW                                                                                                                                                                                                                                                                                                                                                                                                  |
| rdsBrokerName             | string  | Yes      | The name for the RDS Content Broker server. Max 12 characters. For example DemoRDSCB                                                                                                                                                                                                                                                                                                                                                                                           |
| rdsSessionHostNamePrefix  | string  | Yes      | The prefix for the name for the RDS Session server. Max 12 characters. For example DemoRDSCB                                                                                                                                                                                                                                                                                                                                                                                   |
| numberOfRdshInstances     | integer | Yes      | Number of RemoteDesktopSessionHosts. Minimum 1. Default 1.                                                                                                                                                                                                                                                                                                                                                                                                                     |
| imageSKU                  | string  | Yes      | Windows server SKU. Default: 2016-Datacenter                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| rdshVmSize                | string  | Yes      | The size of the RDSH VMs. Default: Standard_A4_v2                                                                                                                                                                                                                                                                                                                                                                                                                              |
| tagValues                 | object  | Yes      | Object containing [tags pairs](#tag-object)                                                                                                                                                                                                                                                                                                                                                                                                                                    |

### Tag object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

## History

| Date     | Change                                          |
| -------- | ----------------------------------------------- |
| 20190502 | Update documentation                            |
