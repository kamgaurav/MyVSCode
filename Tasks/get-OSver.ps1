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
function get-ver
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

        $c = Get-WmiObject -ComputerName $computername -Class win32_operatingsystem
    }
    Process
    {
        if ($c.buildnumber -lt 7601)

        {
            Write-Output ""
            Write-Output "Operating System not 8.1"
        }

        else 
        
        {   
            Write-Output ""
            Write-Output "Operating System is 8.1"
        }
          
        
    }
    End
    {
    }
}
