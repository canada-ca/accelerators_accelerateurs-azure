Template parameter documentation:

All servers deployed via this template will have private static IP instead of dynamic IP.

Updates:

20181112: Fix for missing OS Disk name by adding osdisk name function and expanding storage parameters as needed.

20181120: Adding helpers folder and getParameters.json template to provide method to read parameter files from parent link template.

20181205: Adding support for ApplicationSecurityGroups as an optional parameter in the vm object.

20181207: Fix for new subscription and keyvault name.

20181214: Implementing new template name as template.json

20181217: Merging John's updates for HA, AV and Backups.

20181224: Moving parameters inside vmArray & vmObject to make them specific to each VM rather than being Generic.

20190110: Make autoshutdown optional. Make linuxScript optional. Changed how antimalware is detected as optional.

20190118: Added optional parameter to encrypt VMs

20190125: Removed the diagnostic storage account resource creation. Make sure to 1st create a storage resource called vmdiag in the resource group that will contain the deployed server before hand using the storage/20190125 template.

20190302: Transformed the template to be resourcegroup deployed rather than subscription level deployed.

20190307: Adding optional plan support for marketplace image requiring plan parameter

20190323: Simplify keyvault password handling. Also introduce a template called azurermrg-isolate.json to enable proper deployment of servers using the masterdeploy template. Without it the is an issue with the validation due to the reference to the keyvaults resource that may not exist when the masterdeploy template is executed. The isolate template prevent Azure from trying to validate the presence of the yet to be created keyvault.

20190324: Add option to specify pre-defined static private IP for VM.

**20190326:** Move the user secret for domain join in a nested template to avoid requiring it to be defined in the azuredeploy.json template whan not used as an option.

**20190326:** Adding support for optional AADLoginForLinux parameter.

**20190326:** Moved virtualmachine to nested template to remove requirement to provide keyvault reference from azuredeploy.json. Also make code cleaner.

**20190326** Add support for optional linux disk encryption. Moved windows disk encryption as nested template.

**Optional VM object parameters are:**

"availabilitySetName": Use this parameter in the desired vm object to provide the name of an existing Availability Set the VM should be part of.

"licenseType": Set value to "Windows_Server" when you are deploying windows machine. Don't put this parameter in Linux VMs

"applicationSecurityGroups": Array of objects that contain references to ApplicationSecurityGroup. This parameter is added inside the vm object and is structured as follow:

"applicationSecurityGroups":    [
                                    { "id": "[resourceId('Microsoft.Network/applicationSecurityGroups', 'testASG1')]" },
                                    { "id": "[resourceId('Microsoft.Network/applicationSecurityGroups', 'testASG2')]" }
                                ]

In the above example two ASGs named testASG1 and testASG2 are assigned to the VM. If you want fewer or more ASG associations simply remove or add lines between the []. If you want none make sure not to include the "applicationSecurityGroups" array in the vm config object or a deployment error will result.

"domainObject": Use this parameter in the desired vmObject to specify if a VM should join a Windows Domain. The secret name specified in the "domainUserSecretName" parameter need to exist in the keyvault referenced by the VM to deploy properly. An example of what such a domainObject should contain is:

"domainObject":     {
                        "domainToJoin": "pspc.gc.ca.local",
                        "domainUsername": "azureadmin",
                        "domainUserSecretName": "adDefaultPassword",
                        "domainJoinOptions": 3,
                        "ouPath": ""
                    }

"linuxScript": Use this parameter in the desired vmObject.vm to specify if the VM should run a linux script. Information on what can go in the protectedSettings portion can be foud at https://docs.microsoft.com/en-us/azure/virtual-machines/extensions/custom-script-linux

An example of what such a linuxScript parameter should contain is:     

"linuxScript":          {
                            "comment": "The code in script is coded with cat script.sh | base64 -w0",
                            "protectedSettings": {
                                "script": "IyEvYmluL3NoCmVjaG8gIkluc3RhbGxpbmcgZG9ja2VyLi4uIgpzdWRvIHNuYXAgaW5zdGFsbCBkb2NrZXIK"
                            }
                        }

"shutdownConfig": Use this parameter in the desired vmObject.vm to specify if the VM should automatically shutdown at the specified time. An example of what such a shutdownConfig parameter should contain is:

"shutdownConfig":       {
                            "autoShutdownStatus": "Enabled",
                            "autoShutdownTime": "17:00",
                            "autoShutdownTimeZone": "Eastern Standard Time",
                            "autoShutdownNotificationStatus": "Disabled"
                        }

"antimalwareInfo": Use this parameter in the desired vmObject.vm to specify if the VM should be configured with antimalware. An example of what such a antimalwareInfo parameter should contain is:

"antimalwareInfo":      {
                            "exclusionPaths": "c:\\Users",
                            "exclusionExtensions": ".txt; .ps1",
                            "exclusionProcesses": "w3wp.exe;explorer.exe",
                            "realtimeProtectionEnabled": "true",
                            "scheduledScanSettingsEnabled": "false",
                            "scheduledScanSettingsType": "Quick",
                            "scheduledScanSettingsDay": "1",
                            "scheduledScanSettingsTime": "120"
                        }

"backupConfig": Use this parameter in the desired vmObject.vm to specify if the VM should be backedup. An example of what such a backupConfig parameter should contain is:

"backupConfig":     {
                        "existingBackupVaultRG": "AzPwS01-Infra-Backup-RG",
                        "existingBackupVaultName": "AzPwS01-Infra-Backup-Vaultt",
                        "existingBackupPolicy": "DailyBackupPolicy"
                    }

"encryptDisks": Use this parameter in the desired vmObject.vm on a windows VM to specify that the Windows disks should be encrypted with bitlocker. Example is:

    "encryptDisks": { }

"encryptDisksLinux": Use this parameter in the desired vmObject.vm on a windows VM to specify that the linux disks should be encrypted. Example is:

    "encryptDisksLinux": { }

"dataDisks": Use this parameter in the desired vmObject.vm.datadisk to specify the one or more datadisks are required. Example is:

                                {
                                    "diskSizeGB": "1024",
                                    "lun": 0,
                                    "createOption": "Empty",
                                    "managedDisk": {
                                        "storageAccountType": "StandardSSD_LRS"
                                    }
                                },
                                {
                                    "diskSizeGB": "512",
                                    "lun": 1,
                                    "createOption": "Empty",
                                    "managedDisk": {
                                        "storageAccountType": "StandardSSD_LRS"
                                    }
                                }

"plan": Use this parameter to specify plan information for marketplace disk image that requires it. Add this object at the vmArray object level (same level as the vm object). Here is an example:

"vm":               { 
                        a bunch of parameters
                    },
"plan":             {
                        "name": "1-9",
                        "publisher": "bitnami",
                        "product": "nginxstack"
                    }

"DSCSettings": Use this parameter in the desired vmObject.vm on a windows VM to specify the use of a DSC during the server deployment. An example of such a parameter object look like:

                        "DSCSettings": {
                            "url": "https://azpwsdeployment.blob.core.windows.net/dsc/helloworld/helloworld.zip",
                            "script": "helloworld.ps1",
                            "function": "helloworld"
                        }

"privateIPAddress": Use this optional parameter in the desired vmObject.networkInterfaces to specify the desires private static IP for the NIC. Following is an example of the use of this parameter:

"networkInterfaces": {
                        "name": "NIC1",
                        "publicIPAddressName": "NIC1-PubIP",
                        **"privateIPAddress": "10.96.96.124",**
                        "acceleratedNetworking": false,
                        "vnetResourceGroupName": "PwS2-validate-servers-1-RG",
                        "vnetName": "PwS2-validate-servers-1-VNET",
                        "subnetName": "test1"
                     }

"AADLoginForLinux" : Use this optional parameter in the desired vmObject to specify the desires private static IP for the NIC. Following is an example of the use of this parameter:

    "AADLoginForLinux": {}

VM parameters Examples:

See deploy-servers.parameters-sample.json for examples