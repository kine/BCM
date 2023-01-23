function SelectInstance
{
    param(
        $Multiple = $false
    )
    $Modules = GetModules
    $Script= {
        param ($Modules)
        Import-Module $Modules -Scope Local
        Get-NavServerInstance
    }
    $Instances = Invoke-Command -ComputerName . -ScriptBlock $Script -ArgumentList $Modules
    if ($Multiple) {
        $Instance = $Instances | Out-GridView -Title "Select instance" -OutputMode Multiple
    } else {
        $Instance = $Instances | Out-GridView -Title "Select instance" -OutputMode Single
    }
    return $Instance
}