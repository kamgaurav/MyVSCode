$ErrorActionPreference = “SilentlyContinue”
$ComputerInfo = New-Object PSObject       
            
$Connection = Test-Connection $s -Count 1 -Quiet
$PSSession = New-PSSession -ComputerName $s

if ($Connection -eq "True" -and $PSSession.State -eq 'Opened') {     
           
$Computer = Invoke-Command -Session $PSSession -ScriptBlock {Get-WmiObject -Class Win32_ComputerSystem}
$IP = Test-Connection -ComputerName $s -Count 1 | Select-Object IPV4Address
                    
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "Server Name" -Value $Computer.Name -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "IPAddress" -Value $IP.IPV4Address.IPAddressToString -Force
}