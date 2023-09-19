function CreateViews {
    $Instance = GetActiveInstance -LoadModules
    Write-Host "Reading Configuration for $Instance" -ForegroundColor Green
    $Config = Get-NAVServerConfiguration -ServerInstance $Instance

    $ConfigHash = @{}

    $Config.ForEach({ $ConfigHash[$_.key] = $_.value })

    $SQLDB = $ConfigHash['Database']
    $SQLServer = $ConfigHash['DatabaseServer']
    $SQLInstance = $ConfigHash['DatabaseInstance']
    if ($SQLInstance) {
        $SQLServer = "$SQLServer\$SQLInstance"
    }
    Write-Host "Connecting to $SQLDB on $SQLServer" -ForegroundColor Green

    Write-Host "Getting list of tables" -ForegroundColor Green
    $Tables = Invoke-SqlCmd -ServerInstance $SQLServer -Database $SQLDB -Query "SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE' AND TABLE_NAME like '%`$ext'" -Encrypt Optional
    foreach ($Table in $Tables) {
        $TableName = $Table.TABLE_NAME
        if ($TableName -match '^(.+)\$([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})\$ext') {
            $SQLTableName = $Matches[1]
            Write-Host "Getting columns for table $TableName" -ForegroundColor Green
            $Columns = Invoke-SqlCmd -ServerInstance $SQLServer -Database $SQLDB -Query "SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = '$TableName'" -Encrypt Optional
            $Apps = @{}
            
            foreach ($Column in $Columns) {
                $ColumnName = $Column.COLUMN_NAME
                if ($ColumnName -match '^(.+)\$([a-z0-9]{8}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{4}-[a-z0-9]{12})$') {
                    Write-Host "Adding app $($Matches[2]) column $($Matches[1])"
                    $AppId = $Matches[2]
                    $ColumnNameClean = $Matches[1]
                    if (-not $Apps.ContainsKey($AppId)) {
                        $Apps.Add($AppId, @($ColumnNameClean))
                    }
                    else {
                        $Apps[$AppId] += $ColumnNameClean
                    }
                    
                }
                else {
                    Write-Host "Adding PK column $ColumnName"
                    if (-not $Apps.ContainsKey('')) {
                        $Apps.Add('', @($ColumnName))
                    }
                    else {
                        $Apps[''] += $ColumnName
                    }
                }
            }
            $ColumnsSelect = ''
            foreach ($App in $Apps.Keys) {
                Write-Host "$($App)"
                if ($App -ne '') {

                    $NewViewName = $SQLTableName + '$' + $App
                    Write-Host "Creating View [$NewViewName]" -ForegroundColor Green
                    foreach ($Column in $Apps['']) {
                        $ColumnsSelect += ",[$Column]"
                    }<#  #>
                    foreach ($Column in $Apps[$App]) {
                        $ColumnsSelect += ",[$Column`$$App] as [$Column]"
                    }
                    $ColumnsSelect = $ColumnsSelect.Trim(',')
                    $SQLDrop = "if object_id('$NewViewName','v') is not null drop view [$NewViewName]"
                    $SQLCreate = "Create view [$NewViewName] as select $ColumnsSelect from [$TableName]"
                    Write-Host $SQLDrop -ForegroundColor Yellow
                    Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDB -Query $SQLDrop -Encrypt Optional
                    Write-Host $SQLCreate -ForegroundColor Yellow
                    Invoke-Sqlcmd -ServerInstance $SQLServer -Database $SQLDB -Query $SQLCreate -Encrypt Optional
                }
            }
        }
    }
}

RegisterFunction -Function 'CreateViews' -Name 'Create DB Views for pre-BC23 schema'
