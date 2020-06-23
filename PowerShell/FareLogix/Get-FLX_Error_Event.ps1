# Get events after 00:00:00

Get-EventLog -LogName System -EntryType Error -After '2/6/2020 00:00:00' -Source "Service Control Manager" -Message "*FLX*" | ft -AutoSize -Wrap

Get-EventLog -LogName System -After '5/15/2020 00:00:00' -Source "Service Control Manager" -Message "*FLX*" | select TimeGenerated, UserName, EventID, MachineName, Message | ft -AutoSize -Wrap

