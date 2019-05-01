# DevTestLabs

## Introduction

This template will create [DevTestLab](https://docs.microsoft.com/en-us/azure/templates/microsoft.devtestlab/2018-09-15/labs).

## Security Controls

The following security controls can be met through configuration of this template:

* None documented yet

## Dependancies

* [Resource Groups](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md)
* [VNET-Subnet](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/vnet-subnet/latest/readme.md)

## Parameter format

```json
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "newLabName": {
      "value": "AzPwS01-Shared-DevTestLab-Client1"
    },
    "labVmShutDownTime": {
      "value": "17:00"
    },
    "timeZoneId": {
      "value": "Eastern Standard Time"
    },
    "maxAllowedVmsPerUser": {
      "value": 6
    },
    "maxAllowedVmsPerLab": {
      "value": 100
    },
    "allowedVmSizes": {
      "value": [
        "Standard_B1S",
        "Standard_B2S"
      ]
    },
    "allowPublicEnvRepo": {
      "value": "Disabled"
    },
    "allowedImages": {
      "value": [
        {
          "offer": "WindowsServer",
          "publisher": "MicrosoftWindowsServer",
          "sku": "2019-Datacenter",
          "osType": "Windows",
          "version": "latest"
        },
        {
          "offer": "UbuntuServer",
          "publisher": "Canonical",
          "sku": "18.04-LTS",
          "osType": "Linux",
          "version": "latest"
        },
        {
          "offer": "WindowsServer",
          "publisher": "MicrosoftWindowsServer",
          "sku": "2016-Datacenter-smalldisk",
          "osType": "Windows",
          "version": "latest"
        }
      ]
    }
  }
}
```

## Parameter Values

### Main Template

| Name                 | Type   | Required | Value                                                                                             |
| -------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------- |
| containerSasToken    | string | No       | SAS Token received as a parameter                                                                 |
| newLabName           | string | Yes      | Name of the lab resource                                                                          |
| labVmShutDownTime    | string | Yes      | Specify the daily recurrence time the schedule will occur once each day of the week (e.g. 17:00). |
| timeZoneId           | string | Yes      | The time zone ID (e.g. Pacific Standard time).                                                    |
| maxAllowedVmsPerUser | string | Yes      | Maximum number of allowed VMs per user                                                            |
| maxAllowedVmsPerLab  | string | Yes      | Maximum number of allowed VMs per lab across all users                                            |
| allowedVmSizes       | array  | Yes      | Array of VM Size as strings                                                                       |
| allowPublicEnvRepo   | string | Yes      | Indicates if the artifact source is enabled (values: Enabled, Disabled). - Enabled or Disabled    |
| allowedImages        | array  | Yes      | Array of [Marketplace Images Object](#marketplace-images-object)                                  |

### Marketplace Images Object

| Name      | Type   | Required | Value                      |
| --------- | ------ | -------- | -------------------------- |
| offer     | string | Yes      | Markerplace offer name     |
| publisher | string | Yes      | Markerplace publisher name |
| sku       | object | Yes      | Markerplace sku name       |
| osType    | string | Yes      | Markerplace os type name   |
| version   | string | Yes      | Markerplace version number |

## History

| Date     | Change                                           |
| -------- | ------------------------------------------------ |
| 20190201 | First release of template.                       |
| 20190430 | Updated documentation                            |
| 20190501 | Update documentation and add validation pipeline |