# Routes

## Introduction

This template deploys a [routetables resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/routetables).

## Security Controls

The following security controls can be met through configuration of this template:

* Need update

## Dependancies

* [Resource Groups](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md)

## Parameter format

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "routeTables": {
            "value": [
                {
                    "name": "test1-RT",
                    "properties": {
                        "disableBgpRoutePropagation": false,
                        "routes": [
                            {
                                "name": "mgmt",
                                "properties": {
                                    "addressPrefix": "10.250.0.0/20",
                                    "nextHopType": "VirtualAppliance",
                                    "nextHopIpAddress": "100.96.96.132"
                                }
                            },
                            {
                                "name": "Shared",
                                "properties": {
                                    "addressPrefix": "10.250.16.0/20",
                                    "nextHopType": "VirtualAppliance",
                                    "nextHopIpAddress": "100.96.96.132"
                                }
                            }
                        ]
                    },
                    "tagValues": {
                        "Owner": "build.pipeline@tpsgc-pwgsc.gc.ca",
                        "CostCenter": "PSPC-EA",
                        "Enviroment": "Sandbox",
                        "Classification": "Unclassified",
                        "Organizations": "PSPC-CCC-E&O",
                        "DeploymentVersion": "2019-01-09-05"
                    }
                },
                {
                    "name": "test2-RT",
                    "properties": {
                        "disableBgpRoutePropagation": false,
                        "routes": [
                            {
                                "name": "mgmtVnet",
                                "properties": {
                                    "addressPrefix": "10.250.0.0/20",
                                    "nextHopType": "VirtualAppliance",
                                    "nextHopIpAddress": "10.250.0.4"
                                }
                            }
                        ]
                    },
                    "tagValues": {
                        "Owner": "build.pipeline@tpsgc-pwgsc.gc.ca",
                        "CostCenter": "PSPC-EA",
                        "Enviroment": "Validate",
                        "Classification": "Unclassified",
                        "Organizations": "PSPC-CCC-E&O",
                        "DeploymentVersion": "2019-01-09-04"
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
| routeTables        | array  | Yes      | Array of [routes objects](#routes-object)                                                                                                                                                                                                                                                                                                                                                                                                                                      |

### Routes object

| Name       | Type   | Required | Value                                                                      |
| ---------- | ------ | -------- | -------------------------------------------------------------------------- |
| name       | string | Yes      | Name of the routetables resource                                           |
| properties | object | Yes      | Object containing [route table properties](#route-table-properties-object) |

#### Route Table Properties object

| Name                       | Type    | Required | Value                                                                                              |
| -------------------------- | ------- | -------- | -------------------------------------------------------------------------------------------------- |
| disableBgpRoutePropagation | boolean | Yes      | Gets or sets whether to disable the routes learned by BGP on that route table. True means disable. |
| routes                     | array   | Yes      | Collection of routes contained within a route table. - Route object                                |

#### Route Table Properties Routes object

| Name       | Type   | Required | Value                                                                                                          |
| ---------- | ------ | -------- | -------------------------------------------------------------------------------------------------------------- |
| id         | string | No       | Resource ID.                                                                                                   |
| properties | object | Yes      | Properties of the route. \- [RoutePropertiesFormat object](#routepropertiesformat)                             |
| name       | string | Yes      | The name of the resource that is unique within a resource group. This name can be used to access the resource. |

### RoutePropertiesFormat object

| Name             | Type   | Required | Value                                                                                                                                                                                                                            |
| ---------------- | ------ | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| addressPrefix    | string | No       | The destination CIDR to which the route applies.                                                                                                                                                                                 |
| nextHopType      | enum   | Yes      | The type of Azure hop the packet should be sent to. Possible values are: 'VirtualNetworkGateway', 'VnetLocal', 'Internet', 'VirtualAppliance', and 'None'. \- VirtualNetworkGateway, VnetLocal, Internet, VirtualAppliance, None |
| nextHopIpAddress | string | No       | The IP address packets should be forwarded to. Next hop values are only allowed in routes where the next hop type is VirtualAppliance.                                                                                           |

## History

| Date     | Change                                                                                                                     |
| -------- | -------------------------------------------------------------------------------------------------------------------------- |
| 20181120 | Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template. |
| 20181214 | Implementing new template name as template.json                                                                            |
| 20190205 | Cleanup template folder                                                                                                    |
| 20190301 | Transformed the template to be resourcegroup deployed rather than subscription level deployed.                             |
| 20190506 | Update documentation                                                                                                       |