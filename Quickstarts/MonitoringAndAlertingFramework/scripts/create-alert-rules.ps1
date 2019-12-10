$ErrorActionPreference = "Stop"

# ----------------------- Configurable settings start ------------------------------

# ZIP download URL of the GitHub repo containing the alert rule parameter files, etc

$repoOwner = "canada-ca"
$repoName = "accelerators_accelerateurs-azure"
$repoURL = "https://github.com/$repoOwner/$repoName/archive/master.zip"

# Relative path from root of repo to the alert rule automation artifacts folder
$alertRulesPathPrefix = "Quickstarts\MonitoringAndAlertingFramework"

# ----------------------- Configurable settings end --------------------------------

Write-Output "Getting Run As Connection"

$connection = Get-AutomationConnection -Name AzureRunAsConnection

Write-Output "Got Run As Connection"

Connect-AzureRmAccount -ServicePrincipal -Tenant $connection.TenantID `
-ApplicationID $connection.ApplicationID -CertificateThumbprint $connection.CertificateThumbprint

$rmContext = Get-AzureRmContext

Write-Output "Connected using service principal"

$loc = "canadacentral"

$resourceGroups = Get-AzureRmResourceGroup

$tempFilePath = $env:TEMP

$computerVariableName = "SubstituteVMName"

$alertAutomationAssetsZipPath = $tempFilePath+"\alertAutomationAssets.zip"

$alertAutomationAssetsUnzippedPath = $tempFilePath+"\alert-automation-assets"

$alertAutomationAssetsRootPath = $alertAutomationAssetsUnzippedPath+"\"+"$($repoName)-master\$alertRulesPathPrefix"

$metricAlertRuleTemplateFilePath = $alertAutomationAssetsRootPath+"\templates\metric-alert-rule-template.json"

$logAnalyticsQueryAlertRuleTemplateFilePath = $alertAutomationAssetsRootPath+"\templates\log-analytics-query-alert-rule-template.json"

$activityLogsAlertRuleTemplateFilePath = $alertAutomationAssetsRootPath+"\templates\activity-log-alert-rule-template.json"

$metricRuleParameterFilesPath = $alertAutomationAssetsRootPath+"\metric-alert-rules"

$logAnalyticsQueryRuleParameterFilesPath = $alertAutomationAssetsRootPath+"\log-analytics-query-alert-rules"

$activityLogAlertRuleParameterFilesPath = $alertAutomationAssetsRootPath+"\activity-log-alert-rules"

$logAnalyticsWorkspaces = Get-AzureRmOperationalInsightsWorkspace
$logAnalyticsWorkspaces

Add-Type -AssemblyName System.IO.Compression.FileSystem

# Unzip function
function Unzip
{
    param([string]$zipfile, [string]$outpath)

    Remove-Item -Path $outpath -Recurse -ErrorAction Ignore
    [System.IO.Compression.ZipFile]::ExtractToDirectory($zipfile, $outpath)
}

function getFQDNForVM($vmName, $workspaceId) {

    $computerName = $null
    try {
        $query = "Perf | where Computer contains '"+$vmName+"' | take 1"

        $queryResults = Invoke-AzureRmOperationalInsightsQuery -WorkspaceId $workspaceId -Query $query

        $computerName = $queryResults.Results[0].Computer
    }
    catch {
        throw "Can't find matching Computer name in Log Analytics workspace for VM "+$vmName
    }

    return $computerName

}

# Get the log analytics workspace associated to the VM
function getLogAnalyticsWorkspaceResourceIdForVM($resourceGroupName, $vmName, $osType) {

    $extensions = $null
    if ($osType -eq "Windows") {
        $extensions = @("MicrosoftMonitoringAgent", "MMAExtension")
    }
    else {
        if ($osType -eq "Linux") {
            $extensions = @("OMSExtension", "OmsAgentForLinux")
        }
    }

    foreach($extension in $extensions) {
        try {
            $vmExtension = Get-AzureRmVMExtension -ResourceGroupName $resourceGroupName -VMName $vmName -Name $extension
            if ($vmExtension -ne $null) {
                $publicSettings = $vmExtension.PublicSettings | ConvertFrom-Json
                $logAnalyticsWorkspaceId = $publicSettings.workspaceId
                
                
                foreach($workspace in $logAnalyticsWorkspaces) {
                    if ($workspace.CustomerId -eq $logAnalyticsWorkspaceId) {
                        $logAnalyticsWorkspaceResourceId = $workspace.ResourceId
                        return @($logAnalyticsWorkspaceResourceId,$logAnalyticsWorkspaceId)
                    }
                }
            }
        }
        catch {
        }
    }

    return $null
    
}

# Return whether alerting is enabled for the specified resource group name or resource name
function getAlertingTag($tags, $resourceGroupName, $resourceName) {
    $alertingTag = $null
    $alertingEnabledRaw = $tags.alert
    if ($alertingEnabledRaw -ne $null) {
        if ($alertingEnabledRaw -eq 'True') {
            $alertingTag = $true
        }
        else {
            if ($alertingEnabledRaw -eq 'False') {
                $alertingTag = $false
            }
            else {
                throw "Invalid value for alert tag on resource group $resourceGroup.ResourceGroupName, value: $rgAlertingEnabledRaw"
            }
        }
    }
    return $alertingTag
}

# Parse the alertRulesExtensions tag value and return an array of alert rule extension names
function getAlertRuleExtensionsTag($tags, $resourceGroupName, $resourceName) {
        
    $alertRuleExtensions = $null
    try {
        $alertRuleExtensionsRaw = $tags.alertRuleExtensions
        if ($alertRuleExtensionsRaw -ne $null) {

            $alertRuleExtensions = $alertRuleExtensionsRaw.Split(",").Trim()
        }
    }
    catch {
        if ($resourceName -eq $null) {
            throw "Invalid alertRuleExtensions tag on resource group $resourceGroup.ResourceGroupName, value: $alertRuleExtensionsRaw, error message: $_.Exception.Message"
        }
        else {
             throw "Invalid alertRuleExtensions tag on resource $resourceName in resource  group $resourceGroup.ResourceGroupName, value: $alertRuleExtensionsRaw, error message: $_.Exception.Message"
           
        }
    }
    
    return $alertRuleExtensions
}

# Parse the alertRulesExtensions tag value and return an array of alert rule extension names
function getAlertRuleExclusionsTag($tags, $resourceGroupName, $resourceName) {
        
    $alertRuleExclusions = $null
    $alertRuleExclusionsRaw = $null
    try {
        $alertRuleExclusionsRaw = $tags.alertRuleExclusions
        if ($alertRuleExclusionsRaw -ne $null) {

            $alertRuleExclusions = $alertRuleExclusionsRaw.Split(",").Trim()
        }
    }
    catch {
             throw "Invalid alertRuleExclusions tag on resource $resourceName in resource  group $resourceGroup.ResourceGroupName, value: $alertRuleExclusionsRaw, error message: $_.Exception.Message"
    }
    
    return $alertRuleExclusions
}

# Get a dictionary of alert action mappings.  The keys are alert rule set names, and the values are arrays of action group names
function getAlertActionsMapping($tags, $resourceGroupName, $resourceName) {
    
    $alertActions = @{}
    try {
        $alertActionsRaw = $tags.alertActions
        if ($alertActionsRaw -ne $null) {
                $json = $alertActionsRaw | ConvertFrom-Json
                foreach ($property in $json.PSObject.Properties) {
                        $keys = $property.Name.Split(",").Trim()
                        foreach($key in $keys) {
                            $alertActions[$key] = $property.Value.Split(",").Trim()
                            $value = $alertActions[$key]
                        }
                }
        }
    }
    catch {
       if ($resourceName -eq $null) {
            throw "Invalid JSON value for alertActions tag on resource group $resourceGroup.ResourceGroupName, value: $alertActionsRaw, error message: $_.Exception.Message"
        }
        else {
            throw "Invalid JSON value for alertActions tag on resource $resourceName in resource group $resourceGroupName, value: $alertActionsRaw, error message: $_.Exception.Message"
        }
    }
    
    return $alertActions
}

# Get the standard set of alert rule set names based on the type of resource, and for VMs only, the OS Type.
function getStandardAlertRuleSet($resourceType, $osType) {
    $standardAlertRuleSet = switch ($resourceType) {
        "Microsoft.Compute/virtualMachines"
        {
            if ($osType -eq "Windows") {
                @("windowsVMStandard","windowsVMStandardLogAnalyticsQueries","windowsVMResourceHealthStandard")
            }
            else {
                if ($osType -eq "Linux") {
                    @("linuxVMStandard", "linuxVMStandardLogAnalyticsQueries","linuxVMResourceHealthStandard")
                }
                else {
                    throw "Invalid OSType specified $osType"
                }
            }
        }
        "Microsoft.Insights/Components"
        {
            @("applicationInsightsStandard")
        }
        "Microsoft.Compute/virtualMachineScaleSets"
        {
            @("vmScaleSetStandard")
        }
        "Microsoft.Web/serverfarms"
        {
            @("appServicePlanStandard")
        }
        default
        {
            @()
        }
    }
    return $standardAlertRuleSet
}


# Get the corresponding resource type for an alert rule extension set
function getResourceTypeForAlertRuleExtension($alertRuleSetExtensionName) {
    $resourceType = switch ($alertRuleSetExtensionName) {
        "sqlServerIaaSLogAnalyticsQueries"
        {
            "Microsoft.Compute/virtualMachines"
        }
    }
    return $resourceType
}

# Get the list of action group resource ids matching the specified action group names
function getActionGroupIds($actionGroupNames,$format) {

    $actionGroupIds = @()
    
    foreach($actionGroupName in $actionGroupNames) {
        $resources = $null
        try {
            $resources = Get-AzureRmResource -ResourceType 'Microsoft.Insights/actionGroups' -Name $actionGroupName 
        }
        catch {
            throw "Invalid action group name specified: $actionGroupName"
        }
        if ($resources.length -gt 1) {
            throw "Found more than action group with the same name: $actionGroupName"
        }
        $actionGroupId = $null
        if ($format -eq "arrayOfHashtables") {
            $actionGroupId = @{}
            $actionGroupId['actionGroupId'] = $resources[0].id
        }
        else {
            $actionGroupId = $resources[0].id
        }
        $actionGroupIds += $actionGroupId
    }
    return $actionGroupIds
}

# Return whether the specified alert rule set is of the type log analytics metrics rule
function isLogAnalyticsMetricRule($alertRuleSetName) {
    $isLogAnalyticsMetricRule = $false
    if ($alertRuleSetName -like "*LogAnalyticsMetrics*") {
        $isLogAnalyticsMetricRule = $true
    }
    return $isLogAnalyticsMetricRule
}

# Return whether the specified alert rule set is of the type log analytics query rule
function isLogAnalyticsQueryRule($alertRuleSetName) {
    $isLogAnalyticsQueryRule = $false
    if ($alertRuleSetName -like "*LogAnalyticsQueries*") {
        $isLogAnalyticsQueryRule = $true
    }
    return $isLogAnalyticsQueryRule
}

# Return whether the specified alert rule set is of the type resource health alert rule
function isActivityLogAlertRule($alertRuleSetName) {
    $isActivityLogAlertRule = $false
    if (($alertRuleSetName -like "*ResourceHealth*") -or ($alertRuleSetName -like "*ActivityLog*")) {
        $isActivityLogAlertRule = $true
    }
    return $isActivityLogAlertRule
}

# Return whether alerting has been enabled based on the settings of resource group and resource level tags
function isAlertingEnabled($rgAlertingEnabled, $resourceAlertingEnabled) {
    if ($resourceAlertingEnabled -eq $null) {
        if ($rgAlertingEnabled -eq $null) {
            return $false
        }
        else {
            return $rgAlertingEnabled
        }
    }
    else {
        return $resourceAlertingEnabled 
    }
    
}


Write-Output "Making REST API call"
Invoke-WebRequest -Uri $repoURL -OutFile $alertAutomationAssetsZipPath

Write-Output "REST API call succeeded"
Unzip $alertAutomationAssetsZipPath $alertAutomationAssetsUnzippedPath

# The following is the main loop through each resource group in the current subscription
foreach($resourceGroup in $resourceGroups) {
        
    $tags = $resourceGroup.Tags
    $rgAlertActions = @{}
    #$rgAlertRuleExtensions = $null
    $rgAlertingEnabled = $null
    
    # Get the tag settings at the resouce group level.
    if ($tags -ne $null) { 
        $rgAlertActions = getAlertActionsMapping $tags $resourceGroup.ResourceGroupName $null
        #$rgAlertRuleExtensions = getAlertRuleExtensionsTag $tags
        $rgAlertingEnabled = getAlertingTag $tags
    }

    #Write-Host "resource group alert rule extensions: $rgAlertRuleExtensions"
    
    # Build a hashtable mapping alert rule extensions defined at the resource group level to the ARM resource type
    # We'll use this later on to make sure that the alert rule extensions are applied to the resources in the resource group that match the applicable resource type
    
    # $resourceTypeToAlertRuleExtensionMapping = @{}
    
    # if ($rgAlertRuleExtensions -ne $null) {
    #     foreach($rgAlertRuleExtension in $rgAlertRuleExtensions) {
    #         $resourceType = getResourceTypeForAlertRuleExtension $rgAlertRuleExtension
    #         $alertRuleExtensions = $resourceTypeToAlertRuleExtensionMapping[$resourceType]
    #         if ($alertRuleExtensions -eq $null) {
    #             $alertRuleExtensions = @()
    #         }
    #         $alertRuleExtensions += $rgAlertRuleExtension
    #         $resourceTypeToAlertRuleExtensionMapping[$resourceType] = $alertRuleExtensions
    #     }
    # }
    

    # Get all the resources in the current resource group and loop through them
    $resources = Get-AzureRmResource -ResourceGroupName $resourceGroup.ResourceGroupName | where{$_.ResourceType -eq "Microsoft.Compute/virtualMachines" -or $_.ResourceType -eq "Microsoft.Web/serverfarms" -or $_.ResourceType -eq "Microsoft.Insights/Components"}

    foreach($resource in $resources) {
        
        $resourceType = $resource.ResourceType

        # Get the tag settings at the resouce level            
        $tags = $resource.Tags
        $resourceAlertActions = @{}
        $resourceAlertRuleExtensions = $null
        $resourceAlertingEnabled = $null
        $resourceAlertRuleExclusions = $null
        if ($tags -ne $null) { 
            $resourceAlertActions = getAlertActionsMapping $tags $resourceGroup.ResourceGroupName $resource.Name
            $resourceAlertRuleExtensions = getAlertRuleExtensionsTag $tags
            $resourceAlertingEnabled = getAlertingTag $tags
            $resourceAlertRuleExclusions = getAlertRuleExclusionsTag $tags
        }
        
        # Check if alerting is enabled for the current resource.  If so, proceed.
        if (isAlertingEnabled $rgAlertingEnabled $resourceAlertingEnabled) {
        
            # For VM resource types, get the OS type, log analytics workspace and fqdn
            $osType = $null
            $logAnalyticsWorkspaceResourceId = $null
            $fqdn = $null
            if ($resourceType -eq "Microsoft.Compute/virtualMachines") {
                $vm = Get-AzureRmVM -ResourceGroupName $resourceGroup.ResourceGroupName -Name $resource.Name
                $osType = $vm.StorageProfile.OsDisk.OsType

                # For log analytics metric or query based alert rule sets, get the resource id of the resource's associated log analytics workspace
                # Raise an exception if the resource has no associated log analytics workspace
                $logAnalyticsWorkspaceResourceIdAndWorkspaceId = getLogAnalyticsWorkspaceResourceIdForVM $resourceGroup.ResourceGroupName $resource.Name $osType
                $logAnalyticsWorkspaceResourceId = $logAnalyticsWorkspaceResourceIdAndWorkspaceId[0]
                $logAnalyticsWorkspaceId = $logAnalyticsWorkspaceResourceIdAndWorkspaceId[1]

                if ($logAnalyticsWorkspaceResourceId -eq $null) {
                    throw "Resource $resource.Name in resource group $resourceGroup.ResourceGroupName has Log Analytics alert rule set but is not logging to a workspace"
                }

                $fqdn = getFQDNForVM $resource.Name $logAnalyticsWorkspaceId
                $fqdn
            }
            
            # Get the standard alert rule set names for the specified resource, and for VMs the specified OS type
            $standardAlertRuleSet = getStandardAlertRuleSet $resourceType $osType
            
            # Check if there are no standard alert rules for the resource type, and if so skip the resource since we don't support alerting for it
            if ($standardAlertRuleSet.length -ne 0) {
            
                $allApplicableAlertRules = $standardAlertRuleSet
                # if ($resourceTypeToAlertRuleExtensionMapping.ContainsKey($resourceType)) {
                #     $allApplicableAlertRules += $resourceTypeToAlertRuleExtensionMapping[$resourceType]
                # }
                
                if ($resourceAlertRuleExtensions -ne $null) {
                    $allApplicableAlertRules += $resourceAlertRuleExtensions                
                }

                # Go through each alert rule set 
                foreach($alertRule in $allApplicableAlertRules) {

                    # Check to see if the alert rule exclusions tag value includes this alert rule set and if so, skip it

                    if (-Not ($alertRule -in $resourceAlertRuleExclusions)) {
                    
                        # Determine the action group names for the current alert rule set
                        $actionGroupNames=@()
                        if ($rgAlertActions -ne $null) {
                            if ($rgAlertActions.ContainsKey($alertRule)) {
                                $actionGroupNames += $rgAlertActions[$alertRule]
                            }
                        
                            if ($rgAlertActions.ContainsKey('*')) {
                                    $actionGroupNames += $rgAlertActions['*']
                            }
                        }
                        
                        if ($resourceAlertActions -ne $null) {
                            if ($resourceAlertActions.ContainsKey($alertRule)) {
                                $actionGroupNames += $resourceAlertActions[$alertRule]
                            }
                        
                            if ($resourceAlertActions.ContainsKey('*')) {
                                $actionGroupNames += $resourceAlertActions['*']
                            }
                        }
                        
                        $actionGroupIds = $null
                        
                        $scope = @()
                        $templateFilePath = $null
                        $parameterFilesFolderpath = $null
                        if (isLogAnalyticsMetricRule $alertRule) {
                            # Currently we don't use these types since they weren't working properly in Azure
                            
                            $scope += $logAnalyticsWorkspaceResourceId

                            $parameterFilesFolderpath = $metricRuleParameterFilesPath+'\'+$alertRule
                            $templateFilePath = $metricAlertRuleTemplateFilePath
                            $actionGroupIds = getActionGroupIds $actionGroupNames "arrayOfHashtables"
                        }
                        else {
                            if (isLogAnalyticsQueryRule $alertRule) {

                                $parameterFilesFolderpath = $logAnalyticsQueryRuleParameterFilesPath+'\'+$alertRule
                                $templateFilePath = $logAnalyticsQueryAlertRuleTemplateFilePath
                                $actionGroupIds = getActionGroupIds $actionGroupNames "array"
                            }
                            else {
                                if (isActivityLogAlertRule $alertRule) {
                                    $scope += $resource.id
                                    $parameterFilesFolderpath = $activityLogAlertRuleParameterFilesPath+'\'+$alertRule
                                    $templateFilePath = $activityLogsAlertRuleTemplateFilePath
                                    $actionGroupIds = getActionGroupIds $actionGroupNames "arrayOfHashtables"
                                }
                                else {
                                    $parameterFilesFolderpath = $metricRuleParameterFilesPath+'\'+$alertRule
                                    $templateFilePath = $metricAlertRuleTemplateFilePath
                                    $scope += $resource.id
                                    $actionGroupIds = getActionGroupIds $actionGroupNames "arrayOfHashtables"
                                }
                            }
                        }
                        
                        # Generate a unique string that will be used in the ARM template to generate a unique alert rule name
                        $uniqueString = $resourceGroup.ResourceGroupName + ' ' + $resource.Name

                        # Get the names of the all the parameter files under the folder whose name matches the current alert rules set name
                        # TODO Generalize the JSON parameter file variable substition frameworks below for different resource types.  Currently only supports VMs.
                        $parameterFilenames = Get-ChildItem -Path $parameterFilesFolderpath -Name
                        
                        # Loop through all the JSON parameter files for each alert rule associated with the current alert rule set
                        foreach($parameterFilename in $parameterFilenames) {

                            if (-Not ($parameterFilename -in $resourceAlertRuleExclusions)) {

                                $parameterFilePath = $parameterFilesFolderpath + '\' + $parameterFilename
                                if (isLogAnalyticsMetricRule $alertRule) {
                                    # Currently we don't use these types since they weren't working properly in Azure
                                    
                                    # For log analytics metric type alert rules, we need to copy the parameter file to the temp folder and inject the VM name as the Computer dimention value to filter on
                                    $destinationPath = $tempFilePath+"\"+$parameterFilename
                                    New-Item $destinationPath -Force
                                    Copy-Item $parameterFilePath -Destination $destinationPath  -Force
                                    $parameterFilePath = $tempFilePath + "\" + $parameterFilename
                                    $jsonObject = Get-Content -Raw -Path $parameterFilePath | ConvertFrom-Json
                                    $criteria = $jsonObject.parameters.criteria.value
                                    foreach($criterion in $criteria) {
                                        foreach($dimension in $criterion.dimensions) {
                                            if ($dimension.name -eq "Computer") {
                                                $dimension.values += $fqdn
                                            }
                                        }
                                    }
                                    $jsonObject | ConvertTo-Json -depth 100 | Out-File $parameterFilePath
                                    
                                    # Create the incremental ARM template deployment passing in the JSON parameter file and action group ids
                                    New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroup.ResourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parameterFilePath -scopes $scope -actionGroupIds $actionGroupIds -uniqueString $uniqueString

                                }
                                else {
                                    if (isLogAnalyticsQueryRule $alertRule) {
                                        
                                        # For log analytics query based alert rules, we need to copy the parameter file to the temp folder and substitute the VM name for the computer variable name used in the parameter file

                                        $destinationPath = $tempFilePath+"\"+$parameterFilename
                                        New-Item $destinationPath -Force
                                        Copy-Item $parameterFilePath -Destination $destinationPath  -Force
                                        $parameterFilePath = $tempFilePath + "\" + $parameterFilename
                                        $jsonObject = Get-Content -Raw -Path $parameterFilePath | ConvertFrom-Json
                                        $query = $jsonObject.parameters.query.value
                                        
                                        if ($resourceType -eq "Microsoft.Compute/virtualMachines") {
                                            $jsonObject.parameters.query.value = $query -replace $computerVariableName,$fqdn
                                        }
                                        $jsonObject | ConvertTo-Json -depth 100 | Out-File $parameterFilePath
                                        
                                        # Create the incremental ARM template deployment passing in the JSON parameter file and action group ids
                                        New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroup.ResourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parameterFilePath -logAnalyticsWorkspaceResourceId $logAnalyticsWorkspaceResourceId -actionGroupIds $actionGroupIds -uniqueString $uniqueString 

                                    }
                                    else {
                                        # Create the incremental ARM template deployment passing in the JSON parameter file and action group ids
                                        New-AzureRmResourceGroupDeployment -ResourceGroupName $resourceGroup.ResourceGroupName -TemplateFile $templateFilePath -TemplateParameterFile $parameterFilePath -scopes $scope -actionGroupIds $actionGroupIds -uniqueString $uniqueString
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
    }
}
