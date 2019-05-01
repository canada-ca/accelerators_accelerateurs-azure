# DNS

## Introduction

This template deploys [Resourcegroups](https://docs.microsoft.com/en-us/azure/templates/microsoft.resources/2018-05-01/resourcegroups).

## Security Controls

The following security controls can be met through configuration of this template:

* None documented

## Dependancies

* None

## Parameter format

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "rgLocation": {
            "value": "canadacentral"
        },
        "rgNames": {
            "value": [
                {
                    "resourceGroup": "rgCoreTestLock",
                    "lock": "CanNotDelete"
                },
                {
                    "resourceGroup": "rgCoreTestNoLock"
                }
            ]
        },
        "tagValues": {
            "value": {
                "businessOwner": "PSPC-CCC",
                "costCenter": "PSPC-EA",
                "deploymentStage": "Sandbox",
                "dataProfile": "Unclassified",
                "version": "0.1"
            }
        }
    }
}
```

## Parameter Values

### Main Template

| Name              | Type   | Required | Value                                                                             |
| ----------------- | ------ | -------- | --------------------------------------------------------------------------------- |
| containerSasToken | string | No       | SAS Token received as a parameter                                                 |
| rgLocation        | string | Yes      | Location where the resource groups will be created. - canadaeast or canadacentral |
| rgNames           | array  | Yes      | Array of [Resource Group Objects](#resource-group-object)                         |
| tagValues         | object | Yes      | Array of [Tag Objects](#tag-object)                                               |

### Resource Group Object

| Name          | Type   | Required | Value                                                                      |
| ------------- | ------ | -------- | -------------------------------------------------------------------------- |
| resourceGroup | string | Yes      | Name of resource group to create                                           |
| lock          | string | No       | Should a lock be applied on the resource group. - CanNotDelete or ReadOnly |

### Tag object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

## History

| Date     | Change                                                                                                                     |
| -------- | -------------------------------------------------------------------------------------------------------------------------- |
| 20181120 | Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template. |
| 20181211 | Updates deploy.ps1 to make it more flexible and resilient.                                                                 |
| 20181214 | Implementing new template name as template.json                                                                            |
| 20190128 | Added optional parameter to lock resourcegroup                                                                             |
| 20190205 | Cleanup template folder                                                                                                    |
| 20190501 | Update documentation and create latest folder                                                                              |