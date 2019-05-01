# Virtual Netowkrs

## Introduction

This template is used to deploy [virtual networks](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-07-01/virtualnetworks) and associated [subnets](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-07-01/virtualnetworks/subnets).

## Parameter format

```JSON
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "vnetArray": {
            "value": [
                {
                    "resourceGroup": "Demo-Servers-RG",
                    "name": "Demo-Servers-VNET",
                    "addressPrefixes": [
                        "10.96.96.0/24"
                    ],
                    "subnets": [
                        {
                            "name": "subnet1",
                            "properties": {
                                "addressPrefix": "10.96.96.0/25"
                            }
                        },
                        {
                            "name": "subnet2",
                            "properties": {
                                "addressPrefix": "10.96.96.0/25",
                                "networkSecurityGroupName": "networkSecurityGroups_TestShared_name"
                            }
                        }
                    ],
                    "tagValues": {
                        "Owner": "build.pipeline@tpsgc-pwgsc.gc.ca",
                        "CostCenter": "PSPC-EA",
                        "Enviroment": "Validate",
                        "Classification": "Unclassified",
                        "Organizations": "PSPC-CCC",
                        "DeploymentVersion": "2018-12-13-01"
                    }
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
|_artifactsLocation |string |No      |The base URI where artifacts required by this template are located including a trailing '/' |
|_debugLevel |string|No | [Debug Setting](###debug-setting)|
|vnetArray| array |Yes| The array of Vnets to create - [vnetArray](###vnet-array)|
|dhcpOptions| object|No|Used to configure custom DNSs for the VNet served through DHCP to VMs when they are created.  - [dnsServers Object](###dnsservers-object)|

### Debug Settings

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|detailLevel |string |Yes      |Specifies the type of information to log for debugging. The permitted values are none, requestContent, responseContent, or both requestContent and responseContent separated by a comma. The default is none. When setting this value, carefully consider the type of information you are passing in during deployment. By logging information about the request or response, you could potentially expose sensitive data that is retrieved through the deployment operations.|

### vnetArray Object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|resourceGroup |string |Yes      | The resource group for the vnet  |
|name| string |Yes| The name to use for the vnet. |
|addressPrefixes| string |Yes| String array of address spaces for the vnet.|
|subnets| array |Yes| Array of subnets for the vnet. - [Subnet Object](###subnet-object)  |


### Subnet Object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name |string |Yes      | The name of the subet  |
|properties| Yes| Object | Properties for the subnet - [Subnet Properties Format Object](###subnet-properties-format-object)

### Subet Properties Format Object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|addressPrefix |string |Yes      | The name of the subet.  |
|routeTableName |string |No      | The name of the routeTable to use.  |
|networkSecurityGroupName |string |No      |The name of the NetworkSecurityGroup to use.  |

### dnsServers Object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|dnsServers |array |Yes      | String Array of DNS entries |

## History

|Date       | Change |
|-----------|-----------------------|
|20181120 | Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template.
|20181214 | Implementing new template name as template.json |
|20190205 | Cleanup template folder
|20190302 | Cleanup template folder
|20190205 | Transformed the template to be resourcegroup deployed rather than subscription level deployed.
|20190313 |  Adding support for subnet NSG as an option.
