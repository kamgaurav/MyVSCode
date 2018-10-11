Param (
    [string][Parameter(Mandatory = $True)] $VolumeId,
    [int][Parameter(Mandatory = $True)] $NewSize
)
$CurrentSize = Get-EC2Volume -Volume $VolumeId
If ($NewSize -lt $CurrentSize.Size) { Write-Host "New volume must be larger than current" -ForegroundColor Red; break}
Edit-EC2Volume -VolumeId $VolumeId -Size $NewSize | Out-Null
$ModifiedSize = (Get-EC2Volume -Volume $VolumeId).Size

While ($ModifiedSize -ne $NewSize) {
    Start-Sleep 5
    $ModifiedSize = (Get-EC2Volume -Volume $VolumeId).Size
}
Write-Host ""
Write-Host "Volume:$VolumeId is resized to size:$NewSize" -ForegroundColor Green
$InstanceId = (Get-EC2Volume -Volume $VolumeId | Select-Object -ExpandProperty Attachments)[0].InstanceId

$Commands = @(
    '$DiskNumber = (Get-Partition -DriveLetter C).DiskNumber',
    'Update-Disk -Number "$DiskNumber"',
    '$Size = Get-PartitionSupportedSize -DriveLetter C',
    'Resize-Partition -DriveLetter C -Size $Size.SizeMax'
)
$Parameter = @{
    commands = $Commands
}
$Document = 'AWS-RunPowerShellScript'

Write-Host ""
Write-Host "Extending D: drive..." -ForegroundColor Green 
Try {
    $Cmd = Send-SSMCommand -DocumentName $Document -Parameter $Parameter -InstanceId $InstanceId
    While ($Cmd.Status -ne 'Success') {
        $Cmd = Get-SSMCommand -CommandId $Cmd.CommandId
        Start-Sleep 5
    }
    Write-Host ""
    Write-Host "D: drive is extended" -ForegroundColor Green
    #Get-SSMCommand -CommandId $Cmd.CommandId | Select-Object DocumentName, Status
}
Catch {

    Write-Host ""
    Write-Host "Failed to extend drive" -ForegroundColor Red
}