# GC Cloud Accelerator Development VM

<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fcanada-ca%2Faccelerators_accelerateurs-azure%2Fmaster%2FQuickstarts%2FDevelopmentVM%2Fazuredeploy.json" target="_blank">
    <img src="http://azuredeploy.net/deploybutton.png"/>
</a>

This template allows you to deploy a 1st Azure Development Windows VM using the latest patched Windows Server 2016 version. This will deploy a D2s_v3 size VM in the resource group location and return the fully qualified domain name of the VM. The VM will have all the necessary tools installed to start deploying GC Cloud Accelerator Azure templates and deployments.

## HOWTO Video tutorial

A video tutorial on how to deploy the VM on Azure and use the VM to build your 1st Azure infrastructure can be found here: 

[![HOWTO deploy the GC Accelerator VM and use it](resources/youtube-screen.png)](https://www.youtube.com/watch?v=Mm_bBRf73Lo "HOWTO deploy the GC Accelerator VM and use it")


## Demo Infrastructure deployment

When you have cloned the deployment library (see video at 19:30 https://youtu.be/Mm_bBRf73Lo?t=1170) from

https://github.com/canada-ca/accelerators_accelerateurs-azure

as shown in the youtube HOWTO above you are ready to deploy your 1st environment (neew a new video based on the github library vs devops). To do this it is suggested you 1st start with the Deployments\demov3\msfirewall example. The reason being that no vendor specific firewall license is required to properly deploy this version of the demo infrastructure with success.

### 1. Core infrastructure

On GC Cloud Accelerator Development VM go in the demov3\msfirewall\demo-core-msfw-nsg folder.

Login to your Azure subscription with:

```powershell
cd <path to demov3\msfirewall\demo-core-msfw-nsg>
login-azurermaccount
```

Select the desired subscription (if you have more than one) with:

```powershell
get-azurermsubscription
select-azurermsubscription <name>
```

Deploy the core infrastructure with:

```powershell
.\masterdeploy.ps1
```

### 2. Demo Web Server

When the infrastructure is deployed it is now time to add the desired subsequent modules. Do you want to 1st test a sample website in your demo infrastructure? Go in the demov3\msfirewall\demo-docker-web and deploy it with:

```powershell
cd ..\demo-docker-web
.\masterdeploy.ps1
```

Once deployed you will obtain the URL that you can use to connect and view the demo page. It should look like:

```text
There was no deployment errors detected. All look good.

Connect to the demo website using a web browser at http://40.82.184.3
Connect to the docker server using SSH to 40.82.184.3
```

Connecting to the URL should give you:

[![Docker Web Server](resources/website.png)]

### 3. Temporary Jumpbox

Now that you know the base infrastructure is working as expected by validating access to the demo web server you can now add the temporary jumpbox modules. Go in the demov3\msfirewall\demo-temporary-jumpbox and deploy it with:

```powershell
cd ..\demo-temporary-jumpbox
.\masterdeploy.ps1
```

Once deployed you will obtain the IP and TCP port you can use to connect to the temporary jumpbox. It should look like:

```text
some result to be added here
```

Simple connect to it using an RDP client. You will need to use this jumpbox at a future stage to configure the "final" Remode Desktop Service" farm that will be deployed later.
