# # Creates a High Availability SQL Always-On Cluster

## Solution overview

This template uses the PowerShell DSC extension to deploy a fully configured Always On Availability Group with SQL Server  replicas.

This template creates the following resources:

+   1 storage account for the diagnostics
+   1 internal load balancer
+   1 availability set for SQL Server and Witness virtual machines
+   3 virtual machines in a Windows Server Cluster
    +    2 SQL Server edition replicas with an availability group
    +    1 virtual machine is a File Share Witness for the Cluster

### Credits
Original Code taken from https://github.com/Azure/azure-quickstart-templates/tree/master/sqlvm-alwayson-cluster

### Modifications
Version 2019-01-22 created by John Nephin (John.Nephin@tpsgc-pwgsc.gc.ca):
+   Modified template to use existing network instead of creating a new one
+   Modified template to use existing Active Directory instead of creating a new one
+   Added keyvault integration
+   Switched storage to managed disks
+   Removed Public IP's
+   Added backup and antimalare extensions at post deploy
+   Added retry loop to start availablity listener in CreateFailOvercluster DSC
+   Updated DSC packages for xSQL and xComputerManagement
+   Added code in DSC files to join servers at a passed in OU path
+   Added code to DSC to add the cluster permisions at the OU Path so Availability Lister could auto join

## Notes

+ 	File Share Witness and SQL Server VMs are from the same Availability Set and currently there is a constraint for mixing DS-Series machine, DS_v2-Series machine and GS-Series machine into the same Availability Set. If you decide to have DS-Series SQL Server VMs you must also have a DS-Series File Share Witness; If you decide to have GS-Series SQL Server VMs you must also have a GS-Series File Share Witness; If you decide to have DS_v2-Series SQL Server VMs you must also have a DS_v2-Series File Share Witness.

+ 	In default settings for compute require that you have at least 15 cores of free quota to deploy.

+ 	This has been tested with the following skus SQL2016SP2-WS2016 and SQL2017-WS2016.  
For a list of images run 
```Get-AzureRMVMImageOffer -Location canadacentral -Publisher MicrosoftSqlServer | Select Offer ```

##  TODO
+  Enable encryption on the disks and sql (TDE)
+  Research moving the cluster to an Azure Blob
+  Integrate the keystore for the server certificates
+  Research having cluster communication on seperate private network (best practice)

`Tags: SQL Server, AlwaysOn, High Availability, Cluster `