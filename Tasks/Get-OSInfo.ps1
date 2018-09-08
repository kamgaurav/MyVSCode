cls
$a = Get-WMIObject Win32_ComputerSystem 
Write-Host "Hostname: "$a.name" " 

Write-Host "Domain: "$a.Domain""

$b = Get-WmiObject Win32_OperatingSystem
Write-Host "OS: "$b.Caption""
Write-Host "OS Architecture: "$b.OSArchitecture""
Write-Host "Service Pack: "$b.Servicepackmajorversion""
Write-Host ""
Write-Host "Firewall Profile:"
Get-NetFirewallProfile | select name, enabled | ft -AutoSize

Write-Host "IP Configuration"
Get-NetIPConfiguration
