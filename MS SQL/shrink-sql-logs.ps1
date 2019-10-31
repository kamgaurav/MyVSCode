Import-Module sqlps -DisableNameChecking

$ServerName = "gauravkam"

#SMO Object for server instance
$SQLSvr = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerName)

#SMO object for database
$Db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database
 



foreach ($db in $SQLSvr.Databases | Where-Object {$_.Name -eq "AdventureWorks2012"}) 

{

    $db.LogFiles[0].Shrink(0, 'default')
    

}

