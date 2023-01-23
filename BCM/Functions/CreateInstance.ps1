function CreateInstance
{
    $Version = GetVersion
    $InstanceParams = 
        @{'ServerInstance'='<InstanceName>';
        'ManagementServicesPort'='7045';
        'ClientServicesPort'='7046';
        'SOAPServicesPort'='7047';
        'ODataServicesPort'='7048';
        'DeveloperServicesPort'='7049';
        'DatabaseServer'='<ServerName>';
        'DatabaseInstance'='';
        'DatabaseName'='<DatabaseName>';
        'DatabaseCredentials'='';
        'ClientServicesCredentialType'='Windows';
        'ServicesCertificateThumbprint'='';
        'ServiceAccount'='NetworkService';
        'ServiceAccountCredential'=''}
        

    do {
        $Choice = $InstanceParams | Out-GridView -Title "Select parameter (cancel for continue)" -OutputMode Single
        if ($Choice) {
            switch ($Choice.Name) {
                'DatabaseCredentials' {
                    $Value = Get-Credential -Message "Enter credentials for $($Choice.Name)"
                    $InstanceParams.($Choice.Name) = $Value
                }
                'ServiceAccountCredential' {
                    $Value = Get-Credential -Message "Enter credentials for $($Choice.Name)"
                    $InstanceParams.($Choice.Name) = $Value
                }
                default {
                    $Value = Read-Host -Prompt "Enter value for $($Choice.Name)"
                    $InstanceParams.($Choice.Name) = $Value
                }
            }
        }
    }   while ($Choice)

    Write-Host @"
Executing:
    New-NAVServerInstance -ManagementServicesPort $($InstanceParams.ManagementServicesPort) `
                          -ClientServicesPort $($InstanceParams.ClientServicesPort) `
                          -SOAPServicesPort $($InstanceParams.SOAPServicesPort) `
                          -ODataServicesPort $($InstanceParams.ODataServicesPort) `
                          -DeveloperServicesPort $($InstanceParams.DeveloperServicesPort) `
                          -DatabaseServer $($InstanceParams.DatabaseServer) `
                          -DatabaseInstance $($InstanceParams.DatabaseInstance) `
                          -DatabaseName $($InstanceParams.DatabaseName) `
                          -DatabaseCredentials $($InstanceParams.DatabaseCredentials) `
                          -ClientServicesCredentialType $($InstanceParams.ClientServicesCredentialType) `
                          -ServicesCertificateThumbprint $($InstanceParams.ServicesCertificateThumbprint) `
                          -ServiceAccount $($InstanceParams.ServiceAccount) `
                          -ServiceAccountCredential $($InstanceParams.ServiceAccountCredential) `
                          -Force  
"@

    If ($InstanceParams.ServiceAccountCredential -eq '') {
        $InstanceParams.Remove('ServiceAccountCredential')
    }
    if ($InstanceParams.DatabaseCredentials -eq '') {
        $InstanceParams.Remove('DatabaseCredentials')
    } 
    LoadModules -Version $Version
    Write-Host "Creating instance" -ForegroundColor Green
    New-NAVServerInstance -Force @InstanceParams
    Read-Host "Press enter to continue"

}

RegisterFunction -Function 'CreateInstance' -Name 'Create new instance'