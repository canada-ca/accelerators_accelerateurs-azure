# Application Gateway

## Introduction

This template deploys an [Application Gateway](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-11-01/applicationgateways) in either Standard or WAF mode.  WAF with OWASP 3.0 is recommended to meet ITSG-33.  See the documentation folder in this template to see which controls apply.

Note: only v1 sku's are currently supported in Canada.

## Parameter Format

```JSON
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "gatewayName": {
            "value": "Demo-Infra-AG1"
        },
        "tier": {
            "value": "WAF"
        },
        "applicationGatewaySize": {
            "value": "WAF_Medium"
        },
        "capacity": {
            "value": 2
        },
        "sslCertificates": {
            "value": [
                {
                    "name": "managementWildcardCert",
                    "data": "Base 64 of your .pks file here",
                    "passwordSecret": "Your Certificate Password Here"
                },
                {
                    "name": "SharedWildcardCert",
                    "data": "Base 64 of your .pks file here",
                    "passwordSecret": "Your Certificate Password Here"
                }
            ]
        },
        "authenticationCertificates": {
            "value": [
                {
                    "name": "managementWildcardCert",
                    "data": "Base64 of your .cer file here"
                },
                                {
                    "name": "sharedWildcardCert",
                    "data": "Base64 of your .cer file here"
                }
            ]
        },
        "frontendIPConfigurations": {
            "value": [
                {
                    "name": "appGatewayFrontendIP",
                    "privateIPAllocationMethod": "Dynamic"
                }
            ]
        },
        "backendAddressPools": {
            "value": [
               {
                    "name": "dockerdemoBackendAddressPool",
                    "backendAddresses": [
                        {
                            "ipAddress": "10.10.21.68"
                        }
                    ]
                },
                {
                    "name": "adfsBackendAddressPool",
                    "backendAddresses": [
                        {
                            "ipAddress": "10.10.24.24"
                        },
                        {
                            "ipAddress": "10.10.24.23"
                        }
                    ]
                }
            ]
        },
        "backendHttpSettingsCollection": {
            "value": [
                {
                    "name": "dockerBackendHttpSettings",
                    "port": 8080,
                    "protocol": "Http",
                    "cookieBasedAffinity": "Disabled",
                    "pickHostNameFromBackendAddress": false,
                    "affinityCookieName": "ApplicationGatewayAffinity",
                    "requestTimeout": 20
                },
                {
                    "name": "adfsBackendHttpSettings",
                    "port": 443,
                    "protocol": "Https",
                    "cookieBasedAffinity": "Disabled",
                    "pickHostNameFromBackendAddress": false,
                    "affinityCookieName": "ApplicationGatewayAffinity",
                    "requestTimeout": 60,
                    "authenticationCertificateName": [
                        {
                            "id": "[concat(resourceId('Microsoft.Network/applicationGateways',Demo-Infra-AG1), '/authenticationCertificates/sharedWildcardCert)]"
                        }
                    ]
                }
            ]
        },
        "httpListeners": {
            "value": [
                {
                    "name": "dockerListener",
                    "frontendIPConfigurationName": "appGatewayFrontendIP",
                    "frontendPortName": "appGatewayFrontendPort",
                    "protocol": "Https",
                    "sslCertificateName": "managementWildcardCert",
                    "hostName": "docker.mgmt.demo.ca",
                    "requireServerNameIndication": true
                },
                {
                    "name": "stsListener",
                    "frontendIPConfigurationName": "appGatewayFrontendIP",
                    "frontendPortName": "appGatewayFrontendPort",
                    "protocol": "Https",
                    "sslCertificateName": "sharedWildcardCert",
                    "hostName": "sts.shared.demo.ca",
                    "requireServerNameIndication": true
                }
            ]
        },
        "urlPathMaps": {
            "value": []
        },
        "requestRoutingRules": {
            "value": [
                {
                    "name": "dockerRoutingRule",
                    "ruleType": "Basic",
                    "httpListenerName": "dockerListener",
                    "backendAddressPoolName": "dockerdemoBackendAddressPool",
                    "backendHttpSettingsName": "dockerBackendHttpSettings"
                },
                {
                    "name": "adfsRoutingRule",
                    "ruleType": "Basic",
                    "httpListenerName": "stsListener",
                    "backendAddressPoolName": "adfsBackendAddressPool",
                    "backendHttpSettingsName": "adfsBackendHttpSettings"
                }
            ]
        },
        "probes": {
            "value": [{
                "name": "adfsProbe",
                "protocol": "Https",
                "host": "sts.shared.pws3.pspc-spac.ca",
                "path": "/adfs/ls/idpinitiatedsignon.aspx",
                "interval": 30,
                "timeout": 30,
                "unhealthyThreshold": 3,
                "pickHostNameFromBackendHttpSettings": false,
                "minServers": 0,
                "match": {
                    "body": "",
                    "statusCodes": [
                        "200-399"
                    ]
                }
            }]
        },
        "frontendPorts": {
            "value": [
                {
                    "name": "appGatewayFrontendPort",
                    "port": 443
                }
            ]
        },
        "webApplicationFirewallConfiguration": {
            "value": {
                "enabled": true,
                "firewallMode": "Detection",
                "ruleSetType": "OWASP",
                "ruleSetVersion": "3.0",
                "disabledRuleGroups": [],
                "requestBodyCheck": true,
                "maxRequestBodySizeInKb": 128,
                "fileUploadLimitInMb": 100
            }
        },
        "enableHttp2": {
            "value": true
        },
        "vnetResourceGroupName": {
            "value": "Demo-Infra-NetCore-RG"
        },
        "vnetName": {
            "value": "Demo-Infra-NetCore-VNET"
        },
        "subnetName": {
            "value": "Demo-core-waf"
        },
        "keyVaultRG": {
            "value":"Demo-Infra-Keyvault-RG"
        },
        "keyVaultName": {
            "value": "Demo-Infra-Keyvault"
        }
    }
}
```

## Parameter Values

### Main Template

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|gatewayName |string |Yes      |The name of the application gateway |
|tier        |string |Yes      |The type of gateway you want to deploy. - WAF, Standard.   |
|applicationGatewaySize |string    |No      |The size of Application Gateway to deploy. - WAF_Medium, WAF_Large. Defaults to Medium |
|capacity |int    |No      |The number of application gateway instances to deploy. Minimum 1 and Maximum of 10.  Default is 2 instances. |
|sslCertificates |array    |Yes      |Array of [SSL Certificate](###ssl-certificate)|
|authenticationCertificates |array    |Yes      |Array of [Authentication Certificate](###authentication-certificate)|
|frontendIPConfigurations |array    |Yes      |Array of [Frontend IP Configuration](###frontend-ip-configuration)|
|backendAddressPools |array    |Yes      |Array of [Backend Address Pool](###backend-address-pool)|
|backendHttpSettingsCollection |array    |Yes      |Array of [Backend Http Settings ](###backend-http-settings)|
|httpListeners |array    |Yes      |Array of [Http Listeners](###httpListeners)|
|urlPathMaps |array    |Yes      |Array of [URL Path Maps](###url-path-map)|
|requestRoutingRules |array    |Yes      |Array of [Request Routing Rules](###request-routing-rules)|
|probes |array    |Yes      |Array of health [Probes](###probes)|
|frontendPorts |array    |Yes      |Array of [Frontend Ports](###frontend-ports)|
|webApplicationFirewallConfiguration |Object    |Yes      |Object of [Web Application Firewall Configuration](###web-application-firewall-configuration)|
|enableHttp2 |string    |Yes      |Sets if HTTP2 is enabled - Enabled, Disabled|
|vnetResourceGroupName |string    |Yes      |The resource group the vnet sits in|
|vnetName |string    |Yes      |Name of the vnet to use|
|subnetName |string    |Yes      |Name of the subnet to use|

### SSL Certificate

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |Yes      |A name for the SSL Certificate entry.|
|data        |string |Yes      |A base64 implementation of the .pks private SSL certificates used by the gateway.|
|password    |string |Yes      |The password for the certificate.|

### Authentication Certificate

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |Yes      |A name for the Authentication Certificate entry.|
|data        |string |Yes      |A base64 implementation of the .cer certificates used by the gateway.|

### Frontend IP Configuration

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |Yes      |A name for the frontend IP configuration.|
|privateIPAllocationMethod        |string |Yes      |Sets if the IP is Dynamic or Static.|

### Backend Address Pool

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |Yes      |A name for the backend address pool.|
|backendAddresses |array |Yes      |Array of [Backend Address](###backend-addresses).|


### Backend Addresses

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|backendAddresses |array |Yes      |Array of [IP Address](###ip-address).|

### IP Address

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|ipAddress        |string |Yes      |The IP address to use|

### Backend HTTP Settings

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |Yes      |The name of the HTTP Setting|
|port        |int |Yes      |The port used by the setting|
|protocol    |string |Yes      |The network protocol used by the setting.  - HTTP, HTTPS|
|cookieBasedAffinity |string |Yes      |Sets if cookie based affinity should be set for sticky sessions.  - Disabled, Enabled|
|pickHostNameFromBackendAddress |bool |No      |Sets whether to pick host header should be picked from the host name of the backend server. Default value is false.|
|affinityCookieName        |string |Yes      |Sets the cookie name to use for the affinity cookie.|
|requestTimeout        |string |No      |Sets the request timeout in seconds. Application Gateway will fail the request if response is not received within RequestTimeout. Acceptable values are from 1 second to 86400 seconds.|
|AuthenticationCertificates        |array |No      |Sets the array of references to application gateway authentication certificates resource id - [SubResource](###subresource)|

### Subresource

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|id        |string |Yes      |The resource id to use|

### Http Listeners

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |Yes      |The name of the httpListner|
|frontendIPConfigurationName        |string |Yes      |The name of the frontend IP configuration|
|frontendPortName        |string |Yes      |The name of the frontend port|
|protocol        |string |Yes      |The protocol for the user|
|sslCertificateName        |string |Yes      |The name of the ssl certificate|
|requireServerNameIndication        |bool |Yes      |Enables SNI for multi-hosting.|

### URL Path Maps

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |Yes      |The name of the url pathmap|
|properties  |object |Yes      |[URL Path Map Properties](###url-path-map-properties)|

```JSON
"urlPathMaps": [{
    "name": "{urlpathMapName}",
    "id": "/subscriptions/{subscriptionId}/../microsoft.network/applicationGateways/{gatewayName}/urlPathMaps/{urlpathMapName}",
    "properties": {
        "defaultBackendAddressPool": {
            "id": "/subscriptions/    {subscriptionId}/../microsoft.network/applicationGateways/{gatewayName}/backendAddressPools/{poolName1}"
        },
        "defaultBackendHttpSettings": {
            "id": "/subscriptions/{subscriptionId}/../microsoft.network/applicationGateways/{gatewayName}/backendHttpSettingsList/{settingname1}"
        },
        "pathRules": [{
            "name": "{pathRuleName}",
            "properties": {
                "paths": [
                    "{pathPattern}"
                ],
                "backendAddressPool": {
                    "id": "/subscriptions/{subscriptionId}/../microsoft.network/applicationGateways/{gatewayName}/backendAddressPools/{poolName2}"
                },
                "backendHttpsettings": {
                    "id": "/subscriptions/{subscriptionId}/../microsoft.network/applicationGateways/{gatewayName}/backendHttpsettingsList/{settingName2}"
                }
            }
        }]
    }
}]
```

### URL Path Map Properties

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|defaultBackendAddressPool        |object |Yes      |Refence to the id of the default backend address pool - [SubResource](###subresource)|
|defaultBackendHttpSettings        |object |Yes      |Refence to the id of the default backend http settings - [SubResource](###subresource)|
|pathRules        |array |Yes      |Array of path rules - [Path Rules](###path-rules)|

### Path Rules

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|paths        |array |Yes      |Array of url paths as strings to match.|
|defaultBackendbackendAddressPool        |object |Yes      |Refence to the id of the backend address pool - [SubResource](###subresource)|
|backendHttpsettings        |object |Yes      |Refence to the id of the backend Http settings - [SubResource](###subresource)|

### Request Routing Rules

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |Yes      |Name of the routing rule|
|httpListenerName        |string |Yes      |Name of the http listener to use|
|backendAddressPoolName        |string |Yes      |Name of the backend address pool to use|
|backendHttpSettingsName        |string |Yes      |Name of the backend Http settings to use|

```JSON
"requestRoutingRules": [
    {

"name": "{ruleName}",
"id": "/subscriptions/{subscriptionId}/../microsoft.network/applicationGateways/{gatewayName}/requestRoutingRules/{ruleName}",
"properties": {
    "ruleType": "PathBasedRouting",
    "httpListener": {
        "id": "/subscriptions/{subscriptionId}/../microsoft.network/applicationGateways/{gatewayName}/httpListeners/<listenerName>"
    },
    "urlPathMap": {
        "id": "/subscriptions/{subscriptionId}/../microsoft.network/applicationGateways/{gatewayName}/ urlPathMaps/{urlpathMapName}"
    },

}
    }
]
```

## Probes

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |Yes      |Name of the probe|
|protocol        |string |Yes      |Protocol to use - Http, Https|
|host        |string |No      |This value is the host name that is used for the probe. Applicable only when multi-site is configured on Application Gateway, otherwise use '127.0.0.1'. This value is different from the VM host name.|
|path        |string |Yes      |The remainder of the full url for the custom probe. A valid path starts with '/'. For the default path of http://contoso.com just use '/'|
|interval        |int |Yes      |How often the probe is run to check for health. It is not recommended to set the lower than 30 seconds.|
|timeout        |int |Yes      |The amount of time the probe waits before timing out. The timeout interval needs to be high enough that an http call can be made to ensure the backend health page is available.|
|unhealthyThreshold        |int |Yes      |Number of failed attempts to be considered unhealthy. A threshold of 0 means that if a health check fails the back-end is determined unhealthy immediately.|
|minServers        |string |No      |Sets minimum number of servers that are always marked healthy. Default value is 0|
|pickHostNameFromBackendHttpSettings        |bool |No      |Sets whether the host header should be picked from the backend http settings. Default value is false.|
|match        |object |No      |Sets criterion for classifying a healthy probe response. - [Probe Health Response Match](###probe-health-response-match)|

### Probe Health Response Match

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|body        |string |No      |Sets body that must be contained in the health response. Default value is empty.|
|statusCodes        |array |Yes      |Sets allowed ranges of healthy status codes. Default range of healthy status codes is 200-399.|

### Frontend Ports

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|name        |string |No      |Frontend port name|
|port        |int |No      |Frontend port|

### Web Application Firewall Configuration

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|enabled        |bool |Yes      |Frontend port name|
|firewallMode        |string |Yes      |sets web application firewall mode. Possible values include: 'Detection', 'Prevention'|
|ruleSetType        |string |Yes      |Sets the type of the web application firewall rule set. Possible values are: 'OWASP'.|
|ruleSetVersion        |string |Yes      |sets the version of the rule set type.|
|disabledRuleGroups        |string |No      |Sets the disabled rule groups.|
|requestBodyCheck        |array |No      |Sets whether allow WAF to check request Body.|
|maxRequestBodySizeInKb        |string |No      |Sets maximum request body size in Kb for WAF.|
|fileUploadLimitInMb        |string |No      |Sets the maximum file upload limit in Mb |

## Additional Information

### Free SSL Certificates

You can generate free 90 day SSL certificate from the following [location](https://sslforfree.com).  
The team is working on an automation workbook to renew the certificates.

### Creating .pks from .crt and .key files

You can use openssl to convert your .crt and .key files to .pks by running the following command:
```shell
openssl pkcs12 -export -out "certificate_combined.pfx" -inkey "private.key" -in "certificate.crt" -certfile ca_bundle.crt
```

### Converting .pks to base 64

You can use the following powershell commands to convert your .pks certificates to base64 encoding:
```Powershell
$fileContentBytes = get-content 'C:\Certificate\testcert.pfx' -Encoding Byte
[System.Convert]::ToBase64String($fileContentBytes) | Out-File 'C:\Certificate\test-pfx-encoded-bytes.txt'
```

## History

|Date       | Change |
|-----------|-----------------------|
|20190425.1 | Inital version
|20190426.1 | Updated documentation |
|20190430.1 | Updated documentation |