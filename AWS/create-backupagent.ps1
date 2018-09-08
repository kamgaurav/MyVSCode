# creating backup agent to take volume snapshot

param (

    [parameter(mandatory = $false)] [string] $type = 'Daily',
    [parameter(mandatory = $false)] [int] $rententiondays = 14 

)

# Tag volume if it is not tagged with 'BackupEnabled'

Get-EC2Volume | ForEach-Object {

    $haskey = $false
    $_.tag | ForEach-Object { 
    
                if ($_.Key -eq 'BackupEnabled') 
                
                {
                    $haskey = $true
                }
             }

if ($haskey -eq $false) {

    #add tag to this volume
    $volumeid = $_.VolumeId
    $tag = New-Object Amazon.EC2.Model.Tag
    $tag.Key = 'BackupEnabled'
    $tag.Value = 'True'
    Write-Host "Found new volume: $volumeid"

    New-EC2Tag -Resource $volumeid -Tag $tag
    
    }  
}

# filter volumes based 'BackupEnabled' tag

$filter = New-Object Amazon.EC2.Model.Filter
$filter.Name = 'tag:BackupEnabled'
$filter.Value = 'True'

Get-EC2Volume -Filter $filter | ForEach-Object {

#Backup routine goes here

# record name & attachment information in the snapshot description
if ($_.Attachment) {

        $device = $_.Attachment[0].Device
        $instanceid = $_.Attachment[0].InstanceId
        $reservation = Get-EC2Instance $instanceid

        #find instance from attachment value instanceid
        $instance = $reservation.Instances | Where-Object {$_.InstanceId -eq $instanceid}
        #find name of instance
        $name = ($instance.tag | Where-Object {$_.key -eq 'Name'}).value

        $description = "Currently attached to $name as $device"
    
}


    $volume = $_.VolumeId
    Write-Host "Creating snapshot of volume: $volume; $description"

    # take snapshot of volume
    $snapshot = New-EC2Snapshot -VolumeId $volume -Description "$type backup of volume $volume; $description"

    #add a tag for snapshot, so that it is distigushable from all others

    $tag = New-Object Amazon.EC2.Model.Tag
    $tag.Key = 'BackupType'
    $tag.Value = $type

    New-EC2Tag -Resource $snapshot.SnapshotId -Tag $tag


}

function purgebackups ($type, $retentiondays)

{

    # delete snapshots created by this script, that are older than specified no of days

    $filter = New-Object Amazon.EC2.Model.Filter
    $filter.Name = 'tag:BackupType'
    $filter.Value = $type
    $retentiondate = ([DateTime]::Now).AddDays(-$retentiondays)
    Get-EC2Snapshot -Filter $filter | Where-Object { [datetime]::Parse($_.StartTime) -lt $retentiondate} | `

    ForEach-Object {

        $snapshotid = $_.SnapshotId
        Write-Host "Removing snapshot: $snapshotid"

        Remove-EC2Snapshot -SnapshotId $snapshotid -Force


    }

}


