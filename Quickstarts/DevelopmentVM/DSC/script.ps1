param(
    [Parameter(Mandatory=$false)][string]$rdpPort = "3389"
)

<#function writeToLog {
param ([string]$message)
$scriptPath = "."
$deploylogfile = "$scriptPath\deploymentlog.log"
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"whhooo Went to test function $message $temptime" | out-file $deploylogfile -Append
}#>

Process {
 $scriptPath = "."
 $deploylogfile = "$scriptPath\deploymentlog.log"
 if ($PSScriptRoot) {
   $scriptPath = $PSScriptRoot
 } else {
   $scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
 }

#Add RDP listening ports if needed
if ($rdpPort -ne 3389) {
    netsh interface portproxy add v4tov4 listenport=$rdpPort connectport=3389 connectaddress=127.0.0.1 
    netsh advfirewall firewall add rule name="Open Port $rdpPort" dir=in action=allow protocol=TCP localport=$rdpPort
}

#Install stuff

$temptime = get-date -f yyyy-MM-dd--HH:mm:ss
"Starting deployment script - $temptime" | out-file $deploylogfile
. $scriptPath\VSCodeSetup-x64-1.32.3.exe /VERYSILENT /MERGETASKS=!runcode
. $scriptPath\ChromeStandaloneSetup64.exe /silent /install
. $scriptPath\Git-2.21.0-64-bit.exe /silent
. msiexec.exe /i $scriptPath\MicrosoftAzureStorageAzCopy_netcore_x64.msi /q /log $scriptPath\autoazcopyinstall.log
#add the AZCOPY path to the path variable
$AZCOPYpath = "C:\Program Files (x86)\Microsoft SDKs\Azure\AzCopy"
$actualPath = ((Get-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH).path)
$NEWPath =   "$actualPath;$AZCOPYpath"
$NEWPath | Out-File $scriptPath\azcopySystemPath.log
Set-ItemProperty -Path "Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Value $NEWPath
#install Powershell AZ module
Install-PackageProvider -name NuGet -MinimumVersion 2.8.5.201 -Force
Install-Module -Name Az -AllowClobber -force 
#enable azure alias
Enable-AzureRmAlias -Scope LocalMachine
#setting the time zone to eastern
& "$env:windir\system32\tzutil.exe" /s "Eastern Standard Time"
#disable IE enhache Security
$AdminKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A7-37EF-4b3f-8CFC-4F3A74704073}" 
$UserKey = "HKLM:\SOFTWARE\Microsoft\Active Setup\Installed Components\{A509B1A8-37EF-4b3f-8CFC-4F3A74704073}" 
Set-ItemProperty -Path $AdminKey -Name "IsInstalled" -Value 0 
Set-ItemProperty -Path $UserKey -Name "IsInstalled" -Value 0 
Stop-Process -Name Explorer 
#copy batch file to install VSC extention on the public desktop 

#Copy-Item -Path "$scriptpath\InstallVSCExtensions.bat" -Destination "C:\Users\Public\Desktop\InstallVSCExtensions.bat"
#adding a VSC shortcut on the public desktop
$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("c:\Users\Public\Desktop\Visual Studio Code.lnk")
$Shortcut.TargetPath = "C:\Program Files\Microsoft VS Code\Code.exe"
$Shortcut.Save()
#adding Azure Deployment Library shortcut on the desktop

$WshShell = New-Object -comObject WScript.Shell
$Shortcut = $WshShell.CreateShortcut("c:\Users\Public\Desktop\Azure Accelerators.lnk")
$Shortcut.TargetPath = "https://github.com/canada-ca/accelerators_accelerateurs-azure"
$Shortcut.IconLocation="$scriptPath\ADLicon.ico"
$Shortcut.Save()
#disable server manager at login time
Get-ScheduledTask -TaskName ServerManager | Disable-ScheduledTask -Verbose 
$temptime = get-date -f yyyy-MM-dd--HH:mm:ss

# Clone Azure Accelerators repo
New-Item -ItemType directory -Path "C:\Azure"
Set-Location -Path "C:\Azure"
git clone https://github.com/canada-ca/accelerators_accelerateurs-azure

"Ending deployment script - $temptime" | out-file $deploylogfile -Append
}

