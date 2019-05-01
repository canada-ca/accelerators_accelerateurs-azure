# DNS

## Introduction

This template deploys [DNS records](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-05-01/dnszones).

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
| ARecords      | array  | Yes      | Array of [ARecords objects](#arecords-properties-object)                                                      |
| CNAMERecords  | array  | Yes      | Array of [CNAMERecords objects](#cnamerecords-properties-object)                                              |

#### ARecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

#### CNAMERecords Properties Object

| Name       | Type   | Required | Value                                                                                          |
| ---------- | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| properties | object | Yes      | The properties of the record set. \- [RecordSetProperties object](#recordsetproperties-object) |

##### RecordSetProperties object

| Name           | Type    | Required | Value                                                                                                                     |
| -------------- | ------- | -------- | ------------------------------------------------------------------------------------------------------------------------- |
| metadata       | object  | No       | The metadata attached to the record set.                                                                                  |
| TTL            | integer | No       | The TTL (time\-to\-live) of the records in the record set.                                                                |
| targetResource | object  | No       | A reference to an azure resource from where the dns resource value is taken. \- [SubResource object](#subresource-object) |
| ARecords       | array   | No       | The list of A records in the record set. \- [ARecord object](#arecord-object)                                             |
| AAAARecords    | array   | No       | The list of AAAA records in the record set. \- [AaaaRecord object](#AaaaRecord-object)                                    |
| MXRecords      | array   | No       | The list of MX records in the record set. \- [MxRecord object](#MxRecord-object)                                          |
| NSRecords      | array   | No       | The list of NS records in the record set. \- [NsRecord object](#NsRecord-object)                                          |
| PTRRecords     | array   | No       | The list of PTR records in the record set. \- [PtrRecord object](#PtrRecord-object)                                       |
| SRVRecords     | array   | No       | The list of SRV records in the record set. \- [SrvRecord object](#SrvRecord-object)                                       |
| TXTRecords     | array   | No       | The list of TXT records in the record set. \- [TxtRecord object](#TxtRecord-object)                                       |
| CNAMERecord    | object  | No       | The CNAME record in the record set. \- [CnameRecord object](#CnameRecord-object)                                          |
| SOARecord      | object  | No       | The SOA record in the record set. \- [SoaRecord object](#SoaRecord-object)                                                |
| caaRecords     | array   | No       | The list of CAA records in the record set. \- [CaaRecord object](#CaaRecord-object)                                       |

###### SubResource object

| Name | Type   | Required | Value        |
| ---- | ------ | -------- | ------------ |
| id   | string | No       | Resource Id. |

###### ARecord object

| Name        | Type   | Required | Value                              |
| ----------- | ------ | -------- | ---------------------------------- |
| ipv4Address | string | No       | The IPv4 address of this A record. |

###### AaaaRecord object

| Name        | Type   | Required | Value                                 |
| ----------- | ------ | -------- | ------------------------------------- |
| ipv6Address | string | No       | The IPv6 address of this AAAA record. |

###### MxRecord object

| Name       | Type    | Required | Value                                                |
| ---------- | ------- | -------- | ---------------------------------------------------- |
| preference | integer | No       | The preference value for this MX record.             |
| exchange   | string  | No       | The domain name of the mail host for this MX record. |

###### NsRecord object

| Name    | Type   | Required | Value                                    |
| ------- | ------ | -------- | ---------------------------------------- |
| nsdname | string | No       | The name server name for this NS record. |

###### PtrRecord object

| Name     | Type   | Required | Value                                           |
| -------- | ------ | -------- | ----------------------------------------------- |
| ptrdname | string | No       | The PTR target domain name for this PTR record. |

###### SrvRecord object

| Name     | Type    | Required | Value                                       |
| -------- | ------- | -------- | ------------------------------------------- |
| priority | integer | No       | The priority value for this SRV record.     |
| weight   | integer | No       | The weight value for this SRV record.       |
| port     | integer | No       | The port value for this SRV record.         |
| target   | string  | No       | The target domain name for this SRV record. |

###### TxtRecord object

| Name  | Type  | Required | Value                                        |
| ----- | ----- | -------- | -------------------------------------------- |
| value | array | No       | The text value of this TXT record. \- string |

###### CnameRecord object

| Name  | Type   | Required | Value                                     |
| ----- | ------ | -------- | ----------------------------------------- |
| cname | string | No       | The canonical name for this CNAME record. |

###### SoaRecord object

| Name         | Type    | Required | Value                                                                                                         |
| ------------ | ------- | -------- | ------------------------------------------------------------------------------------------------------------- |
| host         | string  | No       | The domain name of the authoritative name server for this SOA record.                                         |
| email        | string  | No       | The email contact for this SOA record.                                                                        |
| serialNumber | integer | No       | The serial number for this SOA record.                                                                        |
| refreshTime  | integer | No       | The refresh value for this SOA record.                                                                        |
| retryTime    | integer | No       | The retry time for this SOA record.                                                                           |
| expireTime   | integer | No       | The expire time for this SOA record.                                                                          |
| minimumTTL   | integer | No       | The minimum value for this SOA record. By convention this is used to determine the negative caching duration. |

###### CaaRecord object

| Name  | Type    | Required | Value                                                          |
| ----- | ------- | -------- | -------------------------------------------------------------- |
| flags | integer | No       | The flags for this CAA record as an integer between 0 and 255. |
| tag   | string  | No       | The tag for this CAA record.                                   |
| value | string  | No       | The value for this CAA record.                                 |

## History

| Date     | Change                                                                                                                           |
| -------- | -------------------------------------------------------------------------------------------------------------------------------- |
| 20181211 | Updating deploy.ps1 to support new Azure subscription and be more flexible by moving variables as parameter with default values. |
| 20181214 | Implementing new template name as template.json                                                                                  |
| 20190205 | Cleanup template folder                                                                                                          |
| 20190430 | Updated documentation and cleanup parameters                                                                                     |