Invoke-RestMethod 'http://169.254.169.254/latest/meta-data/instance-id'
Get-EC2Tag -Filter @{ Name = "resource-id"; values = "$instanceId"}
$Role = Get-EC2Tag -Filter @{ Name = "resource-id"; values = "$instanceId"} | Where-Object {$_.key -eq 'Role'} | Select-Object -ExpandProperty value
$Environment = $Role = Get-EC2Tag -Filter @{ Name = "resource-id"; values = "$instanceId"} | Where-Object {$_.key -eq 'Environment'} | Select-Object -ExpandProperty value
Read-S3Object -BucketName my-configs/Environment/Role -Key Format_Mount_Disk_Ver_3.ps1 -File 'C:\"$Environment"_"$Role"_Bootstrap.ps1'
