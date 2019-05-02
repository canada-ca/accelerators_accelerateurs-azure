# Network Security Groups (NSG)

## Introduction

This template deploys a [Network Security Groups resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/networksecuritygroups).

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
        "NSGArray": {
            "value": [
                {
                    "resourceGroup": "Demo-Infra-NetShared-RG",
                    "networkSecurityGroupName": "Demo-Infra-NetShared-PAZ-Sandbox-NSG",
                    "securityRules": [
                        {
                            "name": "https443",
                            "properties": {
                                "protocol": "TCP",
                                "sourcePortRange": "*",
                                "destinationPortRange": "443",
                                "sourceAddressPrefix": "*",
                                "destinationAddressPrefix": "*",
                                "access": "Allow",
                                "priority": 1000,
                                "direction": "Inbound",
                                "sourcePortRanges": [],
                                "destinationPortRanges": [],
                                "sourceAddressPrefixes": [],
                                "destinationAddressPrefixes": []
                            }
                        },
                        {
                            "name": "DenyAll",
                            "properties": {
                                "protocol": "*",
                                "sourcePortRange": "*",
                                "destinationPortRange": "*",
                                "sourceAddressPrefix": "*",
                                "destinationAddressPrefix": "*",
                                "access": "Deny",
                                "priority": 4096,
                                "direction": "Inbound",
                                "sourcePortRanges": [],
                                "destinationPortRanges": [],
                                "sourceAddressPrefixes": [],
                                "destinationAddressPrefixes": []
                            }
                        }
                    ],
                    "tagValues": {
                        "compositeApp": "NA",
                        "businessOwner": "PSPC-CCC",
                        "costCenter": "PSPC-EA",
                        "deploymentStage": "Sandbox",
                        "vmWorkload": "Test",
                        "vmRole": "Testing",
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
| NSGArray           | array  | Yes      | Array of [NSG objects](#nsg-object)                                                                                                                                                                                                                                                                                                                                                                                                                                            |

### NSG Object

| Name                     | Type   | Required | Value                                                                                                          |
| ------------------------ | ------ | -------- | -------------------------------------------------------------------------------------------------------------- |
| resourceGroup            | string | No       | Name of the resource group that will contain the NSG resource. Only required for subscription level deployment |
| networkSecurityGroupName | string | Yes      | Name of the NSG                                                                                                |
| securityRules            | array  | Yes      | Properties of the NSG. - [Security Rule object](#security-rule-object)                                         |  |
| tagValues                | object | Yes      | An object of tags - [Tag Object](#tag-object)                                                                  |

### Security Rule object

| Name       | Type   | Required | Value                                                                                                          |
| ---------- | ------ | -------- | -------------------------------------------------------------------------------------------------------------- |
| id         | string | No       | Resource ID.                                                                                                   |
| properties | object | Yes      | Properties of the security rule \- [SecurityRulePropertiesFormat object](#securityrulepropertiesformat-object) |
| name       | string | Yes      | The name of the resource that is unique within a resource group. This name can be used to access the resource. |

### SecurityRulePropertiesFormat object

| Name                                 | Type    | Required | Value                                                                                                                                                                                                                                                          |
| ------------------------------------ | ------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| description                          | string  | No       | A description for this rule. Restricted to 140 chars.                                                                                                                                                                                                          |
| protocol                             | enum    | Yes      | Network protocol this rule applies to. Possible values are 'Tcp', 'Udp', and '\*'. \- Tcp, Udp, \*                                                                                                                                                             |
| sourcePortRange                      | string  | No       | The source port or range. Integer or range between 0 and 65535. Asterisks '\*' can also be used to match all ports.                                                                                                                                            |
| destinationPortRange                 | string  | No       | The destination port or range. Integer or range between 0 and 65535. Asterisks '\*' can also be used to match all ports.                                                                                                                                       |
| sourceAddressPrefix                  | string  | No       | The CIDR or source IP range. Asterisks '\*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| sourceAddressPrefixes                | array   | No       | The CIDR or source IP ranges. \- string                                                                                                                                                                                                                        |
| sourceApplicationSecurityGroups      | array   | No       | The application security group specified as source. \- [ApplicationSecurityGroup object](#applicationsecuritygroup-object)                                                                                                                                     |
| destinationAddressPrefix             | string  | No       | The destination address prefix. CIDR or destination IP range. Asterisks '\*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used.                                             |
| destinationAddressPrefixes           | array   | No       | The destination address prefixes. CIDR or destination IP ranges. \- string                                                                                                                                                                                     |
| destinationApplicationSecurityGroups | array   | No       | The application security group specified as destination. \- [ApplicationSecurityGroup object](#applicationsecuritygroup-object)                                                                                                                                |
| sourcePortRanges                     | array   | No       | The source port ranges. \- string                                                                                                                                                                                                                              |
| destinationPortRanges                | array   | No       | The destination port ranges. \- string                                                                                                                                                                                                                         |
| access                               | enum    | Yes      | The network traffic is allowed or denied. Possible values are: 'Allow' and 'Deny'. \- Allow or Deny                                                                                                                                                            |
| priority                             | integer | No       | The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.                                                       |
| direction                            | enum    | Yes      | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are: 'Inbound' and 'Outbound'. \- Inbound or Outbound                                                                            |

### ApplicationSecurityGroup object

| Name       | Type   | Required | Value                                                                                                                                                |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------- |
| id         | string | No       | Resource ID.                                                                                                                                         |
| location   | string | No       | Resource location.                                                                                                                                   |
| tags       | object | No       | Resource tags.                                                                                                                                       |
| properties | object | No       | Properties of the application security group. \- [ApplicationSecurityGroupPropertiesFormat object](#applicationsecuritygrouppropertiesformat-object) |

### Tag object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

## History

| Date     | Change                                                                                                                           |
| -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| 20181204 | First release of template.                                                                                                       |
| 20181211 | Updating deploy.ps1 to support new Azure subscription and be more flexible by moving variables as parameter with default values. |
| 20181214 | Implementing new template name as template.json                                                                                  |
| 20190205 | Cleanup template folder                                                                                                          |
| 20190502 | Update readme                                                                                                                    |