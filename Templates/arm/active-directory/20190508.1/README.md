# Template Name

## Introduction

This template will create an Active Directory forest with 1 or 2 domains, each with 1 or 2 DCs.

The template creates the following: 

* The root domain is always created; the child domain is optional.
* Choose to have one or two DCs per domain.
* Choose names for the Domains, DCs, and network objects.  
* Choose the VM type from a prepopulated list.
* Use either Windows Server 2012, Windows Server 2012 R2, or Windows Server 2016.

A forest with two domains in Azure is especially useful for AD-related
development, testing, and troubleshooting. Many enterprises have complex
Active Directories with multiple domains, so if you are developing an
application for such companies it makes a lot of sense to use a
multi-domain Active Directory as well.

The Domain Controllers are placed in an Availability Set to maximize uptime. Each domain has its own Availability set.

The VMs are provisioned with managed disks.  Each VM will have the AD-related management tools installed.

## Security Controls

The following security controls can be met through configuration of this template:

* Unknown.

## Dependancies

The following items are assumed to exist already in the deployment:

* [Resource Group](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/resourcegroups/latest/readme.md>)
* [Virtal Network](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/vnet-subnet/latest/readme.md>)
* [KeyVault](<https://github.com/canada-ca/accelerators_accelerateurs-azure/blob/master/Templates/arm/keyvaults/latest/readme.md>)

## Parameter format

```JSON
{
  "$schema": "http://schema.management.azure.com/schemas/2015-01-01/deploymentParameters.json#",
  "contentVersion": "1.0.0.0",
  "parameters": {
    "keyVaultResourceGroupName": {
      "value": "Demo-Keyvault-RG"
    },
    "keyVaultName": {
       "value": "Demo-Keyvault-MGMT"
    },
    "DomainName": {
      "value": "demo.gc.ca.local"
    },
    "createChildDomain": {
      "value": false
    },
    "ChildDomainName": {
      "value": "mgmt"
    },
    "VMSize": {
      "value": "Standard_B2ms"
    },
    "vnetRG": {
      "value": "Demo-NetMGMT-RG"
    },
    "vnetName": {
      "value": "Demo-NetMGMT-VNET"
    },
    "vnetAddressRange": {
      "value": "10.10.0.0/20"
    },
    "adSubnetName": {
      "value": "APP"
    },
    "adSubnet": {
      "value": "10.10.1.0/24"
    },
    "RootDC1Name": {
      "value": "Demo-RootDC01"
    },
    "RootDC1IPAddress": {
      "value": "10.10.1.8"
    },
    "RootDC2Name": {
      "value": "demo-RootDC01"
    },
    "RootDC2IPAddress": {
      "value": "10.10.1.9"
    },
    "ChildDC3Name": {
      "value": "Demo-MgmtDC01"
    },
    "ChildDC3IPAddress": {
      "value": "10.10.1.10"
    },
    "ChildDC4Name": {
      "value": "Demo-MgmtDC02"
    },
    "ChildDC4IPAddress": {
      "value": "10.10.1.11"
    },
    "tagValues": {
      "value": {
          "workload": "Domain Controller",
          "owner": "demo.user@demo.gc.ca",
          "businessUnit": "DEMO-CCC",
          "costCenterOwner": "DEMO-CCC",
          "environment": "Sandbox",
          "classification": "Unclassified",
          "version": "0.4"
      },
      "ReverseZoneObject": {
        "value":["2.10.10", "1.10.10"]
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
|keyVaultResourceGroupName |string |Yes      |Name of the existing resource group for the keyvault |
|keyVaultName |string |Yes      |Name of the existing keyvault |
|DomainName |string |Yes      |Full qualified domain name for the forest root domain |
|createChildDomain |bool |No      |Indicates whether or not to create the child domain.  Default is false |
|ChildDomainName |string |No      |Full qualified domain name for the child domain |
|VMSize |enum |Yes      |Size for the VM's.   See available [VM Sizes](<https://docs.microsoft.com/rest/api/compute/virtualmachines/listavailablesizes>) for more details|
|vnetRG |string |Yes      |Name of the resource group for the virtual network that will be used by the VMs.|
|vnetName |string |Yes      |name of the virstual network that will be used by the VMs.|
|vnetAddressRange |string |Yes      |The virtual networks address range|
|adSubnetName |string |Yes      |The name of the subnet in which to place the active directory servers|
|adSubnet |string |Yes      |The address space for the ad subnet|
|RootDC1Name |string |Yes      |The name of the root domain controller|
|RootDC1IPAddress |string |Yes      |The IP address to use for the root domain controller|
|RootDC2Name |string |Yes      |The secondary root domain controller name|
|ChildDC3Name |string |No      |The child domain controller name|
|ChildDC3IPAddress |string |No      |The child domain controller IP address|
|ChildDC4Name |string |No      |The secondary child domain controller name|
|ChildDC4IPAddress |string |No      |The secondary child domain controller IP address|
|ReverseZoneObject |array |No      |String array of reverse zone objects to create|
|tagValues|object |No     |The tags to set for the deployment.  - [tagValues object](###tagvalues-object) |

### tagValues object

| Name     | Type   | Required | Value      |
| -------- | ------ | -------- | ---------- |
| tagname1 | string | No       | tag1 value |
| ...      | ...    | ...      | ...        |
| tagnameX | string | No       | tagX value |

### Credits

This project was initially copied from the
[active-directory-new-domain-ha-2-dc](https://github.com/Azure/azure-quickstart-templates/tree/master/active-directory-new-domain-ha-2-dc)
project by Simon Davies, part of the the Azure Quickstart templates.

### Additional Information

The following are additional notes from the original creator.

#### DNS

The hard part about creating forests, domains and Domain Controllers in Azure is the managing of DNS Domains and zones, and DNS references. AD strongly depends on its own DNS domains, and during domain creation the relevant zones must be created. On the other hand, Azure VMs _must_ have internet connectivity for their internal Azure Agent to work.

To meet this requirement, the DNS reference in the IP Settings of each VM must be changed a couple of times during deployment. The design choice I made was to appoint the first VM as master DNS server. It will resolve externally, and this is why the configuration asks you to supply an external forwarder. In the end situation, the VNET has two DNS servers pointing to the forest root domain, so any new VM you add to the VNET will have a working DNS allowing it to find the AD zones and the internet domains.

I also had to look carefully at the order in which the VMs are provisioned.
Initially I created the root domain on DC1. Then, I promoted DC2 (root)
and DC3 (child) at the same time. After much testing I discovered that this
would _sometimes_ go wrong because DC3 would take DC2 as a DNS source
when it was not ready. So I reordered the dependencies to first promote
 DC1 (root), then DC3 (child), and only then add secondary DCs to both domains.

#### Desired State Configuration (DSC)

The main requirement when I started this project was that I wanted a one-shot template deployment of a working forest without additional post-configuration. Clearly, to create an AD forest you must do stuff inside all VMs, and different stuff depending on the domain role. I saw two ways to accomplish this: script extensions and DSC.

After some consideration I decided to use DSC to re-use whatever existing IP is out there, and to avoid having to develop everything myself. Less did I realize that this also means that I have accept the limitations that go along with it: if the DSC module does not support it, you can't have it. One such example is creation of a tree domain in the same forest, such as a root of _contoso.com_ and another tree of 
_fabrikam.com_. The DSC for Active Directory does not currently (feb 2017)
allow this.

In this project I have only used widely accepted DSC modules to avoid developing or maintaining my own:

* xActivedirectory
* xNetworking
* xStorage
* cDisk

If you look into the DSC Configurations that I use you will see that I had to add Script resource to set the DNS forwarder. This is unfortunate (a hack) but the xDNSServer DSC module did not work for me. Apparently the DNS service is not stable enough directly after installation to support this module. I added a wait loop to solve this issue. 

Finally, I had to use an external script resource to enable the Powershell execution policy specifically for Windows Server 2012 (non-R2). By default, DSC does not work here. I injected a small powershell script to set the execution policy to unrestricted.

For similar reasons, this template does not support Windows Server 2008 R2. While the standard Azure image VM image for 2008 R2 supports DSC now, it is still highly limited in which modules work or not. This is almost undocumented, but the short version is that almost nothing worked for 2008 R2 so I had to give it up.

### Update October 2017

New features:

* Converted VMs to use managed disks.
* Removed the storage account.
* Made the child domain optional.
* Greatly simplified the optional parts of the template using the new "condition" keyword.

### Update September 2018

New Features:

* Added B-series (burstable) VM, very suitable to run DCs cheaply. 
* Added Standard SSD disks (now default), and made the choice for disk type explicit. This type is well suited for typical DC performance. 
* Added the possibility to deploy to a location different to that of the Resource Group.
* general cleanup: updated all APIs to the most recent ones, updated DSC modules to the latest.

Willem Kasdorp, 9-30-2018.

## History

|Date         | Change                |
|-------------|-----------------------|
|2018-10-31   | Removed network creation|
|             | Moved username and password to keyvault|
|             | Removed network dependencies from NSG, VMs|
|             | Changed container sasToken parameter|
|             |Set artifact location default as: deployment().properties.templateLink.uri|
|    	      | Combined firstVMTemplateUri and nextVMTemplateUri as they call the same file|
|	        | Added vnet information to parameters|
|           | Added new DS_v3 sizes and removed lower one core ones.|
|           | Added "Microsoft.Resources/deployments/CreateForest" dependency to Childdomain as it would sometimes fail |
|           | Removed updateDNS for now as it needs to be modified |
|           | Added in common tag structure
|           | Added timezone to default to EST|
|           | Added Forward Zones as an optional parameter|
|2019-05-08| Updated documentation|


