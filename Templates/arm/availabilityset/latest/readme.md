# Availability Set

## Introduction

This template deploys an [availabilitySets resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-03-01/availabilitysets#Sku).

## Security Controls

The following security controls can be met through configuration of this template:

* None documented

## Dependancies

* [Resource Groups](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md)

## Parameter format

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "ASArray": {
            "value": [
                {
                    "resourceGroup": "rgManagement",
                    "name": "test-as",
                    "faultDomains": 2,
                    "updateDomains": 3,
                    "sku": "Aligned",
                    "tagValues": {
                        "businessOwner": "PSPC-CCC",
                        "costCenter": "PSPC-EA",
                        "deploymentStage": "Sandbox",
                        "dataProfile": "Unclassified",
                        "version": "0.1"
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
| ASArray            | array  | Yes      | Array of [availabilityset objects](#availabilityset-object)                                                                                                                                                                                                                                                                                                                                                                                                                    |

### availabilityset Object

| Name          | Type    | Required | Value                                                                                                                                                                                                                                                                                          |
| ------------- | ------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| resourceGroup | string  | No       | Name of resourcefroup where availabilityset will be deployed. Only needed when doing a subscription level deployment. Not required for resourcegroup based deployment. Leaving the parameter in place in resourcegroup based deployment will not cause any issue as it will be simply ignored. |
| name          | string  | Yes      | Name of the availabilityset                                                                                                                                                                                                                                                                    |
| faultDomains  | integer | Yes      | Fault Domain count.                                                                                                                                                                                                                                                                            |
| updateDomains | integer | Yes      | Update Domain count.                                                                                                                                                                                                                                                                           |
| sku           | string  | Yes      | The sku name. Use 'Aligned' for virtual machines with managed disks and 'Classic' for virtual machines with unmanaged disks.                                                                                                                                                                   |
| tagValues     | object  | Yes      | An object of tags - [Tag Object](#tag-object)                                                                                                                                                                                                                                                  |

### Tag object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

## History

| Date     | Change                                                                                                                           |
| -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| 20181120 | Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template.       |
| 20181211 | Updating deploy.ps1 to support new Azure subscription and be more flexible by moving variables as parameter with default values. |
| 20181214 | Implementing new template name as template.json                                                                                  |
| 20190207 | Cleanup template folder                                                                                                          |
| 20190302 | Transformed the template to be resourcegroup deployed rather than subscription level deployed.                                   |
| 20190426 | Updated documentation                                                                                                            |
| 20190501 | Updated documentation                                                                                                            |
