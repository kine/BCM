function GetVersion
{
    param(
        $Path='C:\Program Files\Microsoft Dynamics 365 Business Central',
        $File='Microsoft.Dynamics.Nav.Management.dll'
    )
    $Versions = (Get-ChildItem -Path $Path -Include 'Microsoft.Dynamics.Nav.Management.dll' -Recurse) | Select-Object -ExpandProperty VersionInfo | Sort-Object -Unique -Property ProductVersion
    if ($Versions.Count -eq 1) {
        return $Versions.ProductVersion
    }
    $Selected = $Versions | Out-gridview -Title "Select version" -OutputMode Single
    return $Selected.ProductVersion
}