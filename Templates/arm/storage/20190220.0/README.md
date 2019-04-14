# Introduction 
This module creates a storage account and optionaly containers within.

# Parameters
- **resourceGroup (string):**  Name of resource group to create the storage account in
- **storageAccountPrefix (string):**  Prefix for naming the storage account.  A unique string will be added to ensure uniquness.
- **accountType (string):**  The storage account type (see Microsoft.Storage/storageAccounts).
- **kind (string)**  Indicates the type of storage account. - Storage, StorageV2, BlobStorage, FileStorage, BlockBlobStorage 
- **supportsHttpsTrafficOnly (bool):** Allows https traffic only to storage service if sets to true.
- **containerName (string array):** Optional. List of containers to create
- **advancedThreatProtectionEnabled (bool):** Optional. Detects anomalies in account activity and notifies you of potentially harmful attempts to access your account.  Contains additional costs.  Default is false.  See https://docs.microsoft.com/en-us/azure/storage/common/storage-advanced-threat-protection

<!--
# Getting Started
TODO: Guide users through getting your code up and running on their own system. In this section you can talk about:
1.	Installation process
2.	Software dependencies
3.	Latest releases
4.	API references

# Build and Test
TODO: Describe and show how to build your code and run the tests. 
-->

# Contribute
See contribution guide in master project 

# Changelog
**20190221:** Fix issue with storage object that did not contain an optional containerName array. Updated sample parameter file with example of storage object containing an optional containerName.