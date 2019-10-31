Import-Module sqlps -DisableNameChecking

$ServerName = "gauravkam"

#SMO Object for server instance
$SQLSvr = New-Object -TypeName  Microsoft.SQLServer.Management.Smo.Server($ServerName)

#SMO object for database
$Db = New-Object -TypeName Microsoft.SqlServer.Management.Smo.Database
 

$p=@()


foreach ($db in $SQLSvr.Databases | Where-Object {$_.Name -ne "tempdb"})
{

    $fileGroups = $db.FileGroups


    ForEach ($fg in $fileGroups) 
    
    {
        $p += [pscustomobject] [ordered] @{
     
            SQLServer            = $ServerName
            DatabaseName         = $Db.Name
            DatabaseFileSizeInMB = ($fg.Size) / 1000
            LogFileSizeInMB      = ($Db.logfiles.size) / 1000


        }


    }

}
$p