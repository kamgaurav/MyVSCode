<powershell>
$disks = get-disk |sort number |select -skip 3
foreach ($disk in $disks)
{
if ($disk.number -ge 3)

 {
 
    switch ($disk.Number)
 
        {
            "3"{$Lable = 'sysdb'}
            "4"{$Lable = 'log'}
            "5"{$Lable =  'data1'}
            "6"{$Lable =  'data2'}
            "7"{$Lable = 'tempdb1'}
            "8"{$Lable =  'tempdb2'}
            "9"{$Lable =  'backup1'}
            Default {'Unknown'}
        }

  $path = "E:\$Lable"
  if (!(Test-Path $path)){New-Item -ItemType "directory" -path $path}
 
    $disk| clear-disk -RemoveData -Confirm:$false
 
    Initialize-Disk $disk.number -PartitionStyle GPT
 
    $newpartition=New-Partition -DiskNumber $disk.number -UseMaximumSize
    Start-Sleep -Seconds 3
   Add-PartitionAccessPath -DiskNumber $disk.Number -PartitionNumber 2 -AccessPath $path -Confirm:$false
    # "Mount up"
   
         $newpartition|Format-Volume -FileSystem NTFS -NewFileSystemLabel $lable -Force -Confirm:$false
    }
   $lable = $null
 }
< /powershell>
< persist>true</persist>