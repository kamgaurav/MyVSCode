param(

    [parameter(mandatory=$true)][string] $volumeid

)

if ((Get-EC2Volume -VolumeId $volumeid).Attachments[0]) {

$instanceid = (Get-EC2Volume -VolumeId $volumeid).Attachments[0].InstanceId


Dismount-EC2Volume -InstanceId $instanceid -VolumeId $volumeid

Start-Sleep 60

Remove-EC2Volume -VolumeId $volumeid -Force

}

else {

Remove-EC2Volume -VolumeId $volumeid -Force

}
