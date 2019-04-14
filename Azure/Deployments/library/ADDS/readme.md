**Description:**

This will deploy two Microsoft Active Directory servers as shown in demo-mgmt-ADDS-v1.1.vsdx Visio diagram.

**Dependencies:**

To deploy the ADDS module make sure you already deployed one of the core infrastructure module.

**Installation**

You then simply configure the parameters files to your need and execute the masterdeploy.ps1 script found in this folder to deploy the two RDS servers:

```
    .\masterdeploy.ps1
```

At the end you will receive information about the private IP address of the ADDS servers you can connect to via RDP from the jumpbox01 server located in the core infrastructure. It will look something like:

```
    You can RDP to the Active Directory servers at 10.25.8.20 an 10.25.8.21
```

You will also need to update the dhcp options in the management vnet to allow servers in that vnet to use the ADDS servers as the DNS. This is required to be able to join the domain in the vnet. This can ve accomplished by editing subnet-vnet parameters file of the mamagement vnet to add the following dhcp option to and redeploy it to Azure:

```
    "dhcpOptions":  {
        "dnsServers": [
            "10.25.8.20",
            "10.25.8.21"
        ]
    },
```