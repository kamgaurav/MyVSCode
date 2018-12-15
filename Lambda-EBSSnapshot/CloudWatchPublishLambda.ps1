# Create New IAM Policy and Role for Lambda
$NewIAMPolicy1 = New-IAMPolicy -PolicyName 'Policy-EBSSnapshot' -PolicyDocument (Get-Content -Raw Policy-EBSSnapshot.json) -Description 'Policy to take Snapshot of EBS volumes.'            
$NewIAMRole1 = New-IAMRole -AssumeRolePolicyDocument (Get-Content -raw AssumeRolePolicy-Lambda.json) -RoleName "Role-EBS-Snapshot" -Description 'Allows Lambda Function to call AWS services on your behalf.'       
Register-IAMRolePolicy -RoleName "Role-EBS-Snapshot" -PolicyArn $NewIAMPolicy1.arn

# Create New IAM Policy and Role for Step Function
$NewIAMPolicy2 = New-IAMPolicy -PolicyName 'Policy-LambdaInvoke' -PolicyDocument (Get-Content -Raw Policy-LambdaInvoke.json) -Description 'Policy to Invoke Lambda Function.'            
$NewIAMRole2 = New-IAMRole -AssumeRolePolicyDocument (Get-Content -raw AssumeRolePolicy-StepFunction.json) -RoleName "Role-Lambda-Invoke" -Description 'Allows Step Function to call AWS services on your behalf.'     
Register-IAMRolePolicy -RoleName "Role-Lambda-Invoke" -PolicyArn $NewIAMPolicy2.arn

# Create New IAM Policy and Role for CloudWatch Rule
$NewIAMPolicy3 = New-IAMPolicy -PolicyName 'Policy-StateMachineInvoke' -PolicyDocument (Get-Content -Raw Policy-StateMachineInvoke.json) -Description 'Policy to Invoke Step Function.'            
$NewIAMRole3 = New-IAMRole -AssumeRolePolicyDocument (Get-Content -raw AssumeRolePolicy-CloudWatchRule.json) -RoleName "Role-StateMachine-Invoke" -Description 'Allows CloudWatch to call AWS services on your behalf.'     
Register-IAMRolePolicy -RoleName "Role-StateMachine-Invoke" -PolicyArn $NewIAMPolicy3.arn


#Publish Lambda Function
Publish-AWSPowerShellLambda -ScriptPath '.\Create-EBSSnapshot.ps1' -Name 'Create-EBSSnapshot' -Region eu-west-1 -IAMRoleArn $NewIAMRole1.Arn
Publish-AWSPowerShellLambda -ScriptPath '.\Remove-EBSSnapshot.ps1' -Name 'Remove-EBSSnapshot' -Region eu-west-1 -IAMRoleArn $NewIAMRole1.Arn

$StateMachine = New-SFNStateMachine -Name 'StateMachine-ManageSnapshot' -Definition (Get-Content -Raw StateMachineDefinition.json) -RoleArn $NewIAMRole2.Arn -Region 'eu-west-1'

#Get-SFNStateMachine -StateMachineArn $StateMachine.StateMachineArn

#Create new CloudWatch Event and attach State Machine as target
$Target = New-Object Amazon.CloudWatchEvents.Model.Target
$Target.Arn = $StateMachine.StateMachineArn
$Target.Id = $StateMachine.ResponseMetadata.RequestId
$Target.RoleArn = $NewIAMRole3.Arn

Write-CWERule -Name EBSSnapshotSchedule -ScheduleExpression "cron(29 18 ? * MON-SUN *)" -Description 'A CloudWatch Event Rule to take Snapshot of EBS.'
Write-CWETarget -Rule EBSSnapshotSchedule -Target $Target