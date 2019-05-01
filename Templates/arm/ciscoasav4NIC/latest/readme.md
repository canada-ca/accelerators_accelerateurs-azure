# Cisco ASAv 4 NIC

## Introduction

This template deploys a 4 NIC Cisco ASAv Firewall resource.

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
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "fwObject": {
            "value": {
                "vmKeyVault": {
                    "keyVaultResourceGroupName": "PwS2-validate-ciscoasav2NIC-RG",
                    "keyVaultName": "PwS2-validate-[unique]"
                },
                "vmName": "validatefw",
                "softwareVersion": "910.1.11",
                "adminUsername": "azureadmin",
                "adminSecret": "fwpassword",
                "sshPublicKey": "",
                "authenticationType": "password",
                "vmSize": "Standard_D3_v2",
                "location": "canadacentral",
                "storageAccountName": "validasav",
                "storageAccountRG": "PwS2-validate-ciscoasav2NIC-RG",
                "storageAccountType": "Standard_LRS",
                "storageAccountNewOrExisting": "new",
                "publicIPAddressName": "validatefw-pubip",
                "publicIPDnsLabel": "validatefw",
                "publicIPNewOrExisting": "new",
                "publicIPRG": "PwS2-validate-ciscoasav2NIC-RG",
                "publicIPAllocationMethod": "Static",
                "publicIPsku": "Basic",
                "virtualNetworkName": "PwS2-validate-servers-VNET",
                "virtualNetworkRG": "PwS2-validate-ciscoasav2NIC-RG",
                "Subnet1Name": "outside",
                "subnet1StartAddress": "10.96.96.132",
                "Subnet2Name": "inside",
                "subnet2StartAddress": "10.96.96.4",
                "Subnet3Name": "three",
                "subnet3StartAddress": "10.96.96.36",
                "Subnet4Name": "four",
                "subnet4StartAddress": "10.96.96.68"
            }
        }
    }
}
```

## Parameter Values

### Main Template

| Name               | Type   | Required | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------ | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| containerSasToken  | string | No       | SAS Token received as a parameter                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| _artifactsLocation | string | No       | Dynamically derived from the deployment template link uri                                                                                                                                                                                                                                                                                                                                                                                                                      |
| _debugLevel        | string | No       | Specifies the type of information to log for debugging. The permitted values are none, requestContent, responseContent, or both requestContent and responseContent separated by a comma. The default is none. When setting this value, carefully consider the type of information you are passing in during deployment. By logging information about the request or response, you could potentially expose sensitive data that is retrieved through the deployment operations. |
| fwObject           | object | Yes      | Array of [CiscoASAv2NIC objects](#ciscoasav4nic-object)                                                                                                                                                                                                                                                                                                                                                                                                                        |

### CiscoASAv4NIC Object

| Name                        | Type   | Required | Value                                                                                                                        |
| --------------------------- | ------ | -------- | ---------------------------------------------------------------------------------------------------------------------------- |
| vmKeyVault                  | object | Yes      | Keyvault resource information - [Keyvault Object](#keyvault-object)                                                          |
| vmName                      | string | Yes      | Name of the firewall Virtual Machine.                                                                                        |
| softwareVersion             | string | Yes      | Version of the firewall marketplace image. Current allowed values are 9.10.1-11, 9.10.1, 9.9.2-18, 9.9.1-6                   |
| adminUsername               | string | Yes      | Name of the CiscoASAv admin user                                                                                             |
| adminSecret                 | string | Yes      | Name of the keyvault secret containing the CiscoASAv admin user password                                                     |
| sshPublicKey                | string | Yes      | SSH Key for the virtual machines. Set as "" if not used.                                                                     |
| authenticationType          | string | Yes      | Type of authentication. Allowed values are password or sshPublicKey                                                          |
| vmSize                      | string | Yes      | Size of the Virtual Machine. Recommended value is one of Standard_D3 or Standard_D3_v2                                       |
| location                    | string | Yes      | Location of the resource. Either canadacentral or canadaeast                                                                 |
| storageAccountName          | string | Yes      | Storage Account prefix where the Virtual Machine's disks and/or diagnostic files will be placed. Name will be made unique.   |
| storageAccountRG            | string | Yes      | Name of the Resource Group for the storage account defined above                                                             |
| storageAccountType          | string | Yes      | The type of storage account created. Recommended value is Standard_LRS                                                       |
| storageAccountNewOrExisting | string | Yes      | Should the storage account be created as part of the deployment. Possible value is new or existing. Recommended value is new |
| publicIPAddressName         | string | Yes      | Name of the Public IP Address                                                                                                |
| publicIPDnsLabel            | string | Yes      | DNS Prefix for the Public IP used to access the Virtual Machine. Will be made unique.                                        |
| publicIPNewOrExisting       | string | Yes      | Indicates whether the Public IP is new or existing                                                                           |
| publicIPRG                  | string | Yes      | Resource Group of the public IP                                                                                              |
| publicIPAllocationMethod    | string | Yes      | Enter Dynamic or Static as the type of public IP                                                                             |
| publicIPsku                 | string | Yes      | Indicates whether the public IP SKU will be of Basic or Standard                                                             |
| virtualNetworkName          | string | Yes      | Virtual Network name                                                                                                         |
| virtualNetworkRG            | string | Yes      | Name of the Resource Group containing the VNET defined above                                                                 |
| Subnet1Name                 | string | Yes      | Name of the external subnet                                                                                                  |
| subnet1StartAddress         | string | Yes      | IP address of the external interface                                                                                         |
| Subnet2Name                 | string | Yes      | Name of the internal subnet                                                                                                  |
| subnet2StartAddress         | string | Yes      | IP address of the internal interface                                                                                         |
| Subnet3Name                 | string | Yes      | Name of the 3rd subnet                                                                                                       |
| subnet3StartAddress         | string | Yes      | IP address of the 3rd interface                                                                                              |
| Subnet4Name                 | string | Yes      | Name of the 4th subnet                                                                                                       |
| subnet4StartAddress         | string | Yes      | IP address of the 4th interface                                                                                              |

### Keyvault Object

| Name                      | Type                           | Required | Value                                                                   |
| ------------------------- | ------------------------------ | -------- | ----------------------------------------------------------------------- |
| keyVaultResourceGroupName | PwS2-validate-ciscoasav2NIC-RG | Yes      | Name of the Resource Group containing the keyvault                      |
| keyVaultName              | PwS2-validate-[unique]         | Yes      | Name of keyvault resource - [Name format options](#name-format-options) |

#### Name Format Options

When specifying the name of a keyvault simply include the token [unique] (including the []) as part of the name. The template will replace the [unique] word with a unique string of characters. For example:

| Name                   | Result                     |
| ---------------------- | -------------------------- |
| key-[unique]-deploy    | key-sd8kjdf678k9-deploy    |
| keyvault-test-[unique] | keyvault-test-sd8kjdf678k9 |

This is helpfull to ensure there will be no keyvault duplicates in Azure as it need to be unique.

## History

| Date     | Change                                                                                                |
| -------- | ----------------------------------------------------------------------------------------------------- |
| 20190327 | Refactor template and implement keyvault secret for password. New parameter file format is also used. |
| 20190429 | Updated documentation and cleanup parameters                                                          |
| 20190430 | Updated documentation and cleanup parameters                                                          |
| 20190501 | Updated documentation and yaml                                                                        |