function SelectInstance
{
    param(
        $Multiple = $false
    )
    $Instances = Get-NavServerInstance
    if ($Multiple) {
        $Instance = $Instances | Out-GridView -Title "Select instance" -OutputMode Multiple
    } else {
        $Instance = $Instances | Out-GridView -Title "Select instance" -OutputMode Single
    }
    return $Instance.ServerInstance
}