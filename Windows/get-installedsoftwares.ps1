$c = 'MSLT-316'
$s = New-CimSession -ComputerName $c
Get-CimInstance -ClassName win32_product -CimSession $s -Filter "Name like 'sql server 2016%'" | ft -AutoSize -Wrap

Remove-CimSession -CimSession $s