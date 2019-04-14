This will deploy the Azure infrastructure required to build the Architecture shown in the demo-azure-infra-v3.1.vsdx Visio diagram.

To deploy the infrastructure you will need to edit the settings.xml file. The file will look like this:

```
    <?xml version="1.0"?>
    <Settings>
        <resourceGroupLocation>canadacentral</resourceGroupLocation>
    </Settings>
```

Change the resourceGroupLocation to the desired value (canadaeast or canadacentral) or use the one provided in the file.

Make sure you have installed AzureRM. To install it open a powershell window with Administrator rights and type:

    Install-Module AzureRM -AllowClobber
    Import-Module AzureRM

Install a copy of azcopy.exe and make sure you can run it from a powershell window when you type azcopy.

Now that the settings.xml is configured, AzureRM is loaded and azcopy will execute, run the deployment command:

    .\masterdeploy.ps1

If there are errors during the deployment (there is a tendancy for Azure to miss some of the route tables deployments that will cause deployment failures subsequently) simply re-run the masterdeploy.ps1 script to deploy the failed components.

At the end you will receive information about the Public IP address of the Core firewall you can connect to. Something like:

    There was no deployment errors detected. All look good.

    Connect to the Core firewall using ASDM to 13.71.165.183
    Connect to the demo website using a web browser at http://13.71.165.183
    Connect to the temporary Jumpbox server using RDP to 13.71.165.183:3389