Get-AppxPackage *windowsphone* | Remove-AppxPackage

$app = Get-WmiObject -ClassName win32_product -Filter "Name = 'Windows Admin Center'"

$app.Uninstall()
