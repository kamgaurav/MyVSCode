function ComputerInfo {
$ComputerInfo = @()
$ComputerInfo = New-Object PSObject

$Computer = Get-WmiObject -Class Win32_ComputerSystem
$IP = Test-Connection -ComputerName ($env:computername) -Count 1 | Select-Object IPV4Address
$OSInfo = Get-WmiObject -Class Win32_OperatingSystem
$CPUInfo = Get-WmiObject -Class Win32_Processor
$PhysicalMemory = Get-WmiObject -class "win32_physicalmemory" -namespace "root\CIMV2" | Measure-Object -Property capacity -Sum | % { [Math]::Round(($_.sum / 1GB), 2) }
$LogicalDisks = Get-WmiObject -class Win32_LogicalDisk -Namespace "root\CIMV2" -Filter "DriveType=3"
$SerialNo = Get-WmiObject win32_bios
                       
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "Server Name" -Value $Computer.Name -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "IPAddress" -Value $IP.IPV4Address.IPAddressToString -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "Domain" -Value $Computer.Domain -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "OS" -Value $OSInfo.Caption -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "OSArchitecture" -Value $OSInfo.OSArchitecture -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "ServicePack" -Value $OSInfo.servicepackmajorversion -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "CPU Name" -Value $CPUInfo[0].Name -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "CPU Count" -Value $CPUInfo.Count -Force
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "PhysicalMemory(GB)" -Value $PhysicalMemory -Force
$LogicalDisks | ForEach-Object { $ComputerInfo | Add-Member -MemberType noteproperty -name Drive$($_.Name -replace ':' , '') -value ([math]::Round(($_.Size) / 1GB , 2)) -Force} 
Add-Member -InputObject $ComputerInfo -MemberType NoteProperty -Name "SerialNumber" -Value $SerialNo.SerialNumber -Force

$ComputerInfo
}
ComputerInfo