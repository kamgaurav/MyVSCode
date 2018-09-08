Import-Module sqlps -DisableNameChecking
Set-Location SQLServer:\SQL\gauravkam\default
$Secret = Read-Host -AsSecureString
Get-SqlCredential -Name "DomainCredential" | Set-SqlCredential -Identity "fareast\v-gakamb" -Secret $Secret

#Set-SqlCredential -Path 'SQLServer:\SQL\gauravkam\default\Credentials\DomainCredential' -Identity "fareast\v-gakamb" -Secret $Secret
