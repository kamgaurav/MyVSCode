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
function get-svraccount
{
    [CmdletBinding()]
    
    Param
    (
        # Param1 help description
        [Parameter(Mandatory=$true,
                   ValueFromPipelineByPropertyName=$true,
                   Position=0)]
        $computername,

        # Param2 help description
        [Parameter(Mandatory=$true)]
        $startname
    )

    Begin
    {        
        $p = Test-NetConnection -ComputerName $computername
        
        
    }
    Process
    {
        if ($p.PingSucceeded -eq 'true')
        
        {
          $service = Get-WmiObject -Class Win32_Service -ComputerName $computername | Where-Object {($_.StartName -eq "$startname")} `
          | Select-Object PSComputerName, DisplayName, StartName ,State, StartMode
        }

        else {

                "Unable to reach Server: $computername" | Export-Csv -Path C:\svraccount_info.csv -Append -NoTypeInformation
              }
    }
    End
    {
        #$service | Export-Csv -Path C:\svraccount_info.csv -Append -Force -NoTypeInformation
        $service

    }

}



get-svraccount
