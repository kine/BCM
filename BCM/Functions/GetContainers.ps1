function GetContainers {
    $Containers = Get-BCContainers
    $Container = $Containers | sort-object | Out-GridView -Title "Select Container" -OutputMode Single
}

RegisterFunction -Function 'GetContainers' -Name 'Get Containers'
