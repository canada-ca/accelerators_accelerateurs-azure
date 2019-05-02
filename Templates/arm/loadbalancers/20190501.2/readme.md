# Loadbalancers

## Introduction

This template deploys a [loadbalancers resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/loadbalancers).

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
        "loadbalancersArray": {
            "value": [
                {
                    "name": "testlb1",
                    "sku": "Basic",
                    "publicIPAddressName": "testlb-PubIP",
                    "publicIPAddressesProperties": {
                        "publicIPAllocationMethod": "Static",
                        "publicIPAddressVersion": "IPv4"
                    },
                    "inboundNatRules": [
                        {
                            "name": "testlb1_ADFS_443",
                            "properties": {
                                "frontendIPConfiguration": {},
                                "frontendPort": 443,
                                "backendPort": 445,
                                "enableFloatingIP": false,
                                "idleTimeoutInMinutes": 4,
                                "protocol": "Tcp",
                                "enableTcpReset": false
                            }
                        },
                        {
                            "name": "testlb1_UDP_444",
                            "properties": {
                                "frontendIPConfiguration": {},
                                "frontendPort": 444,
                                "backendPort": 446,
                                "protocol": "Udp"
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

| Name               | Type   | Required | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
| ------------------ | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| containerSasToken  | string | No       | SAS Token received as a parameter                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| _artifactsLocation | string | No       | Dynamically derived from the deployment template link uri                                                                                                                                                                                                                                                                                                                                                                                                                      |
| _debugLevel        | string | No       | Specifies the type of information to log for debugging. The permitted values are none, requestContent, responseContent, or both requestContent and responseContent separated by a comma. The default is none. When setting this value, carefully consider the type of information you are passing in during deployment. By logging information about the request or response, you could potentially expose sensitive data that is retrieved through the deployment operations. |
| loadbalancersArray | array  | Yes      | Array of [loadbalancers objects](#loadbalancers-object)                                                                                                                                                                                                                                                                                                                                                                                                                        |

### loadbalancers Object

| Name                        | Type   | Required | Value                                                                                                              |
| --------------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------ |
| name                        | string | Yes      | Desired name of loadbalancers resource                                                                             |
| sku                         | string | Yes      | The load balancer SKU. - [LoadBalancerSku object](#loadbalancersku-object)                                         |
| publicIPAddressName         | string | Yes      | Name for the public IP of the loadbalancers                                                                        |
| publicIPAddressesProperties | object | Yes      | Public IP address properties. \- [PublicIPAddressPropertiesFormat object](#publicipaddresspropertiesformat-object) |
| inboundNatRules             | array  | Yes      | Properties of load balancer inbound nat rule. - [InboundNatRuleFormat object](#inboundnatruleformat-object)        |  |
| tagValues                   | object | Yes      | An object of tags - [Tag Object](#tag-object)                                                                      |

### LoadBalancerSku object

| Name | Type | Required | Value                                             |
| ---- | ---- | -------- | ------------------------------------------------- |
| name | enum | Yes      | Name of a load balancer SKU. \- Basic or Standard |

### PublicIPAddressPropertiesFormat object

| Name                     | Type    | Required | Value                                                                                                                                        |
| ------------------------ | ------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------- |
| publicIPAllocationMethod | enum    | No       | The public IP allocation method. Possible values are: 'Static' and 'Dynamic'. \- Static or Dynamic                                           |
| publicIPAddressVersion   | enum    | No       | The public IP address version. Possible values are: 'IPv4' and 'IPv6'. \- IPv4 or IPv6                                                       |
| dnsSettings              | object  | No       | The FQDN of the DNS record associated with the public IP address. \- [PublicIPAddressDnsSettings object](#publicipaddressdnssettings-object) |
| ddosSettings             | object  | No       | The DDoS protection custom policy associated with the public IP address. \- [DdosSettings object](#ddossettings-object)                      |
| ipTags                   | array   | No       | The list of tags associated with the public IP address. \- [IpTag object](#iptag-object)                                                     |
| ipAddress                | string  | No       | The IP address associated with the public IP address resource.                                                                               |
| publicIPPrefix           | object  | No       | The Public IP Prefix this Public IP Address should be allocated from. \- [SubResource object](#subresource-object-object)                    |
| idleTimeoutInMinutes     | integer | No       | The idle timeout of the public IP address.                                                                                                   |
| resourceGuid             | string  | No       | The resource GUID property of the public IP resource.                                                                                        |

### PublicIPAddressDnsSettings object

| Name            | Type   | Required | Value                                                                                                                                                                                                                                                                                                           |
| --------------- | ------ | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| domainNameLabel | string | No       | Gets or sets the Domain name label.The concatenation of the domain name label and the regionalized DNS zone make up the fully qualified domain name associated with the public IP address. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system. |
| fqdn            | string | No       | Gets the FQDN, Fully qualified domain name of the A DNS record associated with the public IP. This is the concatenation of the domainNameLabel and the regionalized DNS zone.                                                                                                                                   |
| reverseFqdn     | string | No       | Gets or Sets the Reverse FQDN. A user\-visible, fully qualified domain name that resolves to this public IP address. If the reverseFqdn is specified, then a PTR DNS record is created pointing from the IP address in the in\-addr.arpa domain to the reverse FQDN.                                            |

### DdosSettings object

| Name               | Type   | Required | Value                                                                                                                                            |
| ------------------ | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------ |
| ddosCustomPolicy   | object | No       | The DDoS custom policy associated with the public IP. \- [SubResource object](#subresource-object)                                               |
| protectionCoverage | enum   | No       | The DDoS protection policy customizability of the public IP. Only standard coverage will have the ability to be customized. \- Basic or Standard |

### IpTag object

| Name      | Type   | Required | Value                                                                                   |
| --------- | ------ | -------- | --------------------------------------------------------------------------------------- |
| ipTagType | string | No       | Gets or sets the ipTag type: Example FirstPartyUsage.                                   |
| tag       | string | No       | Gets or sets value of the IpTag associated with the public IP. Example SQL, Storage etc |

### InboundNatRuleFormat object

| Name       | Type   | Required | Value                                                                                                                        |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------------------------------------- |
| name       | string | Yes      | Name of the public IP of the load balancers                                                                                  |
| properties | object | Yes      | The object containing nat rules properties - [InboundNatRulePropertiesFormat object](#inboundnatrulepropertiesformat-object) |

### InboundNatRulePropertiesFormat object

| Name                    | Type    | Required | Value                                                                                                                                                                                                                                                                                |
| ----------------------- | ------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| frontendIPConfiguration | object  | Yes      | MUST be present and equal exactly to: "frontendIPConfiguration": {},                                                                                                                                                                                                                         |
| protocol                | enum    | No       | Udp, Tcp, All                                                                                                                                                                                                                                                                        |
| frontendPort            | integer | No       | The port for the external endpoint. Port numbers for each rule must be unique within the Load Balancer. Acceptable values range from 1 to 65534.                                                                                                                                     |
| backendPort             | integer | No       | The port used for the internal endpoint. Acceptable values range from 1 to 65535.                                                                                                                                                                                                    |
| idleTimeoutInMinutes    | integer | No       | The timeout for the TCP idle connection. The value can be set between 4 and 30 minutes. The default value is 4 minutes. This element is only used when the protocol is set to TCP.                                                                                                   |
| enableFloatingIP        | boolean | No       | Configures a virtual machine's endpoint for the floating IP capability required to configure a SQL AlwaysOn Availability Group. This setting is required when using the SQL AlwaysOn Availability Groups in SQL server. This setting can't be changed after you create the endpoint. |
| enableTcpReset          | boolean | No       | Receive bidirectional TCP Reset on TCP flow idle timeout or unexpected connection termination. This element is only used when the protocol is set to TCP.                                                                                                                            |

### SubResource object

| Name | Type   | Required | Value        |
| ---- | ------ | -------- | ------------ |
| id   | string | No       | Resource ID. |

### Tag object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

## History

| Date     | Change        |
| -------- | ------------- |
| 20190309 | 1st commit    |
| 20190501 | Update readme |