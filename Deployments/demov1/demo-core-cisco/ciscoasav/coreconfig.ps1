
$password = ConvertTo-SecureString 'Canada123!' -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential ('azureadmin', $password)
$HostAddress = "40.85.211.124"

$SSHSession = New-SSHSession -ComputerName $HostAddress -Credential $credential -AcceptKey -Port 22 -Verbose;

if ($SSHSession.Connected) {
    $SSHResponse = Invoke-SSHCommand -SSHSession $SSHSession -Command "\n" -Timeout 2;
    
    $SSHSessionRemoveResult = Remove-SSHSession -SSHSession $SSHSession;

    if (-Not $SSHSessionRemoveResult) {
        Write-Error "Could not remove SSH Session $($SSHSession.SessionId):$($SSHSession.Host).";
    }

    $Result = $SSHResponse.Output | Out-String;

    return $Result;
}
else {
    throw [System.InvalidOperationException]"Could not connect to SSH host: $($HostAddress):$HostPort.";
}

$SSHSessionRemoveResult = Remove-SSHSession -SSHSession $SSHSession;

if (-Not $SSHSessionRemoveResult) {
    Write-Error "Could not remove SSH Session $($SSHSession.SessionId):$($SSHSession.Host).";
}
