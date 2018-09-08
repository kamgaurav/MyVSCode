#Chapter 2 : Getting Started


Set-DefaultAWSRegion -Region us-east-1
Get-DefaultAWSRegion

Set-AWSCredentials -AccessKey -SecretKey  
Get-AWSCredentials -ListProfileDetail

Get-EC2Instance
Get-EC2Instance -ProfileName Dev -Region us-east-1

Clear-AWSCredentials
Clear-DefaultAWSRegion

# Initialize-AWSDefaults will persist the credentials and region between sessions
Initialize-AWSDefaults
Initialize-AWSDefaults -ProfileName Dev -Region us-east-1

# Remove credentials
Clear-AWSDefaults # deprecated
Remove-AWSCredentialProfile

# Using stored credentials
Set-AWSCredentials -AccessKey -SecretKey -StoreAs "Dev"

$KeyPair = New-EC2KeyPair -KeyName MyKey
$KeyPair.KeyMaterial | Out-File -FilePath 'c:\aws\MyKey.pem' -Encoding ASCII


