$KB = Get-WUList -MicrosoftUpdate -RootCategories 'Critical Updates','Security Updates','Definition Updates' | select KB

if ($KB -ne 'null')

{

Get-WUInstall -MicrosoftUpdate -RootCategories 'Critical Updates','Security Updates','Definition Updates' -AcceptAll
$KB | export-csv -Path 'D:\gauravkam\scripts\Patch\Ptach.csv' -NoTypeInformation -Force

}
