# Keyvault-nosecrets

## Introduction

This template deploys a [keyvault resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.keyvault/2018-02-14/vaults) with no default secrets.

## Security Controls

The following security controls can be met through configuration of this template:

* IA-5 (7), SC-12, SC-12 (2)

## Dependancies

* [Resource Groups](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md)

## Parameter format

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "keyvaultArray": {
            "value": [
                {
                    "name": "PwS2-validate-keyvault",
                    "sku": "Standard",
                    "enabledForDeployment": true,
                    "enabledForTemplateDeployment": true,
                    "enabledForDiskEncryption": true,
                    "accessPoliciesObjectId": "267cced3-2154-43ff-b79b-b12c331ad1d1",
                    "networkAcls": {
                        "defaultAction": "Allow",
                        "bypass": "AzureServices",
                        "virtualNetworkRules": [],
                        "ipRules": []
                    },
                    "tagValues": {
                        "Owner": "build.pipeline@tpsgc-pwgsc.gc.ca",
                        "CostCenter": "PSPC-EA",
                        "Enviroment": "Validate",
                        "Classification": "Unclassified",
                        "Organizations": "PSPC-CCC-E&O",
                        "DeploymentVersion": "2018-12-14-01"
                    }
                }
            ]
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
| keyvaultArray      | array  | Yes      | Array of [keyvault objects](#keyvault-object)                                                                                                                                                                                                                                                                                                                                                                                                                                  |

### keyvault Object

| Name                         | Type    | Required | Value                                                                                                                                                                          |
| ---------------------------- | ------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| name                         | string  | Yes      | Desired name of keyvault resource - [Name format options](#name-format-options)                                                                                                |
| sku                          | string  | Yes      | SKU name to specify whether the key vault is a standard vault or a premium vault. - standard or premium                                                                        |
| enabledForDeployment         | boolean | Yes      | Property to specify whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault. - true or false                                |
| enabledForTemplateDeployment | boolean | Yes      | Property to specify whether Azure Resource Manager is permitted to retrieve secrets from the key vault. - true or false                                                        |
| enabledForDiskEncryption     | boolean | No       | Property to specify whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. - true or false                                             |
| accessPoliciesObjectId       | string  | Yes      | The object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. |
| networkAcls                  | object  | Yes      | A collection of rules governing the accessibility of the vault from specific network locations. - [networkAcls object](#networkacls-object)                                    |
| tagValues                    | object  | Yes      | An object of tags - [Tag Object](#tag-object)                                                                                                                                  |

#### Name Format Options

When specifying the name of a keyvault simply include the token [unique] (including the []) as part of the name. The template will replace the [unique] word with a unique string of characters. For example:

| Name                   | Result                    |
| ---------------------- | ------------------------- |
| key-[unique]-deploy    | key-sd8kjdf678k9-deploy   |
| keyvault-test-[unique] | keyvault-test-7djkf90jkdf |

This is helpfull to ensure there will be no keyvault duplicates in Azure as it need to be unique.

### networkAcls object

| Name                | Type  | Required | Value                                                                                                                                                            |
| ------------------- | ----- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| bypass              | enum  | No       | Tells what traffic can bypass network rules. This can be 'AzureServices' or 'None'. If not specified the default is 'AzureServices'. - AzureServices or None     |
| defaultAction       | enum  | No       | The default action when no rule from ipRules and from virtualNetworkRules match. This is only used after the bypass property has been evaluated. - Allow or Deny |
| ipRules             | array | No       | The list of IP address rules. - [IPRule object](#iprule-object)                                                                                                  |
| virtualNetworkRules | array | No       | The list of virtual network rules. - [VirtualNetworkRule object](#virtualnetworkrule-object)                                                                     |

### IPRule object

| Name  | Type   | Required | Value                                                                                                                                             |
| ----- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------- |
| value | string | Yes      | An IPv4 address range in CIDR notation, such as '124.56.78.91' (simple IP address) or '124.56.78.0/24' (all addresses that start with 124.56.78). |

### VirtualNetworkRule object

| Name | Type   | Required | Value                                                                                                                                                       |
| ---- | ------ | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id   | string | Yes      | Full resource id of a vnet subnet, such as '/subscriptions/subid/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/test-vnet/subnets/subnet1'. |

### Tag object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

## History

| Date     | Change                                                                                                     |
| -------- | ---------------------------------------------------------------------------------------------------------- |
| 20181214 | Implementing new template name as template.json                                                            |
| 20190205 | Cleanup template folder                                                                                    |
| 20190226 | Add the ability to use a special token ([unique]) in the keyvault name to ensure keyvault name uniqueness. |
| 20190301 | Transformed the template to be resourcegroup deployed rather than subscription level deployed.             |
| 20190426 | Updated documentation                                                                                      |
| 20190501 | Updated documentation                                                                                      |