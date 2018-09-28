$accesskey = Read-Host "Enter AccessKey"
$secretkey = Read-Host "Enter SecretKey"

#$region = Read-Host "Enter Region"
#$profile = Read-Host "Enter Profile Name"

$region = 'us-east-1'
$profile = 'dev'

Set-AWSCredentials -AccessKey $accesskey -SecretKey $secretkey -StoreAs $profile
Set-DefaultAWSRegion -Region $region

Initialize-AWSDefaultConfiguration -ProfileName $profile -Region $region

Get-AWSCredentials -ListProfiledetail