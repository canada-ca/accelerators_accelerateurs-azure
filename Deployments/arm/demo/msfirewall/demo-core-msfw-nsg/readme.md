This will deploy the Azure infrastructure required to build the Architecture shown in the demo-azure-infra-v3.1.vsdx Visio diagram.

Make sure you have installed AzureRM. To install it open a powershell window with Administrator rights and type:

    Install-Module AzureRM -AllowClobber
    Import-Module AzureRM

Install a copy of azcopy.exe and make sure you can run it from a powershell window when you type azcopy.

Now that AzureRM is loaded and azcopy will execute, run the deployment command:

    .\masterdeploy.ps1

If there are errors during the deployment (there is a tendancy for Azure to miss some of the route tables deployments that will cause deployment failures subsequently) simply re-run the masterdeploy.ps1 script to deploy the failed components.

### 20190417 Bernard Maltais

This new update will now deploy a default PBMM policy on the subscription that will report on and enforce some of the Security Controls. A default workspace is created under the Demo-Infra-LoggingSec-RG for this purpose.