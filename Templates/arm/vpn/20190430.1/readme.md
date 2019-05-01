
# Virtual Network Gateway

## Introduction

This template is used to deploy a [Virtual Network Gateway](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-07-01/virtualnetworkgateways)

## Parameter format

```JSON
{
    "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "containerSasToken": {
            "value": "[SasToken]"
        },
        "vpnArray": {
            "value": [
                {
                    "resourceGroup": "Demo-Core",
                    "vnet": "demo-vnet-core",
                    "sku": {
                        "name": "Basic",
                        "tier": "Basic",
                        "capacity": 2
                    },
                    "gatewayType": "Vpn",
                    "vpnType": "RouteBased",
                    "enableBgp": false,
                    "activeActive": false,
                    "vpnClientConfiguration": {
                        "vpnClientAddressPool": {
                            "addressPrefixes": [
                                "172.16.1.0/24"
                            ]
                        },
                        "vpnClientProtocols": [
                            "SSTP"
                        ],
                        "vpnClientRootCertificates": [
                            {
                                "name": "P2SRootCert",
                                "properties": {
                                    "publicCertData": "MIIC5zCCAc+gAwIBAgIQIFzV4QQO+b9Bzf3URxNa5jANBgkqhkiG9w0BAQsFADAW MRQwEgYDVQQDDAtQMlNSb290Q2VydDAeFw0xODA5MTMxMzM3MDVaFw0xOTA5MTMx MzU3MDVaMBYxFDASBgNVBAMMC1AyU1Jvb3RDZXJ0MIIBIjANBgkqhkiG9w0BAQEF AAOCAQ8AMIIBCgKCAQEAvUyme0pEQheswvmknFSfu0tuWdsOGM0RCp2uehgQIGvS aqTU6NlT5FFpYVdTLA4o7OKQXLwXsP3yEyi7/GYGr+dy4P4HEs3hWla/XohVV8hB Yq5wjG3N2MsNnDGpGSQtC5xLx2GbyrBoDdmq8xHoEpzOHnFtnYRB6RYqgsjwoZ/N SeokAnKk8066LA0R31gQcSVrhX0192QtVJmrQ7hfmq+iVKske4Luz2sx3z/Felv5 F9rnOgxC+NC31GANz+O3SWgarm8zAj2mRxTaztTHmWVvRC2bC//MWjYxAGpRnoR9 9CbYWiXxPWj+kkEV5KHcKrh7YIksUb/kV24dDiCUBQIDAQABozEwLzAOBgNVHQ8B Af8EBAMCAgQwHQYDVR0OBBYEFPsWT4Q1V9r3Jzx8YGT45Uzl8VqSMA0GCSqGSIb3 DQEBCwUAA4IBAQCIq5KxqqB1LCNjIsdSXU8PLYla8rR8zSLa+gjd2WzZfZ6gopKL ciVkL3KN0gzLIKsjSs4qyGW+omuEG4mlfoQYJX8qenMIqaWqBMB2zs6jQRZCBvky nl6EAT1LbizlC/ZC0E/0B/ceKRQdjl35pK8g5Z8H4eIe81erx38WdylEFzRhRW5e ngOSG67YdA8Zp68co/+3z0jSCGp0qE9pT6DnP8xbSgHQwweL0qHxvc0Y8NQOANw4 wkR4dJg1NB+BOeDAV8wc4dXt64gMHt/z1j0TZ12/FVphujZuCSMAFK7Yxf5o7Nrk 4/FUwRROi30s4zR9/u/gRNFoRaeecYvt2cBZ"
                                }
                            }
                        ],
                        "vpnClientRevokedCertificates": [],
                        "vpnClientIpsecPolicies": []
                    },
                    "tagValues": {
                        "businessOwner": "PSPC-CCC",
                        "costCenter": "PSPC-EA",
                        "deploymentStage": "Sandbox",
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

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|containerSasToken |string |No      |A SaS token for the private blob storage |
|vpnArray |array |Yes      |Array of VPN's to deploy - [VpnArray Object](###vpnArray-object) |

### VpnArray Object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|resourceGroup |string |Yes      |The resource group to deploy the vpn in. |
|vnet |string |Yes      |The vnet used by the VPN |
|sku |object |Yes      |The reference of the VirtualNetworkGatewaySku resource which represents the SKU selected for Virtual network gateway. - [VirtualNetworkGatewaySku Object](###virtualnetworkgatewaysku-object) |
|gatewayType |string |Yes      |The type of gateway to use - Vpn, ExpressRoute |
|vpnType |string |Yes      |The vpn type to use - PolicyBased, RoutingBased.  Policy-based VPNs encrypt and direct packets through IPsec tunnels based on the IPsec policies configured with the combinations of address prefixes between your on-premises network and the Azure VNet. RouteBased VPNs use "routes" in the IP forwarding or routing table to direct packets into their corresponding tunnel interfaces.  See [About VPN Gateway configuration settings](https://docs.microsoft.com/en-us/azure/vpn-gateway/vpn-gateway-about-vpn-gateway-settings) for more details.  |
|enableBgp |bool |Yes      |Whether BGP is enabled for this virtual network gateway or not |
|activeActive |bool|Yes      |ActiveActive or not. |
|vpnClientConfiguration |object |Yes      |The reference of the VpnClientConfiguration resource which represents the P2S VpnClient configurations. - [VpnClientConfiguration object](###vpnclientconfiguration-object)|
| tagValues             | object | Yes      | An object of tags - [Tag Object](###tag-object)|

### VpnClientConfiguration Object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|vpnClientRevokedCertificates |array |No      |VpnClientRevokedCertificate for Virtual network gateway. - [VpnClientRevokedCertificate Object](#vpnclientrevokedcertificate-object)|
|vpnClientIpsecPolicies |array |No      |VpnClientIpsecPolicies for virtual network gateway P2S client. - [IpsecPolicy Object](###ipsecpolicy-object)|
|vpnClientAddressPool |array |No      |The reference of the address space resource which represents Address space for P2S VpnClient. - [AddressSpace Object](###addressspace-object) |
|vpnClientProtocols |array |No      |VpnClientProtocols for Virtual network gateway. - IkeV2, SSTP, OpenVPN |
|vpnClientRootCertificates |array |No      |VpnClientRootCertificate for virtual network gateway. - [VpnClientRootCertificate Object](###vpnclientrootcertificate-object)|

### Tag object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

### VirtualNetworkGatewaySku Object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string|Yes| Gateway SKU name. - Basic, HighPerformance, Standard, UltraPerformance, VpnGw1, VpnGw2, VpnGw3, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ, ErGw1AZ, ErGw2AZ, ErGw3AZ|
|tier        |string|Yes| Gateway SKU tier. - Basic, HighPerformance, Standard, UltraPerformance, VpnGw1, VpnGw2, VpnGw3, VpnGw1AZ, VpnGw2AZ, VpnGw3AZ, ErGw1AZ, ErGw2AZ, ErGw3AZ|
|capacity    |int   | Yes| The number of gateways to deploy |

### AddressSpace Object

|Name |Type | Required | Value |
|-----|-----|----------|-------|
|addressPrefixes |array |No |A list of address blocks reserved for this virtual network in CIDR notation. - string|

### VpnClientRootCertificate object

|Name |Type | Required | Value |
|-----|-----|----------|-------|
|id |string |No |Resource ID.|
|properties |object |Yes |Properties of the vpn client root certificate. - [VpnClientRootCertificatePropertiesFormat Object](###vpnclientrootcertificatepropertiesformat-object)|
|name |string |No |The name of the resource that is unique within a resource group. This name can be used to access the resource.|

### VpnClientRevokedCertificate object

|Name |Type | Required | Value |
|-----|-----|----------|-------|
|id |string |No |Resource ID.|
|properties |object |No |Properties of the vpn client revoked certificate. - VpnClientRevokedCertificatePropertiesFormat Object](###vpnclientrevokedcertificatepropertiesformat-object) |
|name |string |No |The name of the resource that is unique within a resource group. This name can be used to access the resource. |

### IpsecPolicy object

|Name |Type | Required | Value |
|-----|-----|----------|-------|
|saLifeTimeSeconds |integer |Yes |The IPSec Security Association (also called Quick Mode or Phase 2 SA) lifetime in seconds for a site to site VPN tunnel. 
|saDataSizeKilobytes |integer |Yes |The IPSec Security Association (also called Quick Mode or Phase 2 SA) payload size in KB for a site to site VPN tunnel. |
|ipsecEncryption |enum |Yes |The IPSec encryption algorithm (IKE phase 1). - None, DES, DES3, AES128, AES192, AES256, GCMAES128, GCMAES192, GCMAES256 |
|ipsecIntegrity |enum |Yes |The IPSec integrity algorithm (IKE phase 1). - MD5, SHA1, SHA256, GCMAES128, GCMAES192, GCMAES256|
|ikeEncryption |enum |Yes |The IKE encryption algorithm (IKE phase 2). - DES, DES3, AES128, AES192, AES256, GCMAES256, GCMAES128|
|ikeIntegrity |enum |Yes |The IKE integrity algorithm (IKE phase 2). - MD5, SHA1, SHA256, SHA384, GCMAES256, GCMAES128 |
|dhGroup |enum |Yes |The DH Groups used in IKE Phase 1 for initial SA. - None, DHGroup1, DHGroup2, DHGroup14, DHGroup2048, ECP256, ECP384, DHGroup24|
|pfsGroup |enum |Yes |The Pfs Groups used in IKE Phase 2 for new child SA. - None, PFS1, PFS2, PFS2048, ECP256, ECP384, PFS24, PFS14, PFSMM |

### VpnClientRootCertificatePropertiesFormat Object

|Name |Type | Required | Value |
|-----|-----|----------|-------|
|publicCertData |string |Yes |The certificate public data.|

### VpnClientRevokedCertificatePropertiesFormat Object

|Name |Type | Required | Value |
|-----|-----|----------|-------|
|thumbprint |string |No |The revoked VPN client certificate thumbprint. |

## History

|Date       | Change                |
|-----------|-----------------------|
|20181214   | Implementing new template name as template.json|
|20190205   | Cleanup template folder
|20190207   | Moved to git submodule|
|20190429   | Updated documentation|
