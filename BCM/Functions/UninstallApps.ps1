function UninstallApps {
    $Instance = GetActiveInstance -LoadModules

    if ($Instance) {
        $Tenant = SelectTenant -Instance $Instance
        try {

            if ($Tenant) {
                $Apps = Get-NAVAppInfo -ServerInstance $Instance -Tenant $Tenant.Id -TenantSpecificProperties | where-object {$_.IsInstalled}
                $AppsToUninstall = $Apps | Out-GridView -Title "Select Apps to Uninstall" -OutputMode Multiple
                foreach($App in $AppsToUninstall){
                    Write-Host "Uninstalling $($App.Name) version $($App.Version)" -ForegroundColor Green
                    $App | Uninstall-NAVApp -ServerInstance $Instance -Tenant $Tenant.Id -Force
                }
            }
        } finally {
            Read-Host "Press enter to continue"
        }
    }


}

RegisterFunction -Function 'UninstallApps' -Name 'Uninstall apps' -NewShell $true