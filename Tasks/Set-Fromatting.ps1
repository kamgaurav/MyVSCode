$jenny = 1206867.5309
Write-Host "Original:`t`t`t" $jenny
Write-Host "Whole Number:`t`t" ("{0:N0}" -f $jenny)
Write-Host "3 decimal places:`t" ("{0:N3}" -f $jenny)
Write-Host "Currency:`t`t`t" ("{0:C2}" -f $jenny)
Write-Host "Percentage:`t`t`t" ("{0:P2}" -f $jenny)
Write-Host "Scientific:`t`t`t" ("{0:E2}" -f $jenny)
Write-Host "Fixed Point:`t`t" ("{0:F5}" -f $jenny)
Write-Host "Decimal:`t`t`t" ("{0:D8}" -f [int]$jenny)
Write-Host "HEX:`t`t`t`t" ("{0:X0}" -f [int]$jenny)