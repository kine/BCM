function Restart
{
    $Instance = GetActiveInstance -LoadModules

    if ($Instance) {
        Write-Host "Restarting $Instance"
        Restart-NAVServerInstance -ServerInstance $Instance -Force
        Read-Host "Press enter to continue"
    }
}

RegisterFunction -Function 'Restart' -Name 'Restart Instance'