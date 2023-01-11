# Script to manage BC instances. Replace the GUI MMC console snapin
function SetNewConfigValue 
{
    param($ServerInstance,$Key,$Value)

    Write-Host "Old value of $Key is '$Value'"
    $NewValue = Read-Host -Prompt "Enter new value"
    Write-Host "Setting $Key to $NewValue"
    Set-NAVServerConfiguration -ServerInstance $ServerInstance -KeyName $Key -KeyValue $NewValue -Force

}

function SelectInstance
{
    $Instances = Get-NavServerInstance
    $Instance = $Instances | Out-GridView -Title "Select instance" -OutputMode Single
    return $Instance.ServerInstance
}

function GetInstances
{
    $Instances = Get-NavServerInstance
    $Instance = $Instances | Out-GridView -Title "Select instance" -OutputMode Single
}
function SetInstance
{
    $ActiveInstance = SelectInstance
}
function Restart
{
    if (-not $ActiveInstance) {
        $Instance = SelectInstance
    } else {
        $Instance = $ActiveInstance
    }

    if ($Instance) {
        Write-Host "Restarting $Instance"
        Restart-NAVServerInstance -ServerInstance $Instance -Force
    }
}

function Config
{
    if (-not $ActiveInstance) {
        $Instance = SelectInstance
    } else {
        $Instance = $ActiveInstance
    }

    do {

        $Config = Get-NAVServerConfiguration -ServerInstance $Instance 

        $ConfigHash = @{}

        $Config.ForEach({$ConfigHash[$_.key]=$_.value})

        $SelectedValue = $ConfigHash | Out-GridView -Title "Current Configuration - use Cancel to go back" -OutputMode Single

        if ($SelectedValue) {
            SetNewConfigValue -ServerInstance $Instance -Key $SelectedValue.Name -Value $SelectedValue.Value
        }
    } until (-not $SelectedValue)
}

Import-Module (Get-ChildItem -Path 'C:\Program Files\Microsoft Dynamics 365 Business Central' -Include 'Microsoft.Dynamics.Nav.Management.dll' -Recurse | Sort-Object -Property LastWriteTime | Select-Object -Last 1)
Import-Module (Get-ChildItem -Path 'C:\Program Files\Microsoft Dynamics 365 Business Central' -Include 'Microsoft.Dynamics.Nav.Apps.Management.dll' -Recurse | Sort-Object -Property LastWriteTime | Select-Object -Last 1)

$ActiveInstance = ''
$Choice = ''
do {

    $Items = @(
    @{'GetInstances'='Get Instances'}
    @{'SetInstance'='Select Instances'},
    @{'Restart'='Restart Instance'},
    @{'Config'='Configuration'},
    @{'Exit'='Exit'}
    )

    $Choice = $Items | Out-GridView -Title "Choice (Active instance: '$ActiveInstance')" -OutputMode Single

    switch ($Choice.Name)
    {
        "GetInstances" {GetInstances}
        "SetInstance" {SetInstance}
        "Config" { Config}
        "Restart" {Restart}
    }

} until ((-not $Choice) -or ($Choice.Name -eq 'Exit'))
