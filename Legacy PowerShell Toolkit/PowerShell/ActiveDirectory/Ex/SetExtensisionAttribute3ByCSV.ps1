$NOext3 = Import-Csv -Path "C:\exportAduser.csv" -Delimiter ";"

$domain = "@domain.com"


foreach($aduser in $NOext3){
$Mail= $aduser.GivenName + "." + $aduser.SurName + "$domain"

$mail=$Mail.replace(" ","")

Set-ADUser -identity $aduser.samaccountname -Replace @{extensionAttribute3=$Mail} -Verbose
}