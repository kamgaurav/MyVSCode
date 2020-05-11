$cred = Get-Credential

Invoke-Command -ComputerName app3502 -ScriptBlock {Stop-Service -Name "SolarWinds Agent"; Start-Service -Name "SolarWinds Agent"} -Credential $cred

Invoke-Command -ComputerName app3502 -ScriptBlock {Get-Service -Name "SolarWinds Agent"} -Credential $cred
