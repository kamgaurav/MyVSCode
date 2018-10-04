$Size = Get-PartitionSupportedSize -DriveLetter C
Resize-Partition -DriveLetter C -Size $Size.SizeMax