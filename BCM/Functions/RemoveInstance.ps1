function RemoveInstance
{
    $Instance = GetActiveInstance -LoadModules

    if ($Instance) {
        Add-Type -AssemblyName PresentationFramework
        $continue = [System.Windows.MessageBox]::Show("Are you sure that you want to remove instance $($Instance)?", 'Confirmation', 'YesNo');
        if ($continue -eq 'Yes') {
            Write-Host "Removing $Instance"
            Remove-NAVServerInstance -ServerInstance $Instance -Force
            Read-Host "Press enter to continue"
        }
    }
}

RegisterFunction -Function 'RemoveInstance' -Name 'Remove existing instance'