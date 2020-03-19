$s = Get-Content C:\Users\gkamble\Documents\get-object\Serverlist.txt

$obj = New-Object PSObject
$obj = Invoke-Command -ComputerName $s -FilePath C:\Users\gkamble\Documents\get-object\get-opbject.ps1
$obj 
