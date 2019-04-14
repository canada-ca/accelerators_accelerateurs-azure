This will deploy the Azure infrastructure required to build the Architecture shown in the demo-azure-infra-v3.1.vsdx Visio diagram.

To deploy the infrastructure you will need to edit the settings.xml file. The file will look like this:

```
    <?xml version="1.0"?>
    <Settings>
        <resourceGroupLocation>canadacentral</resourceGroupLocation>
    </Settings>
```

Change the resourceGroupLocation to the desired value (canadaeast or canadacentral) or use the one provided in the file.

Make sure you have installed. To install it open a powershell window with Administrator rights and type:

    Install-Module AzureRM -AllowClobber
    Import-Module AzureRM

Now that the settings.xml is configured and AzureRM is loaded run the deployment command with

    .\masterdeploy.ps1

If there are errors during the deployment (there is a tendancy for Azure to miss some of the route tables deployments that will cause deployment failures subsequently) simply re-run the masterdeploy.ps1 script to deploy the failed components.

At the end you will receive information about the Public IP address of the Core firewall you can connect to. Something like:

    Connect to the Core firewall using ASDM to 23.45.67.89
    Connect to the Management firewall using ASDM to 23.45.67.89:10443
    Connect to the Shared firewall using ASDM to 23.45.67.89:10444
    Connect to the temporary Jumpbox server using RDP to 23.45.67.89