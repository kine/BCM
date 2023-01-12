function StopInstances
{
    if (-not $ActiveInstance) {
        $Instances = SelectInstance -Multiple $true
    } else {
        $Instances = $ActiveInstance
    }

    if ($Instances) {
        foreach($Instance in $instances){
            Write-Host "Stop $Instance"
            Restart-NAVServerInstance -ServerInstance $Instance -Force
        }
    }
}

RegisterFunction -Function 'StopInstances' -Name 'Stop Instances'