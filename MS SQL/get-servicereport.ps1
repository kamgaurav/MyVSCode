<#
.Synopsis
   Short description
.DESCRIPTION
   Long description
.EXAMPLE
   Example of how to use this cmdlet
.EXAMPLE
   Another example of how to use this cmdlet
#>
function get-servicereport
{
    [CmdletBinding()]
    
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $computername

    )

    Begin
    {
        $p = Test-NetConnection -ComputerName $computername
        
        
    }
    Process
    {
        if ($p.PingSucceeded -eq 'true')
        
        {
          $c =  Get-WmiObject win32_service -ComputerName $computername -Filter "displayname like '%sql%'" | 
                Where-Object {$_.startmode -eq 'auto' -and $_.state -eq 'stopped'} | select systemname, displayname, state , startmode
        }

        else {

                $computername | Out-File -FilePath C:\service.csv -Append 
              }
    }
    End
    {
        $c | Out-File -FilePath C:\service.csv -Append -force

    }

}

$servers = get-content -Path C:\servers.txt

foreach ($s in $servers)

{

get-servicereport -computername $s

}