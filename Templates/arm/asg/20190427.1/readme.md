
# Introduction 
This template will create [Application Security Groups (ASGs)](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/applicationsecuritygroups) that can be used for NIC and Subnet associations.

# Parameter format
```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "ASGArray": {
            "value": [
                {
                    "resourceGroup": "temptest",
                    "applicationSecurityGroupName": "testASG1",
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

# Parameter Values
## Main Template
| Name               | Type   | Required | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------ | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| containerSasToken  | string | No       | SAS Token received as a parameter                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| _artifactsLocation | string | No       | Dynamically derived from the deployment template link uri                                                                                                                                                                                                                                                                                                                                                                                                                      |
| _debugLevel        | string | No       | Specifies the type of information to log for debugging. The permitted values are none, requestContent, responseContent, or both requestContent and responseContent separated by a comma. The default is none. When setting this value, carefully consider the type of information you are passing in during deployment. By logging information about the request or response, you could potentially expose sensitive data that is retrieved through the deployment operations. |
| ASGArray           | array  | Yes      | Array of [Application Security Group object](##Application-Security-Group-object)                                                                                                                                                                                                                                                                                                                                                                                              |

## Application Security Group object
| Name                         | Type   | Required | Value                                                                                                                                                                                                                                                                                          |
| ---------------------------- | ------ | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| resourceGroup                | string | No       | Name of resourcefroup where availabilityset will be deployed. Only needed when doing a subscription level deployment. Not required for resourcegroup based deployment. Leaving the parameter in place in resourcegroup based deployment will not cause any issue as it will be simply ignored. |
| applicationSecurityGroupName | string | Yes      | Name of the Application Security Group                                                                                                                                                                                                                                                         |
| tagValues                    | object | Yes      | An object of tags - [Tag Object](##Tag-Object)                                                                                                                                                                                                                                                 |

## Tag object
| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

# History

| Date         | Change                                                                                                                           |
| ------------ | -------------------------------------------------------------------------------------------------------------------------------- |
| 20181204     | First release of template.                                                                                                       |
| 20181211     | Updating deploy.ps1 to support new Azure subscription and be more flexible by moving variables as parameter with default values. |
| 20181214     | Implementing new template name as template.json                                                                                  |
| 20190205     | Template folder cleanup.                                                                                                         |
| 20190220     | Just a test.                                                                                                                     |
| **20190426** | Updated documentation                                                                                                            |