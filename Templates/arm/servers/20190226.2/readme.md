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

Optional VM object parameters are:

"availabilitySetName": Use this parameter in the desired vm object to provide the name of an existing Availability Set the VM should be part of.

"licenseType": Set value to "Windows_Server" when you are deploying windows machine. Don't put this parameter in Linux VMs

"applicationSecurityGroups": Array of objects that contain references to ApplicationSecurityGroup. This parameter is added inside the vm object and is structured as follow:

"applicationSecurityGroups":    [
                                    { "id": "[resourceId('Microsoft.Network/applicationSecurityGroups', 'testASG1')]" },
                                    { "id": "[resourceId('Microsoft.Network/applicationSecurityGroups', 'testASG2')]" }
                                ]

In the above example two ASGs named testASG1 and testASG2 are assigned to the VM. If you want fewer or more ASG associations simply remove or add lines between the []. If you want none make sure not to include the "applicationSecurityGroups" array in the vm config object or a deployment error will result.

"domainObject": Use this parameter in the desired vmObject to specify if a VM should join a Windows Domain. An example of what such a domainObject should contain is:

"domainObject":     {
                        "domainToJoin": "pspc.gc.ca.local",
                        "domainUsername": "azureadmin",
                        "domainJoinOptions": 3,
                        "ouPath": ""
                    }

"linuxScript": Use this parameter in the desired vmObject.vm to specify if the VM should run a linux script. An example of what such a linuxScript parameter should contain is:     

"linuxScript":      {
                        "commandToExecute": "['sudo sh linux-script.sh']"
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

"encryptDisks": Use this parameter in the desired vmObject.vm on a windows VM to specify that the disks should be encrypted with bitlocker. Example is:

"encryptDisks":         {
                            "keyVaultResourceGroup": "AzPwS01-Infra-Temp-RG",
                            "keyVaultName": "AzPwS01-TST-Encr-KV"
                        }

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

VM parameters Examples:

See deploy-servers.parameters-sample.json for examples