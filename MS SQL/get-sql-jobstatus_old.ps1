[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") 
$sqlServerName = 'MSLT-228\LEXBI_DI01_PE','MSLT-296\LEXBI_CTRL_TCF','MSLT-301\LEXBI_DW_PE','MSLT-317\LEXBI_DI03_16PE','MSLT-318\LEXBI_DI02_PPE','MSLT-319\LEXBI_DI03_16PPE'
 
 $p=@()
 
foreach($server in $sqlServerName) 
{ 

$sqlServer = New-Object Microsoft.SqlServer.Management.Smo.Server($server)
     
$j = $sqlServer.JobServer.Jobs | Where-Object {$_.name -eq 'DatabaseBackup - ALL_DATABASES - FULL'} 

$p += [pscustomobject] [ordered] @{
    
    SQLServer = $server
    Name = $j.Name
    Enable =  $j.IsEnabled
    LastRundate = $j.LastRunDate
    LastRunOutcome = $j.LastRunOutcome
    CurrentRunStatus = $j.currentrunstatus
    CurrentRunStep = $j.currentrunstep
    NextRunDate = $j.nextrundate
    
    
                                    }

   
}
    $p | Export-Csv -Path "C:\Checklist\SQL_Backup Job Status\Output\$(Get-Date -format dd-MMMM-yyyy_HH-mm-ss).csv" -NoTypeInformation
    
    $a = Get-ChildItem -path  "C:\Checklist\SQL_Backup Job Status\Output" | Sort-Object -Property LastWriteTime | Select-Object -last 1

    # read-host -assecurestring | convertfrom-securestring | out-file C:\Checklist\SQL_Backup Job Status\securestring.txt
 
    $smtpPass = cat 'C:\Checklist\SQL_Backup Job Status\securestring.txt' | ConvertTo-SecureString
    $smtpUser = 'v-gakamb@microsoft.com'
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $smtpUser,$smtpPass
    
    Send-MailMessage -From "v-gakamb@microsoft.com" -to "v-gakamb@microsoft.com" , "v-ajmand@microsoft.com" , "v-saauti@microsoft.com" -BodyAsHtml "SQL Server Database Backup Job Status" `
    -SmtpServer "smtp.office365.com"  -Subject "SQL Backup Job Status on: $(Get-Date -format dd-MMMM-yyyy)" -Port "587" -Credential $credential -UseSsl -Attachments "C:\Checklist\SQL_Backup Job Status\Output\$a"

