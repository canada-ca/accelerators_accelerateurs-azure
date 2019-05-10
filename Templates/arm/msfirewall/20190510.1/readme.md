# Microsoft Azure Firewall

## Introduction

This template deploys a [Microsoft Azure Firewall](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/azurefirewalls) resource.

## Security Controls

The following security controls can be met through configuration of this template:

* AC-2, AC-3, AC-4, AC-5, AC-6, AC-8, AU-11, AU-12, AU-2, AU-3, AU-4, AU-8, AU-9, CM-3, CM-6, IA-2, IA-3, IA-5, SA-22, SC-10, SC-12, SC-13, SC-7, SC-8, SI-2, SI-4

## Dependancies

* [Resource Groups](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md)
* [Keyvault](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/keyvaults/latest/readme.md)
* [VNET-Subnet](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/vnet-subnet/latest/readme.md)

## Parameter format

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "msFirewallArray": {
            "value": [
                {
                    "resourceGroup": "PwS2-validate-fmsfirewall-RG",
                    "vnet": "PwS2-validate-msfirewall-VNET",
                    "dnsName": "demo[unique]",
                    "networkRuleCollections": [
                        {
                            "name": "all",
                            "properties": {
                                "provisioningState": "Succeeded",
                                "priority": 100,
                                "action": {
                                    "type": "Allow"
                                },
                                "rules": [
                                    {
                                        "name": "all",
                                        "protocols": [
                                            "Any"
                                        ],
                                        "sourceAddresses": [
                                            "*"
                                        ],
                                        "destinationAddresses": [
                                            "*"
                                        ],
                                        "destinationPorts": [
                                            "*"
                                        ]
                                    }
                                ]
                            }
                        }
                    ],
                    "applicationRuleCollections": [],
                    "natRuleCollections": [
                        {
                            "name": "DNAT",
                            "properties": {
                                "priority": 100,
                                "action": {
                                    "type": "Dnat"
                                },
                                "rules": [
                                    {
                                        "name": "dockerssh",
                                        "protocols": [
                                            "TCP"
                                        ],
                                        "translatedAddress": "10.25.21.68",
                                        "translatedPort": "22",
                                        "sourceAddresses": [
                                            "*"
                                        ],
                                        "destinationAddresses": [
                                            "FWPubIP"
                                        ],
                                        "destinationPorts": [
                                            "22"
                                        ]
                                    },
                                    {
                                        "name": "docker80",
                                        "protocols": [
                                            "TCP"
                                        ],
                                        "translatedAddress": "10.25.21.68",
                                        "translatedPort": "8080",
                                        "sourceAddresses": [
                                            "*"
                                        ],
                                        "destinationAddresses": [
                                            "FWPubIP"
                                        ],
                                        "destinationPorts": [
                                            "80"
                                        ]
                                    },
                                    {
                                        "name": "temp-jumpbox",
                                        "protocols": [
                                            "TCP"
                                        ],
                                        "translatedAddress": "10.25.4.36",
                                        "translatedPort": "3389",
                                        "sourceAddresses": [
                                            "*"
                                        ],
                                        "destinationAddresses": [
                                            "FWPubIP"
                                        ],
                                        "destinationPorts": [
                                            "33890"
                                        ]
                                    },
                                    {
                                        "name": "rdsgateway",
                                        "protocols": [
                                            "TCP"
                                        ],
                                        "translatedAddress": "10.25.4.4",
                                        "translatedPort": "443",
                                        "sourceAddresses": [
                                            "*"
                                        ],
                                        "destinationAddresses": [
                                            "FWPubIP"
                                        ],
                                        "destinationPorts": [
                                            "443"
                                        ]
                                    }
                                ]
                            }
                        }
                    ]
                }
            ]
        }
    }
}
```

## Parameter Values

### Main Template

| Name              | Type   | Required | Value                                                             |
| ----------------- | ------ | -------- | ----------------------------------------------------------------- |
| containerSasToken | string | No       | SAS Token received as a parameter                                 |
| msFirewallArray   | array  | Yes      | Array of [Microsoft Firewall objects](#microsoft-firewall-object) |

### Microsoft Firewall object

| Name                       | Type   | Required | Value                                                                                                                                                          |
| -------------------------- | ------ | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| resourceGroup              | string | Yes      | Name of the resource group containing the VNET that the Azure firewall will attach to.                                                                         |
| vnet                       | string | Yes      | Name of the VNET resource to which the Azure Firewall will connect to.                                                                                         |
| dnsName                    | string | Yes      | Name for the firewall public IP. - [Name format options](#name-format-options)                                                                                 |
| networkRuleCollections     | array  | No       | Collection of network rule collections used by Azure Firewall. - AzureFirewallNetworkRuleCollection object                                                     |
| applicationRuleCollections | array  | No       | Collection of application rule collections used by Azure Firewall. \- [AzureFirewallApplicationRuleCollection object](#AzureFirewallApplicationRuleCollection) |
| natRuleCollections         | array  | No       | Collection of NAT rule collections used by Azure Firewall. \- [AzureFirewallNatRuleCollection object](#AzureFirewallNatRuleCollection)                         |

#### Name Format Options

When specifying the name simply include the token [unique] (including the []) as part of the name. The template will replace the [unique] word with a unique string of characters. For example:

| Name                      | Result                        |
| ------------------------- | ----------------------------- |
| workspace-[unique]-deploy | workspace-sd8kjdf678k9-deploy |
| workspace-test-[unique]   | workspace-test-7djkf90jkdf    |

This is helpfull to ensure there will be duplicates in Azure as it need to be unique.

### AzureFirewallApplicationRuleCollection object

| Name       | Type   | Required | Value                                                                                                                           |
| ---------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------- |
| id         | string | No       | Resource ID.                                                                                                                    |
| properties | object | No       | [AzureFirewallApplicationRuleCollectionPropertiesFormat object](#azurefirewallapplicationrulecollectionpropertiesformat-object) |
| name       | string | No       | Gets name of the resource that is unique within a resource group. This name can be used to access the resource.                 |

### AzureFirewallNatRuleCollection object

| Name       | Type   | Required | Value                                                                                                           |
| ---------- | ------ | -------- | --------------------------------------------------------------------------------------------------------------- |
| id         | string | No       | Resource ID.                                                                                                    |
| properties | object | No       | [AzureFirewallNatRuleCollectionProperties object](#azurefirewallnatrulecollectionproperties-object)             |
| name       | string | No       | Gets name of the resource that is unique within a resource group. This name can be used to access the resource. |

### AzureFirewallNetworkRuleCollection object

| Name       | Type   | Required | Value                                                                                                                   |
| ---------- | ------ | -------- | ----------------------------------------------------------------------------------------------------------------------- |
| id         | string | No       | Resource ID.                                                                                                            |
| properties | object | No       | [AzureFirewallNetworkRuleCollectionPropertiesFormat object](#azurefirewallnetworkrulecollectionpropertiesformat-object) |
| name       | string | No       | Gets name of the resource that is unique within a resource group. This name can be used to access the resource.         |

### AzureFirewallApplicationRuleCollectionPropertiesFormat object

| Name     | Type    | Required | Value                                                                                                                                     |
| -------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------------------- |
| priority | integer | No       | Priority of the application rule collection resource.                                                                                     |
| action   | object  | No       | The action type of a rule collection \- [AzureFirewallRCAction object](#azurefirewallrcaction-object)                                     |
| rules    | array   | No       | Collection of rules used by a application rule collection. \- [AzureFirewallApplicationRule object](#azurefirewallapplicationrule-object) |

### AzureFirewallNatRuleCollectionProperties object

| Name     | Type    | Required | Value                                                                                                             |
| -------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------- |
| priority | integer | No       | Priority of the NAT rule collection resource.                                                                     |
| action   | object  | No       | The action type of a NAT rule collection \- [AzureFirewallNatRCAction object](#azurefirewallnatrcaction-object)   |
| rules    | array   | No       | Collection of rules used by a NAT rule collection. \- [AzureFirewallNatRule object](#azurefirewallnatrule-object) |

### AzureFirewallNetworkRuleCollectionPropertiesFormat object

| Name     | Type    | Required | Value                                                                                                                         |
| -------- | ------- | -------- | ----------------------------------------------------------------------------------------------------------------------------- |
| priority | integer | No       | Priority of the network rule collection resource.                                                                             |
| action   | object  | No       | The action type of a rule collection \- [AzureFirewallRCAction object](#azurefirewallrcaction-object)                         |
| rules    | array   | No       | Collection of rules used by a network rule collection. \- [AzureFirewallNetworkRule object](#azurefirewallnetworkrule-object) |

### AzureFirewallRCAction object

| Name | Type | Required | Value                                |
| ---- | ---- | -------- | ------------------------------------ |
| type | enum | No       | The type of action. \- Allow or Deny |

### AzureFirewallApplicationRule object

| Name            | Type   | Required | Value                                                                                                                             |
| --------------- | ------ | -------- | --------------------------------------------------------------------------------------------------------------------------------- |
| name            | string | No       | Name of the application rule.                                                                                                     |
| description     | string | No       | Description of the rule.                                                                                                          |
| sourceAddresses | array  | No       | List of source IP addresses for this rule. \- string                                                                              |
| protocols       | array  | No       | Array of ApplicationRuleProtocols. \- [AzureFirewallApplicationRuleProtocol object](#azurefirewallapplicationruleprotocol-object) |
| targetFqdns     | array  | No       | List of FQDNs for this rule. \- string                                                                                            |
| fqdnTags        | array  | No       | List of FQDN Tags for this rule. \- string                                                                                        |

### AzureFirewallNatRCAction object

| Name | Type | Required | Value                               |
| ---- | ---- | -------- | ----------------------------------- |
| type | enum | No       | The type of action. \- Snat or Dnat |

### AzureFirewallNatRule object

| Name                 | Type   | Required | Value                                                                                          |
| -------------------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| name                 | string | No       | Name of the NAT rule.                                                                          |
| description          | string | No       | Description of the rule.                                                                       |
| sourceAddresses      | array  | No       | List of source IP addresses for this rule. \- string                                           |
| destinationAddresses | array  | No       | List of destination IP addresses for this rule. \- string                                      |
| destinationPorts     | array  | No       | List of destination ports. \- string                                                           |
| protocols            | array  | No       | Array of AzureFirewallNetworkRuleProtocols applicable to this NAT rule. \- TCP, UDP, Any, ICMP |
| translatedAddress    | string | No       | The translated address for this NAT rule.                                                      |
| translatedPort       | string | No       | The translated port for this NAT rule.                                                         |

### AzureFirewallNetworkRule object

| Name                 | Type   | Required | Value                                                              |
| -------------------- | ------ | -------- | ------------------------------------------------------------------ |
| name                 | string | No       | Name of the network rule.                                          |
| description          | string | No       | Description of the rule.                                           |
| protocols            | array  | No       | Array of AzureFirewallNetworkRuleProtocols. \- TCP, UDP, Any, ICMP |
| sourceAddresses      | array  | No       | List of source IP addresses for this rule. \- string               |
| destinationAddresses | array  | No       | List of destination IP addresses. \- string                        |
| destinationPorts     | array  | No       | List of destination ports. \- string                               |

### AzureFirewallApplicationRuleProtocol object

| Name         | Type    | Required | Value                                                                               |
| ------------ | ------- | -------- | ----------------------------------------------------------------------------------- |
| protocolType | enum    | No       | Protocol type. \- Http or Https                                                     |
| port         | integer | No       | Port number for the protocol, cannot be greater than 64000. This field is optional. |

## History

| Date     | Change                                          |
| -------- | ----------------------------------------------- |
| 20181214 | Implementing new template name as template.json |
| 20190205 | Cleanup template folder                         |
| 20190426 | Add DNS Name for fw.                            |
| 20190502 | Update documentation                            |
