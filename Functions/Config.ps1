function SetNewConfigValue 
{
    param($ServerInstance,$Key,$Value)

    Write-Host "Old value of $Key is '$Value'"
    $NewValue = Read-Host -Prompt "Enter new value"
    Write-Host "Setting $Key to $NewValue"
    Set-NAVServerConfiguration -ServerInstance $ServerInstance -KeyName $Key -KeyValue $NewValue -Force

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

RegisterFunction -Function 'Config' -Name 'Instance Configuration'
