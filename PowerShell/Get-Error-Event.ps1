Get-EventLog -ComputerName app3534 -LogName System -Newest 10 -EntryType Error | ft MachineName, TimeGenerated , EntryType, EventID, Message -Wrap

