====================================PowerShell_Commands===========================================================================
query user /server:$SERVER---------------------------------------------------Find logged on users
logoff  id or session /server:$server
get-wmiobject
$s = New-PSSession -ComputerName mslt-253
Invoke-Command -Session $s -ScriptBlock {cd C:\Checklist\Output; ls | Sort-Object -Property LastWriteTime | Select-Object -last 1}
Copy-Item -Path "C:\Checklist\output\Checklist(15November800AM).xls" -Destination "D:\gauravkam\LEX IT\Checklist_LEXBI\Output" -FromSession $s
Test-Path "D:\gauravkam\LEX IT\Checklist_LEXBI\Output\Checklist(15November800AM).xls"
Remove-PSSession $s

#Delete 5000 files
Get-ChildItem -Path T:\TypeBMsg\DXC\in -File -Filter *.RCV | Sort-Object -Property LastWriteTime | Select-Object -First 50 | Remove-Item
