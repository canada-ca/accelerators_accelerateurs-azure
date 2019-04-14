Param(
    [Parameter(Mandatory=$True)][string]$templateFile = "deployment template file formatted",
    [Parameter(Mandatory=$True)][string]$parametersFileName = "path to deployment parameter file",
    [string]$Location = "canadacentral",
    [string]$resourceGroupName = ""
)

function Output-DeploymentName {
    param( [string]$Name)

    $pattern = '[^a-zA-Z0-9-]'

    # Remove illegal characters from deployment name
    $Name = $Name -replace $pattern, ''

    # Truncate deplayment name to 64 characters
    $Name.subString(0, [System.Math]::Min(64, $Name.Length))
}

$deploymentName = Output-DeploymentName("$parametersFileName")

#******************************************************************************
# Script body
# Execution begins here
#******************************************************************************
$ErrorActionPreference = "Stop"

# sign in
#Write-Host "Logging in...";
if ([string]::IsNullOrEmpty($(Get-AzureRmContext).Account)) {
    Write-Host "You need to login. Minimize the Visual Studio Code and login to the window that poped-up"
    Login-AzureRmAccount
}

# Start the deployment
Write-Host "Starting deployment...";
New-AzureRmDeployment -Location $Location -Name $deploymentName -TemplateFile (Resolve-Path $templateFile) -TemplateParameterFile (Resolve-Path $parametersFileName) -Verbose;
