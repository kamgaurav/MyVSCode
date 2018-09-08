Start-Job -ScriptBlock { Get-Counter -Counter “\Processor(_Total)\% Processor Time” -SampleInterval 300 -Continuous | 
Export-Counter -Path D:\gauravkam\scripts\CPU.csv -Force -FileFormat "csv" }