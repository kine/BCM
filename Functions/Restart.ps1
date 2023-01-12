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

RegisterFunction -Function 'Restart' -Name 'Restart Instance'