function SetNewConfigValue {
    param($ServerInstance, $Key, $Value)

    Write-Host "Old value of $Key is '$Value'"
    $NewValue = Read-Host -Prompt "Enter new value"
    Write-Host "Setting $Key to $NewValue"
    Invoke-ScriptInBcContainer -ContainerName $Container -scriptblock {
        param($ServerInstance, $Key, $NewValue)
        Set-NAVServerConfiguration -ServerInstance $ServerInstance -KeyName $Key -KeyValue $NewValue -Force
    } -argumentList 'BC', $Key, $NewValue

}

function Config {
    $Container = GetActiveContainers
    do {
        Write-Host "Reading Configuration for $Container" -ForegroundColor Green
        $Config = Get-BcContainerServerConfiguration -ContainerName $Container
        $ConfigHash = @{}

        foreach ($Property in ($Config | get-member -MemberType Properties)) {
            $ConfigHash[$Property.Name] = $Config.$($Property.Name)
        }
        $SelectedValue = $ConfigHash | Out-GridView -Title "Current Configuration - use Cancel to go back" -OutputMode Single

        if ($SelectedValue) {
            SetNewConfigValue -Container $Container -Key $SelectedValue.Name -Value $SelectedValue.Value
        }
    } until (-not $SelectedValue)
}

RegisterFunction -Function 'Config' -Name 'Get/Set Container Instance Configuration' -Docker $True -NewShell $False
