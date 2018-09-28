$NewIAMPolicy = New-IAMPolicy -policyname Start-Stop-EC2 -policydocument (Get-Content -raw Start-Stop-EC2.json) -description 'Policy to Start & Stop EC2 Instance'
$NewIAMRole = New-IAMRole -AssumeRolePolicyDocument (Get-Content -raw Lambda-Assume-Role.json) -RoleName "Lambda-Start-Stop-EC2" -Description 'Allows Lambda Function to call AWS Services'
Register-IAMRolePolicy -RoleName "Lambda-Start-Stop-EC2" -PolicyArn $NewIAMPolicy.arn
#New-AWSPowerShellLambda -ScriptName 'Stop-EC2Instance' -Template Basic
Publish-AWSPowerShellLambda -ScriptPath '.\Lambda-Function\Stop-EC2Instance.ps1' -Name  'Stop-EC2Instance' -Region us-east-1 -IAMRoleArn $NewIAMRole.Arn
