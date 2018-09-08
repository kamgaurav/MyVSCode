$a = "<style>"
$a = $a + "BODY{background-color:white;}"
$a = $a + "TABLE{border-width: 1px;border-style: solid;border-color: black;border-collapse: collapse;}"
$a = $a + "TH{border-width: 1px;padding: 0px;border-style: solid;border-color: black;background-color:white;}"
$a = $a + "TD{border-width: 1px;padding: 0px;border-style: solid;border-color: black;}"
$a = $a + "</style>"

Get-Process | Select-Object * | ConvertTo-HTML -head $a | Out-File C:\Users\gauravkam\scripts\Test.htm

Invoke-Expression C:\Users\gauravkam\scripts\Test.htm