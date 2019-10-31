Import-Module sqlps -DisableNameChecking
cd SQLServer:\SQL\gauravkam\default
$Secret = Read-Host -AsSecureString
Get-SqlCredential -Name "DomainCredential" | Set-SqlCredential -Identity "fareast\v-gakamb" -Secret $Secret