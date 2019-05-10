# Servers

## Introduction

This template deploys a highly customizable [virtual machine resource](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-03-01/virtualmachines).

## Security Controls

The following security controls can be met through configuration of this template:

* AC-1, AC-10, AC-11, AC-11(1), AC-12, AC-14, AC-16, AC-17, AC-18, AC-18(4), AC-2 , AC-2(5), AC-20(1) , AC-20(3), AC-20(4), AC-24(1), AC-24(11), AC-3, AC-3 , AC-3(1), AC-3(3), AC-3(9), AC-4, AC-4(14), AC-6, AC-6, AC-6(1), AC-6(10), AC-6(11), AC-7, AC-8, AC-8, AC-9, AC-9(1), AI-16, AU-2, AU-3, AU-3(1), AU-3(2), AU-4, AU-5, AU-5(3), AU-8(1), AU-9, CM-10, CM-11(2), CM-2(2), CM-2(4), CM-3, CM-3(1), CM-3(6), CM-5(1), CM-6, CM-6, CM-7, CM-7, IA-1, IA-2, IA-3, IA-4(1), IA-4(4), IA-5, IA-5, IA-5(1), IA-5(13), IA-5(1c), IA-5(6), IA-5(7), IA-9, SC-10, SC-13, SC-15, SC-18(4), SC-2, SC-2, SC-23, SC-28, SC-30(5), SC-5, SC-7, SC-7(10), SC-7(16), SC-7(8), SC-8, SC-8(1), SC-8(4), SI-14, SI-2(1), SI-3

## Dependancies

* [Resource Groups](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md)
* [Keyvault](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/keyvaults/latest/readme.md)
* [VNET-Subnet](https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/vnet-subnet/latest/readme.md)
* [AvailabilitySet]
* [StorageAccount]

## Parameter format

```json
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "vmArray": {
            "value": [
                {
                    "comment": "This is a Linux vm example.",
                    "vmKeyVault": {
                        "keyVaultResourceGroupName": "rgkeyVaults",
                        "keyVaultName": "pspckeys"
                    },
                    "vm": {
                        "computerName": "azpws01-test03",
                        "adminUsername": "azureadmin",
                        "adminPassword": "ubuntuDefaultPassword",
                        "shutdownConfig": {
                            "autoShutdownStatus": "Enabled",
                            "autoShutdownTime": "17:00",
                            "autoShutdownTimeZone": "Eastern Standard Time",
                            "autoShutdownNotificationStatus": "Disabled"
                        },
                        "omsAgentForLinux": {
                            "workspaceId": "23b01bc4-90a3-4bf2-9928-d260605e2f12",
                            "workspaceKey": "myWorkSpaceKey"
                        },
                        "vmSize": "Standard_B1s",
                        "bootDiagnostic": true,
                        "existingBackupVaultRG": "nothing",
                        "storageProfile": {
                            "osDisk": {
                                "createOption": "fromImage",
                                "managedDisk": {
                                    "storageAccountType": "StandardSSD_LRS"
                                }
                            },
                            "dataDisks": [],
                            "imageReference": {
                                "publisher": "Canonical",
                                "offer": "UbuntuServer",
                                "sku": "18.04-LTS",
                                "version": "latest"
                            }
                        },
                        "linuxScript": {
                            "commandToExecute": "['sudo sh linux-script.sh']"
                        }
                    },
                    "networkSecurityGroups": {
                        "name": "nsg",
                        "properties": {
                            "securityRules": []
                        }
                    },
                    "networkInterfaces": {
                        "name": "NIC1",
                        "vnetResourceGroupName": "AzPwS01-Infra-NetMGMT-RG",
                        "vnetName": "AzPwS01-Infra-NetMGMT-VNET",
                        "subnetName": "PAZ",
                        "acceleratedNetworking": false
                    },
                    "tagValues": {
                        "Owner": "charles.vriesendorp@tpsgc-pwgsc.gc.ca",
                        "CostCenter": "PSPC-EA",
                        "Enviroment": "Sandbox",
                        "Classification": "Unclassified",
                        "Organizations": "PSPC-CCC-E&O",
                        "DeploymentVersion": "2018-12-19-01"
                    }
                },
                {
                    "comment": "This Windows vm demonstrate the use of the licenseType parameter and antimalware settings. This is only needed for Windows type vm.",
                    "vmKeyVault": {
                        "keyVaultResourceGroupName": "rgkeyVaults",
                        "keyVaultName": "pspckeys"
                    },
                    "domainObject": {
                        "domainToJoin": "pspc.gc.ca.local",
                        "domainUsername": "azureadmin",
                        "domainUserSecretName": "adDefaultPassword",
                        "domainJoinOptions": 3,
                        "ouPath": ""
                    },
                    "vm": {
                        "computerName": "test-win-srv1",
                        "adminUsername": "azureadmin",
                        "licenseType": "Windows_Server",
                        "shutdownConfig": {
                            "autoShutdownStatus": "Enabled",
                            "autoShutdownTime": "17:00",
                            "autoShutdownTimeZone": "Eastern Standard Time",
                            "autoShutdownNotificationStatus": "Disabled"
                        },
                        "omsAgentForWindows": {
                            "workspaceId": "23b01bc4-90a3-4bf2-9928-d260605e2f12",
                            "workspaceKey": "myWorkSpaceKey"
                        },
                        "vmSize": "Standard_B2s",
                        "bootDiagnostic": true,
                        "antimalwareInfo": {
                            "exclusionPaths": "c:\\Users",
                            "exclusionExtensions": ".txt; .ps1",
                            "exclusionProcesses": "w3wp.exe;explorer.exe",
                            "realtimeProtectionEnabled": "true",
                            "scheduledScanSettingsEnabled": "false",
                            "scheduledScanSettingsType": "Quick",
                            "scheduledScanSettingsDay": "1",
                            "scheduledScanSettingsTime": "120"
                        },
                        "storageProfile": {
                            "imageReference": {
                                "publisher": "MicrosoftWindowsServer",
                                "offer": "WindowsServer",
                                "sku": "2016-Datacenter",
                                "version": "latest"
                            },
                            "dataDisks": [],
                            "osDisk": {
                                "createOption": "fromImage",
                                "managedDisk": {
                                    "storageAccountType": "StandardSSD_LRS"
                                }
                            }
                        },
                        "availabilitySet": {},
                        "plan": {
                            "name": "1-9",
                            "publisher": "bitnami",
                            "product": "product",
                            "promotionCode": "nginxstack"
                        },
                    },
                    "networkSecurityGroups": {
                        "name": "nsg",
                        "properties": {
                            "securityRules": []
                        }
                    },
                    "networkInterfaces": {
                        "name": "NIC1",
                        "acceleratedNetworking": false,
                        "vnetResourceGroupName": "rgManagement",
                        "vnetName": "vnet-management",
                        "subnetName": "APP"
                    },
                    "tagValues": {
                        "Owner": "charles.vriesendorp@tpsgc-pwgsc.gc.ca",
                        "CostCenter": "PSPC-EA",
                        "Enviroment": "Sandbox",
                        "Classification": "Unclassified",
                        "Organizations": "PSPC-CCC-E&O",
                        "DeploymentVersion": "2018-12-19-01"
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
| vmArray            | array  | Yes      | Array of [VM objects](#vm-array-object)                                                                                                                                                                                                                                                                                                                                                                                                                                        |

## VM Array Object

| Name                  | Type   | Required | Value                                                                                                                                                               |
| --------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| AADLoginForLinux      | object | No       | Object that specify if the Linux VM should authenticate against the Azure Active Directory. If AAD authentication is desired simple set as an empty object. E.g: {} |
| domainObject          | object | No       | Active Directory resource information - [Domain Object](#domain-object)                                                                                             |
| networkSecurityGroups | object | Yes      | Network Security Group information - [Network Security Group Object](#network-security-group-object)                                                                |
| networkInterfaces     | object | Yes      | Network Interface Information - [Network Interface Config Object](#network-interface-config-object)                                                                 |
| tagValues             | object | Yes      | Object containing [tags pairs](#tag-object)                                                                                                                         |
| vm                    | object | Yes      | VM resource information - [VM Object](#vm-object)                                                                                                                   |
| vmKeyVault            | object | Yes      | Keyvault resource information - [Keyvault Object](#keyvault-object)                                                                                                 |

### Keyvault Object

| Name                      | Type   | Required | Value                                                                   |
| ------------------------- | ------ | -------- | ----------------------------------------------------------------------- |
| keyVaultResourceGroupName | string | Yes      | Name of the Resource Group containing the keyvault                      |
| keyVaultName              | string | Yes      | Name of keyvault resource - [Name format options](#name-format-options) |

#### Name Format Options

When specifying the name of a keyvault simply include the token [unique] (including the []) as part of the name. The template will replace the [unique] word with a unique string of characters. For example:

| Name                   | Result                     |
| ---------------------- | -------------------------- |
| key-[unique]-deploy    | key-sd8kjdf678k9-deploy    |
| keyvault-test-[unique] | keyvault-test-sd8kjdf678k9 |

This is helpfull to ensure there will be no keyvault duplicates in Azure as it need to be unique.

### Domain Object

| Name                 | Type    | Required | Value                                                       |
| -------------------- | ------- | -------- | ----------------------------------------------------------- |
| domainToJoin         | string  | Yes      | Name of the domain to join. Eg. test.gc.ca.local            |
| domainUsername       | string  | Yes      | Name of domain admin account to use to join the domain      |
| domainUserSecretName | string  | Yes      | Name of secret containing the domain admin account password |
| domainJoinOptions    | integer | Yes      | Domain join option. Recommended value: 3                    |
| ouPath               | string  | Yes      | Path for the domain ou. Leave empty in most cases. Eg: ""   |

### VM Object

| Name                      | Type    | Required | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                              |
| ------------------------- | ------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| adminUsername             | string  | Yes      | Name for the VM admin account                                                                                                                                                                                                                                                                                                                                                                                                                                      |
| adminPassword             | string  | Yes      | Name of the keyvault secret that contain the admin user password                                                                                                                                                                                                                                                                                                                                                                                                   |
| antimalwareInfo           | object  | No       | Object containing windows antimalware configuration - [Windows Antimalware Config Object](#windows-antimalware-config-object)                                                                                                                                                                                                                                                                                                                                      |
| applicationSecurityGroups | array   | No       | Array of application security groups objects that contain references to ApplicationSecurityGroup. - [Application Security Groups Config Object](#applicationsecuritygroup-object)                                                                                                                                                                                                                                                                                  |
| availabilitySetName       | string  | No       | Name of the availabilitySet resource for the VM                                                                                                                                                                                                                                                                                                                                                                                                                    |
| backupConfig              | object  | No       | Object containing VM Backup configuration - [Backup Config]                                                                                                                                                                                                                                                                                                                                                                                                        |
| bootDiagnostic            | boolean | Yes      | Whether boot diagnostics should be enabled on the Virtual Machine.                                                                                                                                                                                                                                                                                                                                                                                                 |
| computerName              | string  | Yes      | Name of the VM                                                                                                                                                                                                                                                                                                                                                                                                                                                     |
| DSCSettings               |
| encryptDisks              | object  | No       | Specify if the Windows disk need to be encrypted. If encryption is desired simple set as an empty object. E.g: {}                                                                                                                                                                                                                                                                                                                                                  |
| encryptDisksLinux         | object  | No       | Specify if the Linux disk need to be encrypted. If encryption is desired simple set as an empty object. E.g: {}                                                                                                                                                                                                                                                                                                                                                    |
| licenseType               | string  | No       | Specifies that the image or disk that is being used was licensed on-premises. This element is only used for images that contain the Windows Server operating system. If this element is included in a request for an update, the value must match the initial value. This value cannot be updated. - Windows_Client or Windows_Server                                                                                                                              |
| linuxScript               | object  | No       | Object containing linux script configuration - [Linux Script Config Object](#linux-script-config-object)                                                                                                                                                                                                                                                                                                                                                           |
| omsAgentForLinux          | object  | No       | Object containing Linux VM monitoring parameters - [Linux Monitoring Config Object](#linux-monitoring-config-object)                                                                                                                                                                                                                                                                                                                                               |
| omsAgentForWindows        | object  | No       | Object containing Windows VM monitoring parameters - [Windows Monitoring Config Object](#windows-monitoring-config-object)                                                                                                                                                                                                                                                                                                                                         |
| plan                      | object  | No       | Specifies information about the marketplace image used to create the virtual machine. This element is only used for marketplace images. Before you can use a marketplace image from an API, you must enable the image for programmatic use. In the Azure portal, find the marketplace image that you want to use and then click Want to deploy programmatically, Get Started ->. Enter any required information and then click Save. - [Plan object](#plan-object) |
| shutdownConfig            | object  | No       | Object containing VM shutdown parameters - [Shutdown Config Object](#shutdown-config-object)                                                                                                                                                                                                                                                                                                                                                                       |
| storageAccountName        | string  | No       | Name of an existing storage account to use for the VM log.                                                                                                                                                                                                                                                                                                                                                                                                         |
| storageProfile            | object  | Yes      | Object that pecifies the storage settings for the virtual machine disks. - StorageProfile object                                                                                                                                                                                                                                                                                                                                                                   |
| vmSize                    | string  | Yes      | Size of the VM. Eg. Standard_B1s                                                                                                                                                                                                                                                                                                                                                                                                                                   |

### Network Interface Config Object

| Name                  | Type    | Required | Value                                                                                                        |
| --------------------- | ------- | -------- | ------------------------------------------------------------------------------------------------------------ |
| acceleratedNetworking | boolean | Yes      | Is the NIC using accelerated networking or not. - true or false                                              |
| dnsServerPrivateIp    | array   | No       | IP address of the DNS servers to assign to the VM. E.g: ["10.10.10.5","10.10.10.6"]                          |
| name                  | string  | Yes      | Name of the Network Interface for the VM                                                                     |
| subnetName            | string  | Yes      | Name of the subnet the NIC will connect to                                                                   |
| privateIPAddress      | string  | No       | Specify the desired Private IP address for the VM. If not specify a Private IP will dynamically be allocated |
| vnetResourceGroupName | string  | Yes      | Name of the resource group containing the VNET where the NIC will connect                                    |
| vnetName              | string  | Yes      | Name of the VNET where the nic will connect                                                                  |

### Network Security Group Object

| Name       | Type   | Required | Value                                                                             |
| ---------- | ------ | -------- | --------------------------------------------------------------------------------- |
| name       | string | Yes      | Name of the Network Security Group (NSG) for the VM                               |
| properties | object | Yes      | Properties of the Network Security Group - [Network Security Group Config Object] |

#### DSC Settings Property object

| Name                   | Type       | Required | Value                                                                                                                                                                                                                                                                                                                                          |
| ---------------------- | ---------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| wmfVersion             | string     | No       | Specifies the version of the Windows Management Framework that should be installed on your VM. Setting this property to ‘latest’ will install the most updated version of WMF. The only current possible values for this property are ‘4.0’, ‘5.0’, and ‘latest’. These possible values are subject to updates. The default value is ‘latest’. |
| configuration          | object     | Yes      | Object containing DSC Configuration properties - [DSC Settings Configuration Property object](#dsc-settings-configuration-property-object)                                                                                                                                                                                                     |
| configurationArguments | collection | No       | Defines any parameters you would like to pass to your DSC configuration. This property will not be encrypted.                                                                                                                                                                                                                                  |
| configurationData      | object     | No       | Object containing DSC Configuration Data properties - [DSC Settings Configuration Data Property object](#dsc-settings-configuration-data-property-object)                                                                                                                                                                                      |
| privacy.dataEnabled    | object     | No       | Object containing DSC Configuration Data properties - [DSC Settings Configuration Privacy Property object](#dsc-settings-configuration-privacy-property-object)                                                                                                                                                                                |
| advancedOptions        | object     | No       | Object containing DSC Configuration Data properties - [DSC Settings Configuration Advanced Option Property object](#dsc-settings-configuration-advanced-options-property-object)                                                                                                                                                               |

More information about this object can be found [here](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/dsc-windows)

#### DSC Settings Configuration Property object

| Name     | Type   | Required | Value                                                                                                                                                                                                                                                                                                                                                               |
| -------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| url      | string | Yes      | Specifies the URL location from which to download your DSC configuration zip file. If the URL provided requires a SAS token for access, you will need to set the protectedSettings.configurationUrlSasToken property to the value of your SAS token. This property is required if settings.configuration.script and/or settings.configuration.function are defined. |
| script   | string | Yes      | Specifies the file name of the script that contains the definition of your DSC configuration. This script must be in the root folder of the zip file downloaded from the URL specified by the configuration.url property. This property is required if settings.configuration.url and/or settings.configuration.script are defined.                                 |
| function | string | Yes      | Specifies the name of your DSC configuration. The configuration named must be contained in the script defined by configuration.script. This property is required if settings.configuration.url and/or settings.configuration.function are defined.                                                                                                                  |

#### DSC Settings Configuration Data Property object

| Name | Type   | Required | Value                                                                                                                                                                                                                                                                                           |
| ---- | ------ | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| url  | string | Yes      | Specifies the URL from which to download your configuration data (.pds1) file to use as input for your DSC configuration. If the URL provided requires a SAS token for access, you will need to set the protectedSettings.configurationDataUrlSasToken property to the value of your SAS token. |

#### DSC Settings Configuration Privacy Property object

| Name           | Type   | Required | Value                                                                                                                                                                                |
| -------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| dataCollection | string | Yes      | Enables or disables telemetry collection. The only possible values for this property are ‘Enable’, ‘Disable’, ”, or $null. Leaving this property blank or null will enable telemetry |

#### DSC Settings Configuration Advanced Options Property object

| Name              | Type       | Required | Value                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             |
| ----------------- | ---------- | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| forcePullAndApply | bool       | Yes      | This setting is designed to enhance the experience of working with the extension to register nodes with Azure Automation DSC. If the value is `$true`, the extension will wait for the first run of the configuration pulled from the service before returning success/failure. If the value is set to $false, the status returned by the extension will only refer to whether the node was registered with Azure Automation State Configuration successfully and the node configuration will not be run during the registration. |
| downloadMappings  | collection | Yes      | Defines alternate locations to download dependencies such as WMF and .NET                                                                                                                                                                                                                                                                                                                                                                                                                                                         |

#### Linux Script Config Object

| Name              | Type   | Required | Value                                                                                                                                                             |
| ----------------- | ------ | -------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| protectedSettings | object | Yes      | Object containing linux script protected settings configuration - [Linux Script Protected Settings Config Object](#linux-script-protected-settings-config-object) |

#### Linux Script Protected Settings Config Object

| Name               | Type   | Required                                       | Value                                                                                                                                                                  |
| ------------------ | ------ | ---------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| commandToExecute   | string | (required if script not set, string)           | Command to execute on the Linux VM. E.g: python MyPythonScript.py <my-param1>                                                                                          |
| script             | object | (required if commandToExecute not set, string) | Base64 encoded (and optionally gzip'ed) script executed by /bin/sh. E.g: IyEvYmluL3NoCmVjaG8gIlVwZGF0aW5nIHBhY2thZ2VzIC4uLiIKYXB0IHVwZGF0ZQphcHQgdXBncmFkZSAteQo=      |
| storageAccountName | string | No                                             | Name of storage account. If you specify storage credentials, all fileUris must be URLs for Azure Blobs. E.g: examplestorageacct                                        |
| storageAccountKey  | string | No                                             | access key of storage account. Eg.: TmJK/1N3AbAZ3q/+hOXoi/l73zOqsaxXDhqa9Y83/v5UpXQp2DQIBuv2Tifp60cE/OaHsJZmQZ7teQfczQj8hg==                                           |
| fileUris           | array  | No                                             | Array of URLs for file(s) to be downloaded. E.g: ["https://github.com/MyProject/Archive/MyPythonScript.py", "https://github.com/MyProject/Archive/MyPythonScript2.py"] |

More information on Linux Custom Script Extension [can be found here](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux).

#### Network Security Group Config Object

| Name                 | Type   | Required | Value                                                                                                        |
| -------------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------ |
| securityRules        | array  | No       | A collection of security rules of the network security group. \- [SecurityRule object](#securityrule-object) |
| defaultSecurityRules | array  | No       | The default security rules of network security group. \- [SecurityRule object](#securityrule-object)         |
| resourceGuid         | string | No       | The resource GUID property of the network security group resource.                                           |

[Network Security Groups reference](https://docs.microsoft.com/en-us/azure/templates/microsoft.network/2018-08-01/networksecuritygroups)

### Plan object

| Name          | Type   | Required | Value                                                                                                                      |
| ------------- | ------ | -------- | -------------------------------------------------------------------------------------------------------------------------- |
| name          | string | No       | The plan ID.                                                                                                               |
| publisher     | string | No       | The publisher ID.                                                                                                          |
| product       | string | No       | Specifies the product of the image from the marketplace. This is the same value as Offer under the imageReference element. |
| promotionCode | string | No       | The promotion code.                                                                                                        |

#### SecurityRule object

| Name       | Type   | Required | Value                                                                                                          |
| ---------- | ------ | -------- | -------------------------------------------------------------------------------------------------------------- |
| id         | string | No       | Resource ID.                                                                                                   |
| properties | object | No       | Properties of the security rule \- [SecurityRulePropertiesFormat object](#securityrulepropertiesformat-object) |
| name       | string | No       | The name of the resource that is unique within a resource group. This name can be used to access the resource. |

#### SecurityRulePropertiesFormat object

| Name                                 | Type    | Required | Value                                                                                                                                                                                                                                                         |
| ------------------------------------ | ------- | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| description                          | string  | No       | A description for this rule. Restricted to 140 chars.                                                                                                                                                                                                         |
| protocol                             | enum    | Yes      | Network protocol this rule applies to. Possible values are 'Tcp', 'Udp', and '\*'. \- Tcp, Udp, \*                                                                                                                                                            |
| sourcePortRange                      | string  | No       | The source port or range. Integer or range between 0 and 65535. Asterisk '\*' can also be used to match all ports.                                                                                                                                            |
| destinationPortRange                 | string  | No       | The destination port or range. Integer or range between 0 and 65535. Asterisk '\*' can also be used to match all ports.                                                                                                                                       |
| sourceAddressPrefix                  | string  | No       | The CIDR or source IP range. Asterisk '\*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used. If this is an ingress rule, specifies where network traffic originates from. |
| sourceAddressPrefixes                | array   | No       | The CIDR or source IP ranges. \- string                                                                                                                                                                                                                       |
| sourceApplicationSecurityGroups      | array   | No       | The application security group specified as source. \- [ApplicationSecurityGroup object](#applicationsecuritygroup-object)                                                                                                                                    |
| destinationAddressPrefix             | string  | No       | The destination address prefix. CIDR or destination IP range. Asterisk '\*' can also be used to match all source IPs. Default tags such as 'VirtualNetwork', 'AzureLoadBalancer' and 'Internet' can also be used.                                             |
| destinationAddressPrefixes           | array   | No       | The destination address prefixes. CIDR or destination IP ranges. \- string                                                                                                                                                                                    |
| destinationApplicationSecurityGroups | array   | No       | The application security group specified as destination. \- [ApplicationSecurityGroup object](#applicationsecuritygroup-object))                                                                                                                              |
| sourcePortRanges                     | array   | No       | The source port ranges. \- string                                                                                                                                                                                                                             |
| destinationPortRanges                | array   | No       | The destination port ranges. \- string                                                                                                                                                                                                                        |
| access                               | enum    | Yes      | The network traffic is allowed or denied. Possible values are: 'Allow' and 'Deny'. \- Allow or Deny                                                                                                                                                           |
| priority                             | integer | No       | The priority of the rule. The value can be between 100 and 4096. The priority number must be unique for each rule in the collection. The lower the priority number, the higher the priority of the rule.                                                      |
| direction                            | enum    | Yes      | The direction of the rule. The direction specifies if rule will be evaluated on incoming or outgoing traffic. Possible values are: 'Inbound' and 'Outbound'. \- Inbound or Outbound                                                                           |

#### ApplicationSecurityGroup object

| Name       | Type   | Required | Value                                                                                                                                                                                                                                   |
| ---------- | ------ | -------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id         | string | No       | Resource ID. This is special format. Make sure to structure it as shown in the following example. This example specifies testASG1 and the ASG to associate E.g: [resourceId('Microsoft.Network/applicationSecurityGroups', 'testASG1')] |
| location   | string | No       | Resource location.                                                                                                                                                                                                                      |
| tags       | object | No       | Resource tags.                                                                                                                                                                                                                          |
| properties | object | No       | Properties of the application security group. \- [ApplicationSecurityGroupPropertiesFormat object](#ApplicationSecurityGroupPropertiesFormat)                                                                                           |

#### Backup Config object

| Name                    | Type   | Required | Value                                                      |
| ----------------------- | ------ | -------- | ---------------------------------------------------------- |
| existingBackupVaultRG   | string | Yes      | Resource group name containing the backup vault            |
| existingBackupVaultName | string | Yes      | Backup vault name                                          |
| existingBackupPolicy    | string | yes      | ID of the backup policy with which this item is backed up. |

More information about [Recovery Services](https://docs.microsoft.com/en-us/azure/templates/microsoft.recoveryservices/2017-07-01/vaults/backupfabrics/backupprotectionintent)

#### Windows Antimalware Config Object

| Name                         | Type   | Required | Value                                                                                                                       |
| ---------------------------- | ------ | -------- | --------------------------------------------------------------------------------------------------------------------------- |
| exclusionPaths               | string | Yes      | Semicolon delimited list of file paths or locations to exclude from scanning. Eg: c:\\Users                                 |
| exclusionExtensions          | string | Yes      | Semicolon delimited list of file extensions to exclude from scanning. Eg: .txt; .ps1                                        |
| exclusionProcesses           | string | Yes      | Semicolon delimited list of process names to exclude from scanning. Eg: w3wp.exe;explorer.exe                               |
| realtimeProtectionEnabled    | string | Yes      | Indicates whether or not real time protection is enabled - true or false                                                    |
| scheduledScanSettingsEnabled | string | Yes      | Indicates whether or not custom scheduled scan settings are enabled - true or false                                         |
| scheduledScanSettingsType    | string | Yes      | Indicates whether scheduled scan setting type is set to Quick or Full - Quick or Full                                       |
| scheduledScanSettingsDay     | string | Yes      | Day of the week for scheduled scan (1-Sunday, 2-Monday, ..., 7-Saturday)                                                    |
| scheduledScanSettingsTime    | string | Yes      | When to perform the scheduled scan, measured in minutes from midnight (0-1440). For example: 0 = 12AM, 60 = 1AM, 120 = 2AM. |

More info on linux monitoring can be found [at this location](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/iaas-antimalware-windows)

#### Linux Monitoring Config Object

| Name         | Type   | Required | Value                                                                 |
| ------------ | ------ | -------- | --------------------------------------------------------------------- |
| workspaceId  | string | Yes      | workspace ID from the target Log Analytics workspace. case-sensitive. |
| workspaceKey | string | Yes      | workspace key from the target Log Analytics workspace. case-sensitive |

More info on linux monitoring can be found [at this location](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/oms-linux)

#### Windows Monitoring Config Object

| Name         | Type   | Required | Value                                                                 |
| ------------ | ------ | -------- | --------------------------------------------------------------------- |
| workspaceId  | string | Yes      | workspace ID from the target Log Analytics workspace. case-sensitive. |
| workspaceKey | string | Yes      | workspace key from the target Log Analytics workspace. case-sensitive |

More info on linux monitoring can be found [at this location](https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/oms-windows)

#### Shutdown Config Object

| Name                           | Type   | Required | Value                                                                                          |
| ------------------------------ | ------ | -------- | ---------------------------------------------------------------------------------------------- |
| autoShutdownStatus             | string | Yes      | Name of the VM                                                                                 |
| autoShutdownTime               | string | Yes      | The time of day the schedule will occur. Eg: 17:00                                             |
| autoShutdownTimeZone           | string | Yes      | Timezone ID. Eg: Eastern Standard Time                                                         |
| autoShutdownNotificationStatus | string | Yes      | If notifications are enabled for this schedule (i.e. Enabled, Disabled). - Enabled or Disabled |

More info on schedule can be found [at this location](https://docs.microsoft.com/en-us/azure/templates/microsoft.devtestlab/2018-09-15/labs/virtualmachines/schedules)

#### StorageProfile object

| Name           | Type   | Required | Value                                                                                                                                                                                                                                                                                                                                                         |
| -------------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| imageReference | object | Yes      | Specifies information about the image to use. You can specify information about platform images, marketplace images, or virtual machine images. This element is required when you want to use a platform image, marketplace image, or virtual machine image, but is not used in other creation operations. \- [ImageReference object](#imagereference-object) |
| osDisk         | object | Yes      | Specifies information about the operating system disk used by the virtual machine.                                                                                                                                                                                                                                                                            |
|                |        |          | For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/virtual-machines-windows-about-disks-vhds?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json). \- [OSDisk object](#osdisk-object)                                                                                 |
| dataDisks      | array  | Yes      | Specifies the parameters that are used to add a data disk to a virtual machine.                                                                                                                                                                                                                                                                               |
|                |        |          | For more information about disks, see [About disks and VHDs for Azure virtual machines](https://docs.microsoft.com/azure/virtual-machines/virtual-machines-windows-about-disks-vhds?toc=%2fazure%2fvirtual-machines%2fwindows%2ftoc.json). \- [DataDisk object](#datadisk-object)                                                                             |

#### OSDisk object

| Name         | Type   | Required | Value                                                                                         |
| ------------ | ------ | -------- | --------------------------------------------------------------------------------------------- |
| createOption | enum   | Yes      | Specifies how the virtual machine should be created.                                          |
| managedDisk  | object | Yes      | The managed disk parameters. \- [ManagedDiskParameters object](#manageddiskparameters-object) |

#### DataDisk object

| Name                    | Type    | Required | Value                                                                                                                                                                                                                                                                                                                                                |
| ----------------------- | ------- | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| lun                     | integer | Yes      | Specifies the logical unit number of the data disk. This value is used to identify data disks within the VM and therefore must be unique for each data disk attached to a VM.                                                                                                                                                                        |
| name                    | string  | No       | The disk name.                                                                                                                                                                                                                                                                                                                                       |
| vhd                     | object  | No       | The virtual hard disk. - [VirtualHardDisk object](#virtualharddisk-object)                                                                                                                                                                                                                                                                           |
| image                   | object  | No       | The source user image virtual hard disk. The virtual hard disk will be copied before being attached to the virtual machine. If SourceImage is provided, the destination virtual hard drive must not exist. - [VirtualHardDisk object](https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-03-01/virtualmachines#VirtualHardDisk) |
| caching                 | enum    | No       | Specifies the caching requirements. Default: None for Standard storage. ReadOnly for Premium storage. - None, ReadOnly, ReadWrite                                                                                                                                                                                                                    |
| writeAcceleratorEnabled | boolean | No       | Specifies whether writeAccelerator should be enabled or disabled on the disk.                                                                                                                                                                                                                                                                        |
| createOption            | enum    | Yes      | Specifies how the virtual machine should be created. Possible values are: Attach or FromImage                                                                                                                                                                                                                                                        |
| diskSizeGB              | integer | No       | Specifies the size of an empty data disk in gigabytes. This element can be used to overwrite the size of the disk in a virtual machine image. This value cannot be larger than 1023 GB                                                                                                                                                               |
| managedDisk             | object  | No       | The managed disk parameters. - [ManagedDiskParameters object](#manageddiskparameters-object)                                                                                                                                                                                                                                                         |

#### ImageReference object

| Name      | Type   | Required | Value                                                                                                                                                                                                                                                                                                                                                                                                                     |
| --------- | ------ | -------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id        | string | No       | Resource Id                                                                                                                                                                                                                                                                                                                                                                                                               |
| publisher | string | No       | The image publisher.                                                                                                                                                                                                                                                                                                                                                                                                      |
| offer     | string | No       | Specifies the offer of the platform image or marketplace image used to create the virtual machine.                                                                                                                                                                                                                                                                                                                        |
| sku       | string | No       | The image SKU.                                                                                                                                                                                                                                                                                                                                                                                                            |
| version   | string | No       | Specifies the version of the platform image or marketplace image used to create the virtual machine. The allowed formats are Major.Minor.Build or 'latest'. Major, Minor, and Build are decimal numbers. Specify 'latest' to use the latest version of an image available at deploy time. Even if you use 'latest', the VM image will not automatically update after deploy time even if a new version becomes available. |

#### ManagedDiskParameters object

| Name               | Type   | Required | Value                                                                                                                                                                                                          |
| ------------------ | ------ | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| id                 | string | No       | Resource Id                                                                                                                                                                                                    |
| storageAccountType | enum   | No       | Specifies the storage account type for the managed disk. NOTE: UltraSSD\_LRS can only be used with data disks, it cannot be used with OS Disk. \- Standard\_LRS, Premium\_LRS, StandardSSD\_LRS, UltraSSD\_LRS |

#### VirtualHardDisk object

| Name | Type   | Required | Value                                  |
| ---- | ------ | -------- | -------------------------------------- |
| uri  | string | No       | Specifies the virtual hard disk's uri. |

### Tag object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

## History

| Date     | Change                                                                                                                                                                                                                                                                                                                                                                                                                                       |
| -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| 20181112 | Fix for missing OS Disk name by adding osdisk name function and expanding storage parameters as needed.                                                                                                                                                                                                                                                                                                                                      |
| 20181120 | Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template.                                                                                                                                                                                                                                                                                                                   |
| 20181205 | Adding support for ApplicationSecurityGroups as an optional parameter in the vm object.                                                                                                                                                                                                                                                                                                                                                      |
| 20181207 | Fix for new subscription and keyvault name.                                                                                                                                                                                                                                                                                                                                                                                                  |
| 20181214 | Implementing new template name as template.json                                                                                                                                                                                                                                                                                                                                                                                              |
| 20181217 | Merging John's updates for HA, AV and Backups.                                                                                                                                                                                                                                                                                                                                                                                               |
| 20181224 | Moving parameters inside vmArray & vmObject to make them specific to each VM rather than being Generic.                                                                                                                                                                                                                                                                                                                                      |
| 20190110 | Make autoshutdown optional. Make linuxScript optional. Changed how antimalware is detected as optional.                                                                                                                                                                                                                                                                                                                                      |
| 20190118 | Added optional parameter to encrypt VMs                                                                                                                                                                                                                                                                                                                                                                                                      |
| 20190125 | Removed the diagnostic storage account resource creation. Make sure to 1st create a storage resource called vmdiag in the resource group that will contain the deployed server before hand using the storage/20190125 template.                                                                                                                                                                                                              |
| 20190302 | Transformed the template to be resourcegroup deployed rather than subscription level deployed.                                                                                                                                                                                                                                                                                                                                               |
| 20190307 | Adding optional plan support for marketplace image requiring plan parameter                                                                                                                                                                                                                                                                                                                                                                  |
| 20190323 | Simplify keyvault password handling. Also introduce a template called azurermrg-isolate.json to enable proper deployment of servers using the masterdeploy template. Without it the is an issue with the validation due to the reference to the keyvaults resource that may not exist when the masterdeploy template is executed. The isolate template prevent Azure from trying to validate the presence of the yet to be created keyvault. |
| 20190324 | Add option to specify pre-defined static private IP for VM.                                                                                                                                                                                                                                                                                                                                                                                  |
| 20190326 | Move the user secret for domain join in a nested template to avoid requiring it to be defined in the azuredeploy.json template whan not used as an option.                                                                                                                                                                                                                                                                                   |
| 20190326 | Adding support for optional AADLoginForLinux parameter.                                                                                                                                                                                                                                                                                                                                                                                      |
| 20190326 | Moved virtualmachine to nested template to remove requirement to provide keyvault reference from azuredeploy.json. Also make code cleaner.                                                                                                                                                                                                                                                                                                   |
| 20190326 | Add support for optional linux disk encryption. Moved windows disk encryption as nested template.                                                                                                                                                                                                                                                                                                                                            |
| 20190401 | Add support for optional omsAgentForLinux and omsAgentForWindows configuration                                                                                                                                                                                                                                                                                                                                                               |
| 20190401 | Add support for optional omsAgdnsServerPrivateIp NIC configuration                                                                                                                                                                                                                                                                                                                                                                           |
| 20190506 | Update documentation. Change how DSCSettings is handled. Move plan parameters in vm object                                                                                                                                                                                                                                                                                                                                                   |