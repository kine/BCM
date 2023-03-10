function UnpublishApps {
    $Instance = GetActiveInstance -LoadModules

    if ($Instance) {
        $Tenant = SelectTenant -Instance $Instance
        try {

            if ($Tenant) {
                $Apps = Get-NAVAppInfo -ServerInstance $Instance -Tenant $Tenant.Id -TenantSpecificProperties | where-object {$_.IsPublished}
                $AppsToUnpublish = $Apps | Out-GridView -Title "Select Apps to Unpublish" -OutputMode Multiple
                foreach($App in $AppsToUnpublish){
                    Write-Host "Unpublishing $($App.Name) version $($App.Version)" -ForegroundColor Green
                    If ($App.Scope -eq 'Tenant') {
                        $App | Unpublish-NAVApp -ServerInstance $Instance -Tenant $Tenant.Id
                    } else {
                        $App | Unpublish-NAVApp -ServerInstance $Instance
                    }
                }
            }
        } finally {
            Read-Host "Press enter to continue"
        }

    }

}

RegisterFunction -Function 'UnpublishApps' -Name 'Unpublish apps' -NewShell $true