#Chapter 2 : Getting Started


Set-DefaultAWSRegion -Region us-east-1
Get-DefaultAWSRegion

Set-AWSCredentials -AccessKey -SecretKey 
Get-AWSCredentials -ListProfileDetail

Get-EC2Instance
Get-EC2Instance -ProfileName Dev -Region us-east-1

Clear-AWSCredentials
Clear-DefaultAWSRegion

# Initialize-AWSDefaults will persist the credentials and region between sessions, 
# it will persists between restart PowerShell or Computer

Initialize-AWSDefaults
Initialize-AWSDefaults -ProfileName Dev -Region us-east-1

# Remove credentials
Clear-AWSDefaults # deprecated
Remove-AWSCredentialProfile

# Using stored credentials
Set-AWSCredentials -AccessKey -SecretKey -StoreAs "Dev"

$KeyPair = New-EC2KeyPair -KeyName MyKey
$KeyPair.KeyMaterial | Out-File -FilePath 'c:\aws\MyKey.pem' -Encoding ASCII


#Chapter 3 : Basic Instance Management

Get-EC2Image 

$ami = "ami-55ef662f"
$keyname = 'E:\Server Books\Cloud Computing\AWS\AWS Key\MyEC2KeyPair1.pem'
New-EC2Instance -ImageId $ami -KeyName $keyname -InstanceType 't2.micro' -MinCount 1 -MaxCount 1 

Stop-EC2Instance -InstanceId 'i-08945f18e0cd4825a' -Terminate -Force
Remove-EC2Instance -InstanceId 'i-08945f18e0cd4825a' -Force

Get-EC2Instance | ft
Get-EC2Instance -InstanceId 'i-08945f18e0cd4825a'
