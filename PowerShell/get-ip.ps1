$c = Get-Credential 
Invoke-Command -ComputerName MSLT-317 -ScriptBlock { Get-NetIPAddress | Format-Table -AutoSize } -Credential $c

@(@(Get-WmiObject Win32_NetworkAdapterConfiguration | Select-Object -ExpandProperty IPAddress) -like "*.*")[0]
