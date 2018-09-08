<#
The sample scripts are not supported under any Microsoft standard support 
program or service. The sample scripts are provided AS IS without warranty  
of any kind. Microsoft further disclaims all implied warranties including,  
without limitation, any implied warranties of merchantability or of fitness for 
a particular purpose. The entire risk arising out of the use or performance of  
the sample scripts and documentation remains with you. In no event shall 
Microsoft, its authors, or anyone else involved in the creation, production, or 
delivery of the scripts be liable for any damages whatsoever (including, 
without limitation, damages for loss of business profits, business interruption, 
loss of business information, or other pecuniary loss) arising out of the use 
of or inability to use the sample scripts or documentation, even if Microsoft 
has been advised of the possibility of such damages 
#>

Function Backup-OSCAnalysisServicesDB
{ 
        [Cmdletbinding()] 
        Param 
        ( 
                [Parameter(Mandatory = $true,Position = 0)] 
                [String]$ServerName, 
                [Parameter(Mandatory = $true,Position = 1)] 
                [String]$Database, 
                [Parameter(Mandatory = $true,Position = 2)] 
                [String]$FilePath,
                [Parameter(Mandatory = $false,Position = 3)]
                [String]$Password
        ) 
        Try
        {
            # load the AMO library 
            [System.Reflection.Assembly]::LoadwithpartialName("Microsoft.AnalysisServices") | Out-Null 
            # connect to the SSAS Server 
            $sever = New-Object Microsoft.AnalysisServices.Server 
            $sever.Connect($ServerName) 
            # retrieve database 
            $db= $sever.Databases.Item($Database) 

            # backup SSAS database
            If($Password)
            {
                Write-Host "Backuping..."
                $db.Backup($FilePath,$false,$false,$null,$true,$Password)
                CheckBackupFile
            }
            Else
            {
                Write-Host "Backuping..."
                $db.Backup($FilePath,$false,$false,$null,$true,$null)
                CheckBackupFile 
            }

            $sever.Disconnect() 
        }
        Catch
        {
            Write-Error $_
        }
}

Function CheckBackupFile
{
    If(Test-Path -Path $FilePath)
    {
        Write-Host "The file $FilePath has been backuped sucessfully."
    }
    Else
    {
        Write-Host "Failed to back up the file $FilePath" -ForegroundColor Red
    }
}
