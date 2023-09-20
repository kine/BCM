function SelectContainer {
    param(
        $Multiple = $false
    )
    $Containers = Get-BCContainers
    if ($Multiple) {
        $Container = $Containers | Sort-Object | Out-GridView -Title "Select instance" -OutputMode Multiple
    }
    else {
        $Container = $Containers | Sort-Object | Out-GridView -Title "Select instance" -OutputMode Single
    }
    $ContainerInfo = @()
    foreach ($c in $Container) {
        $ContainerInfo += @{Container = $c; Version = (Get-BcContainerNavVersion -containerOrImageName $c) }
    }
    return $ContainerInfo
}