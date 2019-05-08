# High Availability SQL Always-On Cluster

## Introduction

This template uses the PowerShell DSC extension to deploy a fully configured Always On Availability Group with SQL Server  replicas.

This template creates the following resources:

* 1 storage account for the diagnostics
* 1 internal load balancer
* 1 availability set for SQL Server and Witness virtual machines
* 3 virtual machines in a Windows Server Cluster
    * 2 SQL Server edition replicas with an availability group
    * 1 virtual machine is a File Share Witness for the Cluster

Original code modified from SQL VM Alwayson Cluster (<https://github.com/Azure/azure-quickstart-templates/tree/master/sqlvm-alwayson-cluster>>

## Security Controls

The following security controls can be met through configuration of this template:

* [Information at Rest](documentation/Information-at-Rest.md): SC-28, SC-28 (1).
* [SQL Transation Backup](documentation/SQL-Transaction-Backup.md): CP-10 (2).

To fully meet Information at Rest controls you should run [Disk Encryption](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/servers-encryptVMDisks/latest/readme.md>) post install.

## Dependancies

The deployment assumes the following items are already deployed:

* [Resource Group](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md>)
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
        "keyVaultConfig": {
            "value": {
                "existingRGName": "Demo-Shared-CRM-KeyVault-RG",
                "existingVaultName": "Demo-CRMSQL-Keyvault",
                "localAdminPasswordSecret": "server2016DefaultPassword",
                "domainAdminPasswordSecret": "adDefaultPassword"
            }
        },
        "vnetConfig": {
            "value": {
                "existingVnetName": "Demo-Infra-NetShared-VNET",
                "existingVnetRG": "Demo-Infra-NetShared-RG",
                "sqlSubnet": "10.10.29.0/26",
                "dbSubnetName": "DB-CRM"
            }
        },
        "location": {
            "value": "canadacentral"
        },
        "adminUsername": {
            "value": "azureadmin"
        },
        "dnsServerName":{
            "value": "DemoShdDC01"
        },
        "sqlServerConfig": {
            "value": {
                "ClusterIp": "169.254.1.1",
                "sqlLBIPAddress": "10.10.29.4",
                "sqlAOListenerPort": "1433",
                "deploymentPrefix": "Demo-CRMSQL",
                "vmSize": "Standard_DS3_v2",
                "vmName": "Demo-CRMSQL",
                "patchingConfig": {
                    "autoPatchingEnabled": true,
                    "autoPatchingDay": "Sunday",
                    "autoPatchingStartHour": "2",
                    "autoPatchingMainenanceWindowDuration": 60,
                    "autoUpgradeMinorVersion": true
                },
                "backupConfig": {
                    "backupEnabled": true,
                    "RetentionPeriod": 30,
                    "EnableEncryption": true
                },
                "imageReference": {
                    "sqlImagePublisher": "MicrosoftSQLServer",
                    "offer": "SQL2016SP2-WS2016",
                    "sku": "Enterprise",
                    "version": "latest"
                },
                "dataDisks": {
                    "numberOfSqlVMDisks": "2",
                    "diskSizeGB": "1024"
                },
                "workloadType": "OLTP",
                "sqlServerServiceAccountUserName": "svc-crmsql",
                "sqlStorageAccountName": "crmsqlstorage01",
                "sqlStorageAccountType": "Standard_LRS",
                "sqlDatabases": "ReportServer",
                "sqlServerServiceAccountPassword": "sqlServerServiceAccountPassword",
                "enableAcceleratedNetworking": true
            }
        },
        "witnessServerConfig": {
            "value": {
                "vmSize": "Standard_DS2_v2",
                "vmName": "Demo-CRMSQLW",
                "imageReference": {
                    "publisher": "MicrosoftWindowsServer",
                    "offer": "WindowsServer",
                    "sku": "2016-Datacenter",
                    "version": "latest"
                },
                "dataDisks": {
                    "diskSizeGB": "128"
                },
                "sqlStorageAccountType": "Standard_LRS",
                "enableAcceleratedNetworking": true
            }
        },
        "adConfig":
        {
            "value": {
                "domainName": "shared.demo.gc.ca",
                "serverOUPath":"OU=Windows,OU=Servers,OU=Demo,DC=shared,DC=Demo,DC=Demo,DC=gc,DC=ca,DC=local",
                "accountOUPath": "OU=Service Accounts,OU=Demo,DC=shared,DC=Demo,DC=Demo,DC=gc,DC=ca,DC=local"
            }
        },
        "backupConfig": {
            "value": {
                "existingBackupVaultRG": "Demo-Shared-CRM-Backup-RG",
                "existingBackupVaultName": "Demo-Shared-CRM-Backup-Vault",
                "existingBackupPolicy": "DailyBackupPolicy"
            }
        },
        "tagValues": {
            "value": {
                "workload": "Database",
                "owner": "demo.user@demo.ca",
                "businessUnit": "Demo-CCC",
                "costCenterOwner": "Demo-EA",
                "environment": "Sandbox",
                "classification": "Unclassified",
                "version": "0.1"
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
|keyVaultConfig |object |Yes      |Information about the existing keyVault to use[KeyVaultConfig Object](###keyvaultconfig-object) |
|vnetConfig|object |Yes      |Information about the existing vnet to use[vnetConfig Object](###vnetconfig-object) |
|location|string |No      |The location to deploy the resources - canadacentral, canadaeast.  Default is canadacentral |
|adminUserName|string |Yes      |The local administrator name to use for the VM. |
|domainUserName|string |Yes      |The local administrator name to use for joining the domain and creating the service accounts. |
|dnsServerName|string |Yes      |The existing DNS Server name. |
|sqlServerConfig|object |Yes      |The SQL Server configuration options for the primary and secondary server- [sqlServerConfig object](###sqlserverconfig-object) |
|witnessServerConfig|object |Yes      |The SQL witness configuration options - [witnessServerConfig object](###witnessserverconfig-object). |
|adConfig|string |object      |The Active Directory configuration. - [adConfig object](###adconfig-object) |
|backupConfig|object |Yes      |The backup configuration. [backupConfig Object](###backupconfig-object) |
|tagValues|object |No     |The tags to set for the deployment.  - [tagValues object](###tagvalues-object) |

### KeyVaultConfig object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|existingRGName |string|Yes|The name of the existing keyvault resource group |
|existingVaultName|string|Yes| The name of the existing keyvault to use      |
|localAdminPasswordSecret|string|Yes|The name of the secret where the password is stored for local admin password|
|domainAdminPasswordSecret|string|Yes|The name of the secret where the password is stored for a domain account that can be used to create service accounts and to join the domain|

### vnetConfig object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|existingVnetName|string|Yes|The name of the existing virtual network where sql will reside|
|existingVnetRG|string|Yes|The name of the existing virtual network resource group|
|sqlSubnet|string|Yes|The subnet address range for where SQL will reside|
|dbSubnetName|string|Yes|The name of the subnet where SQL will reside|

### sqlServerConfig object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|ClusterIp|string|Yes|The IP to use for the SQL cluster. |
|sqlLBIPAddress|string|Yes|The IP to use for the SQL load balencer|
|sqlAOListenerPort|string|Yes|The port for the alwayson listener|
|deploymentPrefix|string|Yes|The deployment prefix to use for the naming standard of the objects.|
|vmSize|enum|Yes|Specifies the size of the virtual machine. For more information about virtual machine sizes, see [Sizes for virtual machines](<https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-03-01/virtualmachines#HardwareProfile>).|
|vmName"|string|Yes|The name of the VM to use|
|patchingConfig|object|Yes|The patching settings for the VM - [patchingConfig oject](###patchingconfig-object)|
|sqlBackupConfig|object|Yes|The backup settings for the VM - [sqlBackupConfig oject](###sqlbackupconfig-object)|
|imageReference|object|Yes|The image settings for the VM - [imageReference object](###imagereference-object)|
|dataDisks|object|Yes|The data disk settings for the VM - [dataDisks object](###datadisks-object)|
|workloadType|enum|Yes|The workload type for SQL - GENERAL, OLTP, DW|
|sqlServerServiceAccountUserName|string|Yes|The name to use for the SQL service account|
|sqlStorageAccountName|string|Yes|The name of the storage account for SQL|
|sqlStorageAccountType|enum|Yes|The storage type to use for the disks -  Standard_LRS, Premium_LRS, StandardSSD_LRS, UltraSSD_LRS |
|sqlDatabases|string|Yes|The name of the first database to create with always on|
|sqlServerServiceAccountPassword|string|Yes|The name of the keyvault secret where service account password is stored |
|enableAcceleratedNetworking|bool|Yes|Indicates if to use accelerated networking or not.|

### witnessServerConfig object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|vmSize|enum|Yes|Specifies the size of the virtual machine. For more information about virtual machine sizes, see [Sizes for virtual machines](<https://docs.microsoft.com/en-us/azure/templates/microsoft.compute/2019-03-01/virtualmachines#HardwareProfile>).|
|vmName|string|Yes|The name of the SQL cluster.|
|imageReference|object|Yes|The image settings for the VM - [imageReference object](###imagereference-object)|
|dataDisks|object|Yes|The data disk settings for the VM - [dataDisks object](###datadisks-object)|
|sqlStorageAccountType|enum|Yes|The type of storage to use. - Standard_LRS, Standard_GRS, Standard_RAGRS, Standard_ZRS, Premium_LRS, Premium_ZRS|
|enableAcceleratedNetworking|bool|Yes|Indicates if to use accelerated networking or not.|

### adConfig object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
 |domainName|string|Yes|The domain to join the servers to.|
|serverOUPath|string|Yes|The OU Path to join the servers to.|
|accountOUPath|string|Yes|The OU Path to create the service accounts.|

### backupConfig object

|Name        |Type   |Required |Value                               |
|------------|-------|---------|------------------------------------|
|existingBackupVaultRG|string|Yes|The name of the existing backup vault resource group.|
|existingBackupVaultName|string|Yes|The name of the existing backup vault.|
|existingBackupPolicy|string|Yes|The name of the existing backup policy to use.|

### tagValues object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

### patchingConfig Object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
|autoPatchingEnabled|bool|Yes|Indicates if auto patching should be enabled|
|autoPatchingDay|string|Yes|The day of the week to do the patching|
|autoPatchingStartHour|string|Yes|The hour to start the patching|
|autoPatchingMainenanceWindowDuration|int|Yes|The maintenance window duration in minutes|
|autoUpgradeMinorVersion|bool|Yes|Indicates if to apply minor updates|

### sqlBackupConfig object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
|backupEnabled|bool|Yes|Indicates if backup should be enabled on the VM|
|RetentionPeriod|int|Yes|Specifies the retention period of the encryption|
|EnableEncryption|bool|Yes|Indicates if to enable encryption or not|

### imageReference object
| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
|sqlImagePublisher|string|Yes|The name of the image publisher|
|offer|string|Yes|The SQL image to use|
|sku|enum|Yes|The SQL sku to use - Enterprise,Express, SQLDEV, Standard, Web|
|version|string|Yes|The sql template version to use. Use "latest" for the most current|  

### dataDisks object
| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
|numberOfSqlVMDisks|int|Yes|The number of data disks to create|
|diskSizeGB|string|Yes|The size of the disk in GB|

## Additional Notes

*File Share Witness and SQL Server VMs are from the same Availability Set and currently there is a constraint for mixing DS-Series machine, DS_v2-Series machine and GS-Series machine into the same Availability Set. If you decide to have DS-Series SQL Server VMs you must also have a DS-Series File Share Witness; If you decide to have GS-Series SQL Server VMs you must also have a GS-Series File Share Witness; If you decide to have DS_v2-Series SQL Server VMs you must also have a DS_v2-Series File Share Witness.

* In default settings for compute require that you have at least 15 cores of free quota to deploy.

*This has been tested with the following skus SQL2016SP2-WS2016 and SQL2017-WS2016.  

For a list of images run the following in Powershell:

```Powershell
Get-AzureRMVMImageOffer -Location "canadacentral" -Publisher "MicrosoftSqlServer" | Select Offer
```

For a list of image skus run the following in Powershell:

```Powershell
Get-AzureRmVMImageSku -Location "canadacentral"-Publisher "MicrosoftSQLServer" -Offer "SQL2016SP2-WS2016" | Select Skus
```

## Future Enhancements

* Option for moving the cluster to an Azure Blob
* Integrate the keystore for the server certificates
* Research having cluster communication on seperate private network (best practice)
* Modify template to use servers templates

## History

|Date       | Change                |
|-----------|-----------------------|
|2019-01-22 | Modified template to use existing network instead of creating a new one.|
||Modified template to use existing Active Directory instead of creating a new one.|
| |Added keyvault integration.|
| |Switched storage to managed disks.|
| |Removed Public IP's.|
| |Added backup and antimalare extensions at post deploy.|
| |Added retry loop to start availablity listener in CreateFailOvercluster DSC.|
| |Updated DSC packages for xSQL and xComputerManagement.|
| |Added code in DSC files to join servers at a passed in OU path.|
| |Added code to DSC to add the cluster permisions at the OU Path so Availability Lister could auto join|
|2019-05-08 | Updated documentation and switch to new sql-server type.|