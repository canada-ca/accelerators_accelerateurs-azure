# DNS

## Introduction

This template deploys [DNS records](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-05-01/dnszones).

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
        "DNSRecords": {
            "value": [
                {
                    "resourceGroup": "rgDNS",
                    "dnsZoneName": "demo.lab.com",
                    "ARecords": [
                        {
                            "name": "mgmt",
                            "properties": {
                                "TTL": 60,
                                "ARecords": [
                                    {
                                        "ipv4Address": "13.88.227.200"
                                    },
                                    {
                                        "ipv4Address": "2.2.2.2"
                                    }
                                ],
                                "targetResource": {}
                            }
                        },
                        {
                            "name": "mgmtin",
                            "properties": {
                                "TTL": 120,
                                "ARecords": [
                                    {
                                        "ipv4Address": "10.250.3.4"
                                    }
                                ],
                                "targetResource": {}
                            }
                        }
                    ],
                    "CNAMERecords": [
                        {
                            "name": "mgmtC",
                            "properties": {
                                "TTL": 60,
                                "CNAMERecord": {
                                    "cname": "mgmt.pspc.ducourier.com"
                                },
                                "targetResource": {}
                            }
                        },
                        {
                            "name": "mgmtinc",
                            "properties": {
                                "TTL": 120,
                                "CNAMERecord": {
                                    "cname": "mgmtin.pspc.ducourier.com"
                                },
                                "targetResource": {}
                            }
                        }
                    ],
                    "AAAARecords": [
                        {
                            "name": "ipV61",
                            "properties": {
                                "TTL": 3600,
                                "AAAARecords": [
                                    {
                                        "ipv6Address": "fe80:cd00:0:cde:1257:0:211e:729c"
                                    },
                                    {
                                        "ipv6Address": "fe80:cd00:0:cde:1257:0:211e:729d"
                                    }
                                ],
                                "targetResource": {}
                            }
                        }
                    ],
                    "MXRecords": [
                        {
                            "name": "testMX",
                            "properties": {
                                "TTL": 3600,
                                "MXRecords": [
                                    {
                                        "exchange": "mail.test.com",
                                        "preference": 5
                                    },
                                    {
                                        "exchange": "mail2.test.com",
                                        "preference": 10
                                    }
                                ],
                                "targetResource": {}
                            }
                        }
                    ],
                    "NSRecords": [
                        {
                            "name": "testNS",
                            "properties": {
                                "TTL": 3600,
                                "NSRecords": [
                                    {
                                        "nsdname": "ns1.test.com"
                                    },
                                    {
                                        "nsdname": "ns2.test.com"
                                    }
                                ],
                                "targetResource": {}
                            }
                        }
                    ],
                    "SRVRecords": [
                        {
                            "name": "_ldap._tcp._msdcs",
                            "properties": {
                                "TTL": 3600,
                                "SRVRecords": [
                                    {
                                        "port": 389,
                                        "priority": 0,
                                        "target": "bigbox.example.com",
                                        "weight": 100
                                    },
                                    {
                                        "port": 389,
                                        "priority": 2,
                                        "target": "bigbox2.example.com",
                                        "weight": 101
                                    }
                                ],
                                "targetResource": {}
                            }
                        }
                    ],
                    "TXTRecords": [
                        {
                            "name": "testTXT",
                            "properties": {
                                "TTL": 3600,
                                "TXTRecords": [
                                    {
                                        "value": [
                                            "This is a test TXT DNS Record value"
                                        ]
                                    },
                                    {
                                        "value": [
                                            "This is another TXT record value"
                                        ]
                                    }
                                ],
                                "targetResource": {}
                            }
                        }
                    ],
                    "PTRRecords": [
                        {
                            "name": "testPTR",
                            "properties": {
                                "TTL": 3600,
                                "PTRRecords": [
                                    {
                                        "ptrdname": "test.com"
                                    },
                                    {
                                        "ptrdname": "test2.com"
                                    }
                                ],
                                "targetResource": {}
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

| Name               | Type   | Required | Value                                                     |
| ------------------ | ------ | -------- | --------------------------------------------------------- |
| containerSasToken  | string | No       | SAS Token received as a parameter                         |
| _artifactsLocation | string | No       | Dynamically derived from the deployment template link uri |
| DNSRecords         | array  | Yes      | Array of [DNS Zone Objects](###dns-zone)                  |

### DNS Zone Object

| Name          | Type   | Required | Value                                                                                                         |
| ------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------- |
| resourceGroup | string | No       | Name of resource group where DNS Zone records are stored. Only required when deploying at subscription level. |
| dnsZoneName   | string | Yes      | Name of the dns zone                                                                                          |
| ARecords      | array  | No       | Array of [ARecords objects](#arecords-properties-object)                                                      |
| CNAMERecords  | array  | No       | Array of [CNAMERecords objects](#cnamerecords-properties-object)                                              |
| AAAARecords   | array  | No       | Array of [AAAARecords objects](#aaaarecords-properties-object)                                                |
| MXRecords     | array  | No       | Array of [MXRecords objects](#mxrecords-properties-object)                                                    |
| NSRecords     | array  | No       | Array of [NSRecords objects](#nsrecords-properties-object)                                                    |
| PTRRecords    | array  | No       | Array of [PTRRecords objects](#ptrrecords-properties-object)                                                  |
| SRVRecords    | array  | No       | Array of [SRVRecords objects](#srvrecords-properties-object)                                                  |
| TXTRecords    | array  | No       | Array of [TXTRecords objects](#txtrecords-properties-object)                                                  |

#### ARecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| Name       | string | Yes      | Name of A record                                                                               |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

#### CNAMERecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| Name       | string | Yes      | Name of CNAME record                                                                           |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

#### AAAARecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| Name       | string | Yes      | Name of AAAA record                                                                            |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

#### MXRecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| Name       | string | Yes      | Name of MX record                                                                              |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

#### NSRecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| Name       | string | Yes      | Name of NS record                                                                              |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

#### PTRRecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| Name       | string | Yes      | Name of PTR record                                                                             |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

#### SRVRecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| Name       | string | Yes      | Name of SRV record                                                                             |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

#### TXTRecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| Name       | string | Yes      | Name of TXT record                                                                             |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

##### RecordSetProperties object

| Name        | Type    | Required | Value                                                                                  |
| ----------- | ------- | -------- | -------------------------------------------------------------------------------------- |
| metadata    | object  | No       | The metadata attached to the record set.                                               |
| TTL         | integer | No       | The TTL (time\-to\-live) of the records in the record set.                             |
| ARecords    | array   | No       | The list of A records in the record set. \- [ARecord object](#arecord-object)          |
| AAAARecords | array   | No       | The list of AAAA records in the record set. \- [AaaaRecord object](#AaaaRecord-object) |
| MXRecords   | array   | No       | The list of MX records in the record set. \- [MxRecord object](#MxRecord-object)       |
| NSRecords   | array   | No       | The list of NS records in the record set. \- [NsRecord object](#NsRecord-object)       |
| PTRRecords  | array   | No       | The list of PTR records in the record set. \- [PtrRecord object](#PtrRecord-object)    |
| SRVRecords  | array   | No       | The list of SRV records in the record set. \- [SrvRecord object](#SrvRecord-object)    |
| TXTRecords  | array   | No       | The list of TXT records in the record set. \- [TxtRecord object](#TxtRecord-object)    |
| CNAMERecord | object  | No       | The CNAME record in the record set. \- [CnameRecord object](#CnameRecord-object)       |

###### ARecord object

| Name        | Type   | Required | Value                              |
| ----------- | ------ | -------- | ---------------------------------- |
| ipv4Address | string | No       | The IPv4 address of this A record. |

###### AAAARecord object

| Name        | Type   | Required | Value                                 |
| ----------- | ------ | -------- | ------------------------------------- |
| ipv6Address | string | No       | The IPv6 address of this AAAA record. |

###### MXRecord object

| Name       | Type    | Required | Value                                                |
| ---------- | ------- | -------- | ---------------------------------------------------- |
| preference | integer | No       | The preference value for this MX record.             |
| exchange   | string  | No       | The domain name of the mail host for this MX record. |

###### NSRecord object

| Name    | Type   | Required | Value                                    |
| ------- | ------ | -------- | ---------------------------------------- |
| nsdname | string | No       | The name server name for this NS record. |

###### PTRRecord object

| Name     | Type   | Required | Value                                           |
| -------- | ------ | -------- | ----------------------------------------------- |
| ptrdname | string | No       | The PTR target domain name for this PTR record. |

###### SRVRecord object

| Name     | Type    | Required | Value                                       |
| -------- | ------- | -------- | ------------------------------------------- |
| priority | integer | No       | The priority value for this SRV record.     |
| weight   | integer | No       | The weight value for this SRV record.       |
| port     | integer | No       | The port value for this SRV record.         |
| target   | string  | No       | The target domain name for this SRV record. |

###### TXTRecord object

| Name  | Type  | Required | Value                                        |
| ----- | ----- | -------- | -------------------------------------------- |
| value | array | No       | The text value of this TXT record. \- string |

###### CNAMERecord object

| Name  | Type   | Required | Value                                     |
| ----- | ------ | -------- | ----------------------------------------- |
| cname | string | No       | The canonical name for this CNAME record. |

## History

| Date     | Change                                                                                                                           |
| -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| 20181211 | Updating deploy.ps1 to support new Azure subscription and be more flexible by moving variables as parameter with default values. |
| 20181214 | Implementing new template name as template.json                                                                                  |
| 20190205 | Cleanup template folder                                                                                                          |
| 20190430 | Updated documentation and cleanup parameters                                                                                     |
| 20190501 | Updated documentation and add remaining type of DNS records                                                                      |