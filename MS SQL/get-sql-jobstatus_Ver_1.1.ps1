#Monitor SQL Server Jobs & Job Steps

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.SqlServer.SMO") 
$sqlServerName = Get-Content -Path 'C:\Checklist\SQL_Backup Job Status\servers.txt'
 
 $p=@()
 
foreach($server in $sqlServerName) 
{ 

$sqlServer = New-Object Microsoft.SqlServer.Management.Smo.Server($server)
     
$j = $sqlServer.JobServer.Jobs | Where-Object {$_.name -like 'DatabaseBackup - ALL_DATABASES - FULL*'} 

    foreach ($i in $j)

    {

    $p += [pscustomobject] [ordered] @{
    
    'SQLServer' = $server
    'Job Name' = $i.Name
    'Enable' =  $i.IsEnabled
    'Step1' = $i.JobSteps | Where-Object {$_.ID -eq '1'} | Select-Object -ExpandProperty Name
    'Step1_LastRundate' = $i.JobSteps | Where-Object {$_.ID -eq '1'} | Select-Object -ExpandProperty LastRunDate
    'Step1_LastRunOutcome' = $i.JobSteps | Where-Object {$_.ID -eq '1'} | Select-Object -ExpandProperty LastRunOutcome
    'Step2' = $i.JobSteps | Where-Object {$_.ID -eq '2'} | Select-Object -ExpandProperty Name
    'Step2_LastRundate' = $i.JobSteps | Where-Object {$_.ID -eq '1'} | Select-Object -ExpandProperty LastRunDate
    'Step2_LastRunOutcome' = $i.JobSteps | Where-Object {$_.ID -eq '1'} | Select-Object -ExpandProperty LastRunOutcome
    'NextJobRunDate' = $i.nextrundate
    
    }

    }
   
}
    $p | Export-Csv -Path "C:\Checklist\SQL_Backup Job Status\Output\$(Get-Date -format dd-MMMM-yyyy_HH-mm-ss).csv" -NoTypeInformation
    
    $a = Get-ChildItem -path  "C:\Checklist\SQL_Backup Job Status\Output" | Sort-Object -Property LastWriteTime | Select-Object -last 1

    # read-host -assecurestring | convertfrom-securestring | out-file 'C:\Checklist\SQL_Backup Job Status\securestring.txt'
 
    $smtpPass = cat 'C:\Checklist\SQL_Backup Job Status\securestring.txt' | ConvertTo-SecureString
    $smtpUser = 'v-gakamb@microsoft.com'
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $smtpUser,$smtpPass
    
    Send-MailMessage -From "v-gakamb@microsoft.com" -to "v-gakamb@microsoft.com" , "v-ajmand@microsoft.com" , "v-saauti@microsoft.com" -BodyAsHtml "SQL Server Database Backup Job Status" `
    -SmtpServer "smtp.office365.com"  -Subject "SQL Backup Job Status on: $(Get-Date -format dd-MMMM-yyyy)" -Port "587" -Credential $credential -UseSsl -Attachments "C:\Checklist\SQL_Backup Job Status\Output\$a"


  $smtpPass =  ConvertTo-SecureString -AsPlainText "Nvme@1920#" -Force
    $smtpUser = 'flxdomain\gkamble'
    $credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $smtpUser,$smtpPass
