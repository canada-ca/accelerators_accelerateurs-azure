# Storage Accounts

## Introduction

This template is used to create [Storage Accounts](https://docs.microsoft.com/en-us/azure/templates/microsoft.storage/2018-02-01/storageaccounts) based on an array of accounts passed in.

## Security Controls

The following security controls can be met through configuration of this template:

* [Storage Redundancy](documentation/Storage-Redundancy.md): CP-6.a, CP-6.b, CP-6 (1), CP-6 (2).  

## Parameter format

```JSON
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "containerSasToken": {
            "value": "[SasToken]"
        },
        "storageArray": {
            "value": [
                {
                    "comment": "Comment goes here",
                    "resourceGroup": "AzPwS01-Infra-Temp-RG",
                    "storageAccountPrefix": "vmdiag",
                    "accountType": "Standard_LRS",
                    "kind": "StorageV2",
                    "supportsHttpsTrafficOnly": true
                },
                {
                    "comment": "Comment goes here",
                    "resourceGroup": "AzPwS01-Infra-Temp-RG",
                    "storageAccountPrefix": "vmdiag",
                    "accountType": "Standard_LRS",
                    "kind": "StorageV2",
                    "supportsHttpsTrafficOnly": true,
                    "containerName": ["test-library-dev","test-library-release"],
                    "advancedThreatProtectionEnabled": true
                }
            ]
        }
    }
}
```

## Parameter Values

### Main Template

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|containerSasToken |string |No      |A SaS token for the private blob storage |
|storageArray |array |Yes      |An array of storage objects to create - [Storage Object](###storage-object) |

### Storage object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|comment     |string |No       | Optional comment for the storage account|
|resourceGroup| string |Yes | The name of the resource group to create the storage account in.|
|storageAccountPrefix|string|Yes| A prefix to add to the storage account name.  Note any prefix over 11 characters will be truncated.|
|accountType |enum   |Yes | The type of storage account.  - Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS, Premium_ZRS, Standard_GZRS, Standard_RAGZRS
|kind|enum| Yes| Indicates the type of storage account. - Storage, StorageV2, BlobStorage|
|supportsHttpsTrafficOnly|bool|Yes|Allows https traffic only to storage service if sets to true.|
|containerName| array| Yes | A string array of container names to create|
|advancedThreatProtectionEnabled| bool| Yes|Indicates if advanced threat protection should be enabled.  Advanced Threat Protection provides an additional layer of security intelligence that detects unusual and potentially harmful attempts to access or exploit storage accounts.  Note additinal costs will occur if turned on. See [Storage Advanced threat Protection](https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection) for more details.|

## History

|Date       | Change                |
|-----------|-----------------------|
|20190207 | Inital Version|
|20190220 | Added support for contrainers and advance threat protection|
|20190221 | Fixed validation errors|
|20190221 | Fix issue with storage object that did not contain an optional containerName array. Updated sample parameter file with example of storage object containing an optional containerName.|
|20190302| Transformed the template to be resourcegroup deployed rather than subscription level deployed.|
|20190430 | Updated documentation|
