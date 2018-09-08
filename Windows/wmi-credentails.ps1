Get-WmiObject -computername LEXBI-01 win32_processor -Credential $Credentials


$LAdmin = "DOMAIN\Administrator"
$LPassword = ConvertTo-SecureString "Password!" -AsPlainText -Force
$Credentials = New-Object -Typename System.Management.Automation.PSCredential -ArgumentList $LAdmin, $LPassword
