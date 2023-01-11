function SelectInstance
{
    $Instances = Get-NavServerInstance
    $Instance = $Instances | Out-GridView -Title "Select instance" -OutputMode Single
    return $Instance.ServerInstance
}