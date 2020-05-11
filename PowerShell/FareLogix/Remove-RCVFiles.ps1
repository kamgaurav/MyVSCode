$RCV_Files = Get-ChildItem -Path T:\TypeBMsg\DXC\in -File -Filter *.RCV

if ($RCV_Files.Count -ge 1) {

    $RCV_Files | Remove-Item
    Write-Host ""
    Write-Host "No of .RCV files deleted:" $RCV_Files.count
    Write-Host ""
    
}
else {

    Write-Host ""
    Write-Host "There are no .RCV Files now!"
    Write-Host ""
}

###################################################################

$RCV_Files = Get-ChildItem -Path T:\TypeBMsg\DXC\in -File -Filter *.RCV

if ($RCV_Files.Count -ge 1) {

    $RCV_Files | Remove-Item
    Add-Content -Path C:\Users\gkamble\Documents\RCV_Logs.txt -Value "No of .RCV files deleted: $($RCV_Files.count)"
    
}
else {

    Add-Content -Path C:\Users\gkamble\Documents\RCV_Logs.txt -Value "$(Get-Date) There are no .RCV Files now!"
}
