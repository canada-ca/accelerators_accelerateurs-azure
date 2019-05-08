# Template Name

## Introduction

This template is used to deploy sql reporting services.

## Security Controls

The following security controls can be met through configuration of this template:

* Unknown

## Dependancies

The following items are assumed to exist already in the deployment:

* [Resource Group](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md>)
* [Storage](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/storage/latest/readme.md>)
* [Virtal Network](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/vnet-subnet/latest/readme.md>)
* [KeyVault](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/keyvaults/latest/readme.md>)
* [Backup Vault](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/backup/latest/readme.md>)
* [Active Directory](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/active-directory/latest/README.md>)

## Parameter format

```JSON
{
    "$schema": "https://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
    "contentVersion": "1.0.0.0",
    "parameters": {
        "containerSasToken": {
            "value": "[SasToken]"
        },
        "sqlSettings": {
            "value": {
                "dbSAUsername": "shared\\azureadmin",
                "dbSAUserPasswordKey": "server2016DefaultPassword",
                "sqlLB": "10.250.29.4"
            }
        },
        "vmBaseUrl": {
            "value": "https://azpwsdeployment.blob.core.windows.net/library/arm/servers/20190219.4/servers.json"
        },
        "vmObject": {
            "value": {
                "comment": "This is for the sql server reporting services",
                "resourceGroup": "Demo-SSRS-RG",
                "vmKeyVault": {
                    "keyVaultResourceGroupName": "Demo-KeyVault-RG",
                    "keyVaultName": "Demo-Keyvault",
                    "vaultCertificates": [
                        {
                            "certificateUrl": "https://demo-keyvault.vault.azure.net/secrets/demo/0d4e51ee911c4a8ca4a117d4060ca4e6",
                            "certificateStore": "My"
                        }
                    ]
                },
                "domainObject": {
                    "domainToJoin": "demo.gc.ca.local",
                    "domainUsername": "azureadmin",
                    "domainAdminPasswordKey": "adDefaultPassword",
                    "domainJoinOptions": 3,
                    "ouPath": "OU=Windows,OU=Servers,OU=PSPC,DC=shared,DC=azpws01,DC=pspc,DC=gc,DC=ca,DC=local"
                },
                "numberOfVMInstances": 1,
                "deploymentSuffix": "Demo-CRMRS",
                "vm": {
                    "computerName": "Demo-RS",
                    "adminUsername": "azureadmin",
                    "licenseType": "Windows_Server",
                    "shutdownConfig": {
                        "autoShutdownStatus": "Enabled",
                        "autoShutdownTime": "19:00",
                        "autoShutdownTimeZone": "Eastern Standard Time",
                        "autoShutdownNotificationStatus": "Disabled"
                    },
                    "vmSize": "Standard_DS3_v2",
                    "bootDiagnostic": true,
                    "backupConfig": {
                        "existingBackupVaultRG": "Demo-Backup-RG",
                        "existingBackupVaultName": "Demo-Backup-Vault",
                        "existingBackupPolicy": "DailyBackupPolicy"
                    },
                    "storageProfile": {
                        "osDisk": {
                            "createOption": "fromImage",
                            "caching": "ReadWrite",
                            "managedDisk": {
                                "storageAccountType": "StandardSSD_LRS"
                            }
                        },
                        "dataDisks": [],
                        "imageReference": {
                            "publisher": "MicrosoftSQLServer",
                            "offer": "SQL2016SP2-WS2016",
                            "sku": "Enterprise",
                            "version": "latest"
                        }
                    },
                    "availabilitySetName": "Demo-RS-AS"
                },
                "networkSecurityGroups": {
                    "name": "Demo- RS-NSG",
                    "properties": {
                        "securityRules": []
                    }
                },
                "networkInterfaces": {
                    "name": "Demo-RS1-NIC",
                    "acceleratedNetworking": false,
                    "vnetResourceGroupName": "Demo-Infra-NetShared-RG",
                    "vnetName": "Demo-Infra-NetShared-VNET",
                    "subnetName": "APP-CRM"
                },
                "tagValues": {
                    "Owner": "demo.user@here.com",
                    "CostCenter": "DemoCC",
                    "Enviroment": "Sandbox",
                    "Classification": "Unclassified",
                    "Organizations": "Demo",
                    "DeploymentVersion": "2019-01-24",
                    "Workload": "Report Server"
                }
            }
        }
    }
}
```

## Parameter Values

### Main Template

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|containerSasToken |string |No      |A SaS token for the private blob storage |
|sqlSettings |object |Yes      |Settings for the SQL database to connect to. - [sqlSettings Object](###sqlsettings-object) |
|vmBaseUrl |string |Yes      |Url to the servers tempalte to use for the deployment. |
|vmObject |object |Yes      |VM Settings for the reporting server -  [vmObject Object](###vm-object) |

### SQL Settings object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|dbSAUsername |string |Yes      |The database user account |
|dbSAUserPasswordKey |string |Yes      |The secret name for the database password stored in keyvault. |
|sqlLB |string |Yes      |The IP address for the load balencer. |

### VMObject object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|resourceGroup |string |Yes      |The resource group for the deployment |
|vmKeyVault |object |Yes      |The keyvault settings to use for the vm -[vmKeyVault Object](###vmkeyvault-object) |
|domainObject |object |Yes      |The domain settings to use for the vm -[domainObject Object](###domainobject-object) |
|deploymentSuffix |string |Yes      |Prefix used for the deployment objects.  |
|vm |object |Yes      |The settings for the VM -[vm Object](<https://github.com/canada-ca/accelerators_accelerateurs-azure/tree/master/Templates/arm/servers/latest#vm-object>)  |
|networkSecurityGroups |object |Yes      |The settings for the VM -[networkSecurityGroups Object](<https://github.com/canada-ca/accelerators_accelerateurs-azure/tree/master/Templates/arm/servers/latest#networksecuritygroups-object>)  |
|networkInterfaces |object |Yes      |The settings for the VM -[networkInterfaces Object](<https://github.com/canada-ca/accelerators_accelerateurs-azure/tree/master/Templates/arm/servers/latest#networkinterfaces-object>)  |
|tagValues |object |Yes      |The settings for the VM -[tagValues Object](###tagvalues-object)  |

### vmKeyVault object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|resourceGroup |string |Yes      |The resource group name for the existing Keyvault |
|keyVaultName |string |Yes      |The name of the existing Keyvault |
|vaultCertificates |object |No      |The certificates to deploy to the VM - [vaultCertificates Object](###vaultcertificates-object) |

### vaultCertificates object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|resourceGcertificateUrl |string |Yes      |The secret url for the certificate. |
|certificateStore |string |Yes      |The certificate store on the vm to place the certificate. |

### domainObject object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|domainToJoin |string |Yes      |The name of the domain to join. |
|domainUsername |string |Yes      |The domain account name used to join the machine to the domain. |
|domainAdminPasswordKey |string |Yes      |The secret name for the keyvault password used to join the machine to the domain. |
|domainJoinOptions |int |Yes      |Set of bit flags that define the join options. Default value of 3 is a combination of NETSETUP_JOIN_DOMAIN (0x00000001) & NETSETUP_ACCT_CREATE (0x00000002) i.e. will join the domain and create the account on the domain. For more information see https://msdn.microsoft.com/en-us/library/aa392154(v=vs.85).aspx. |
|ouPath |string |Yes      |The ogranization unit to join the machine to. |

### tagValues object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

## Future Enhancements

* Make sql database features optional

## History

|Date       | Change                |
|-----------|-----------------------|
|20190219 | Intial version|
|20190222 | Cleanup of unused variables|
|20190329 | Fixes to make parameters optional and clean up functions|
|20190402 | Support for HTTPS and added sleep to cluster test to allow it to initialize|
