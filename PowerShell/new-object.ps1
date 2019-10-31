    # New psobject with add member (Drives C, D)

    $disks = Get-WmiObject Win32_LogicalDisk -Namespace "root\CIMV2" -Computername gauravkam

    $i = New-Object psobject

    $disks | foreach { $i | Add-Member -MemberType noteproperty -name Drive$($_.Name -replace ':' , '') -value ([math]::Round(($_.Size) / 1GB , 2)) -Force}

    $disks | foreach { $i | Add-Member -MemberType noteproperty -name FreeSpace$($_.Name -replace ':' , '') -value ([math]::Round(($_.FreeSpace) / 1GB , 2)) -Force}