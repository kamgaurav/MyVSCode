$NewIAMPolicy = New-IAMPolicy -PolicyName 'EC2StartStopAccess' -PolicyDocument (Get-Content -Raw EC2StartStopAcces.json) -Description 'Provides access to Start & Stop EC2 Instance'
$NewIAMRole = New-IAMRole -AssumeRolePolicyDocument (Get-Content -raw LambdaAssumeRole.json) -RoleName "LambdaEC2StartStop" -Description 'Allows Lambda to Start Stop EC2'

#Attach IAM Policy to Role
Register-IAMRolePolicy -RoleName "LambdaEC2StartStop" -PolicyArn $NewIAMPolicy.arn

#New-AWSPowerShellLambda -ScriptName 'StopEC2Instances' -Template Basic
#Publish lambda function to stop EC2 instances
Publish-AWSPowerShellLambda -ScriptPath '.\StopEC2Instances.ps1' -Name  'StopEC2Instances' -Region us-east-1 -IAMRoleArn $NewIAMRole.Arn

$StopEC2Function = Get-LMFunctionConfiguration -FunctionName 'StopEC2Instances'
$Target1 = New-object Amazon.CloudWatchEvents.Model.Target
$Target1.Arn = $StopEC2Function.FunctionArn
$Target1.Id = $StopEC2Function.RevisionId

#Create Cloudwatch rule to stop EC2 instances
Write-CWERule -Name 'StopEC2InstancesSchedule' -ScheduleExpression "cron(30 18 ? * MON-FRI *)" -Description 'Stops EC2 Instances at 6PM MON-FRI'
#Add target fuction to cloudwatch rule
Write-CWETarget -Rule 'StopEC2InstancesSchedule' -Target $Target1


#Publish lambda function to start EC2 instances
Publish-AWSPowerShellLambda -ScriptPath '.\StartEC2Instances.ps1' -Name  'StartEC2Instances' -Region us-east-1 -IAMRoleArn $NewIAMRole.Arn

$StartEC2Function = Get-LMFunctionConfiguration -FunctionName 'StartEC2Instances'
$Target2 = New-object Amazon.CloudWatchEvents.Model.Target
$Target2.Arn = $StartEC2Function.FunctionArn
$Target2.Id = $StartEC2Function.RevisionId

#Create Cloudwatch rule to start EC2 instances
Write-CWERule -Name 'StartEC2InstancesSchedule' -ScheduleExpression "cron(30 20 ? * MON-FRI *)" -Description 'Starts EC2 Instances at 9AM MON-FRI'
#Add target fuction to cloudwatch rule
Write-CWETarget -Rule 'StartEC2InstancesSchedule' -Target $Target2
