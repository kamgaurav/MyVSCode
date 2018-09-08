On Error Resume Next

Set objExplorer = CreateObject("InternetExplorer.Application")


objExplorer.Navigate "http://localhost/index.html"

objExplorer.Visible = 1


Wscript.Sleep 5


Set objDoc = objExplorer.Document


Do While True

    Wscript.Sleep 3

    objDoc.Location.Reload(True)

    If Err <> 0 Then

        Wscript.Quit

    End If

Loop
