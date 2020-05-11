$cre = Get-Credential

$s = New-PSSession -ComputerName 192.168.2.108 -Credential ($cre)
Copy-Item -Path "C:\Users\gkamble\Documents\Solarwinds-Agent.mst" -Destination "C:\Users\gkamble\Documents" -ToSession $s
Copy-Item -Path "C:\Users\gkamble\Documents\Solarwinds-Agent.msi" -Destination "C:\Users\gkamble\Documents" -ToSession $s

Invoke-Command -Session $s -ScriptBlock {Test-Path -Path "C:\Users\gkamble\Documents\Solarwinds-Agent.mst"}
Invoke-Command -Session $s -ScriptBlock {Test-Path -Path "C:\Users\gkamble\Documents\Solarwinds-Agent.msi"}

Invoke-Command -Session $s -ScriptBlock {msiexec /I Solarwinds-Agent.msi /qn TRANSFORMS=SolarWinds-Agent.mst}

Invoke-Command -Session $s -ScriptBlock {Remove-Item -Path "C:\Users\gkamble\Documents\Solarwinds-Agent.msi"}

Remove-PSSession -Session $s
 
