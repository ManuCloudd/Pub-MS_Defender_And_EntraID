Import-Csv C:\Users\ADUsers.csv | ForEach-Object {
   Set-ADUser $_.samAccountName -add @{
   ExtensionAttribute3 = "$($_.ExtensionAttribute3)"
    }
}