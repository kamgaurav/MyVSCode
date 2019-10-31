Import-Module sqlps -DisableNameChecking

$instancename = "gauravkam"

$server = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Server -ArgumentList $instancename

$identity = "fareast\v-gakamb"

$credentialname = "DomainCredential"

$credential = New-Object Microsoft.SqlServer.Management.Smo.Credential -ArgumentList $server, $credentialname

$credential.Create($identity, "Dec1720#")

# To change password of credentials
#$credential.Alter($identity, "Dec1720")

$server.Credentials


