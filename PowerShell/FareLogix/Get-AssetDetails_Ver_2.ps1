$Servers = Get-Content D:\MyVSCode\PowerShell\FareLogix\Serverlist.txt
$RemoteComputer =  @()
$myArray = @()
$Credential = Get-Credential
#Run the commands for each server in the list
Foreach ($S in $Servers)
{
     $ErrorActionPreference = “SilentlyContinue”
     $RemoteComputer = New-Object PSObject       
             
     $Connection = Test-Connection $S -Count 1 -Quiet
     if ($Connection -eq "True")
     {
        $PSSession = New-PSSession -ComputerName $S -Credential $Credential

        if ($PSSession.State -eq 'Opened') 
        {     
            $RemoteComputer = Invoke-Command -Session $PSSession -FilePath C:\Users\gkamble\Documents\Get-ComputerInfo.ps1
            [array]$myArray += $RemoteComputer
        }
        else
        {
            $Failed = New-Object PSObject
            Add-Member -InputObject $Failed -MemberType NoteProperty -Name "Server Name" -Value $S -Force
            [array]$Logs += $Failed
        }
    }
}
$myArray | Export-Csv -Path D:\MyVSCode\PowerShell\FareLogix\Inverntory.csv -Append -NoClobber -NoTypeInformation

$Logs | Export-Csv -Path D:\MyVSCode\PowerShell\FareLogix\Logs.csv -Append -NoClobber -NoTypeInformation