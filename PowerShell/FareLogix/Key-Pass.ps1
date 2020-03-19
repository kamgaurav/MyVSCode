cls
write-host '###############################'
write-host '#                             #'
write-host '#       UserName              #'
write-host '#                             #'
write-host '#       1. BB                 #'
write-host '#       2. Email              #'
write-host '#       3. Grafana            #'
write-host '#       4. LastPass           #'
write-host '#       5. PagerDuty          #'
write-host '#       6. Solarwinds         #'
write-host '#       7. Zendesk            #' 
write-host '#       8. Exit               #'
write-host '#                             #'
write-host '#                             #'
write-host '###############################'
write-host ""
write-host ""

While(($Case = Read-Host -Prompt "Choose User Name") -ne "8") {


Switch($Case){
        1 { 
            cd 'C:\Program Files (x86)\KeePass Password Safe 2'
            .\KPScript -c:GetEntryString "D:\FareLogix\PWD_Database.kdbx" -pw:Arl1920# -Field:Password -ref-Title:"BigBrother"
          }
        2 { 
            cd 'C:\Program Files (x86)\KeePass Password Safe 2'
            .\KPScript -c:GetEntryString "D:\FareLogix\PWD_Database.kdbx" -pw:Arl1920# -Field:Password -ref-Title:"Email"
          }
        3 { 
            cd 'C:\Program Files (x86)\KeePass Password Safe 2'
            .\KPScript -c:GetEntryString "D:\FareLogix\PWD_Database.kdbx" -pw:Arl1920# -Field:Password -ref-Title:"Grafana"
          }
        4 { 
            cd 'C:\Program Files (x86)\KeePass Password Safe 2'
            .\KPScript -c:GetEntryString "D:\FareLogix\PWD_Database.kdbx" -pw:Arl1920# -Field:Password -ref-Title:"LastPass"
          }
        5 { 
            cd 'C:\Program Files (x86)\KeePass Password Safe 2'
            .\KPScript -c:GetEntryString "D:\FareLogix\PWD_Database.kdbx" -pw:Arl1920# -Field:Password -ref-Title:"PagerDuty"
          }
        6 { 
            cd 'C:\Program Files (x86)\KeePass Password Safe 2'
            .\KPScript -c:GetEntryString "D:\FareLogix\PWD_Database.kdbx" -pw:Arl1920# -Field:Password -ref-Title:"Solarwinds"        
          }
        7 {
            cd 'C:\Program Files (x86)\KeePass Password Safe 2'
            .\KPScript -c:GetEntryString "D:\FareLogix\PWD_Database.kdbx" -pw:Arl1920# -Field:Password -ref-Title:"Zendesk"
          }
        8 { "End" }
        default { 
        Write-Host ""
        Write-Host -ForegroundColor Red "Invalid entry: Please choose from displayed entries !!!" 
        Write-Host ""
        }
    }
    }