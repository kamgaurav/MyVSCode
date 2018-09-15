$vol = Get-WmiObject win32_volume -Filter "DriveLetter='D:'"

$vol.AddMountPoint("C:\Test")