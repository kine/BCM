function StartInstances
{
    if (-not $ActiveInstance) {
        $Instances = SelectInstance -Multiple $true
    } else {
        $Instances = $ActiveInstance
    }

    if ($Instances) {
        foreach($Instance in $instances){
            Write-Host "Starting $Instance"
            Start-NAVServerInstance -ServerInstance $Instance -Force
        }
    }
}

RegisterFunction -Function 'StartInstances' -Name 'Start Instances'