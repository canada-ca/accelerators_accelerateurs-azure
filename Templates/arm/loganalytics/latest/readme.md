# Log Analytics Workspace

## Introduction

This template deploys a [Operational Insights Workspace resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.operationalinsights/2015-11-01-preview/workspaces).

## Security Controls

The following security controls can be met through configuration of this template:

* None documented yet

## Dependancies

* [Resource Groups](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md)

## Parameter format

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "resourceGroup": {
            "value": "someRG"
        },
        "workspaceName": {
            "value": "workspace-[unique]"
        },
        "data-retention": {
            "value": 180
        },
        "sku": {
            "value": "PerGB2018"
        }
    }
}
```

## Parameter Values

### Main Template

| Name               | Type    | Required | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------ | ------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| containerSasToken  | string  | No       | SAS Token received as a parameter                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| _artifactsLocation | string  | No       | Dynamically derived from the deployment template link uri                                                                                                                                                                                                                                                                                                                                                                                                                      |
| _debugLevel        | string  | No       | Specifies the type of information to log for debugging. The permitted values are none, requestContent, responseContent, or both requestContent and responseContent separated by a comma. The default is none. When setting this value, carefully consider the type of information you are passing in during deployment. By logging information about the request or response, you could potentially expose sensitive data that is retrieved through the deployment operations. |
| resourceGroup      | string  | No       | Specifies the name of the resourcegroup.                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| workspaceName      | string  | Yes      | Desired name of workspace resource - [Name format options](#name-format-options)                                                                                                                                                                                                                                                                                                                                                                                               |
| data-retention     | integer | Yes      | The workspace data retention in days. -1 means Unlimited retention for the Unlimited Sku. 730 days is the maximum allowed for all other Skus.                                                                                                                                                                                                                                                                                                                                  |
| sku                | string  | Yes      | The name of the SKU. - Free, Standard, Premium, Unlimited, PerNode, PerGB2018, Standalone                                                                                                                                                                                                                                                                                                                                                                                      |

#### Name Format Options

When specifying the name of a workspace simply include the token [unique] (including the []) as part of the name. The template will replace the [unique] word with a unique string of characters. For example:

| Name                      | Result                        |
| ------------------------- | ----------------------------- |
| workspace-[unique]-deploy | workspace-sd8kjdf678k9-deploy |
| workspace-test-[unique]   | workspace-test-7djkf90jkdf    |

This is helpfull to ensure there will be no workspace duplicates in Azure as it need to be unique.

## History

| Date     | Change                                                                                                       |
| -------- | ------------------------------------------------------------------------------------------------------------ |
| 20181214 | Implementing new template name as template.json                                                              |
| 20190205 | Cleanup template folder                                                                                      |
| 20190226 | Add the ability to use a special token ([unique]) in the workspace name to ensure workspace name uniqueness. |
| 20190301 | Transformed the template to be resourcegroup deployed rather than subscription level deployed.               |
| 20190502 | Update readme                                                                                                |