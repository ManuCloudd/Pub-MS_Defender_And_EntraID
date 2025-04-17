$immuID = Import-Csv "UPNtoImmutableID.csv"
$Users | ForEach-Object {
Set-MsolUser -UserPrincipalName $_.UserPrincipalName -ImmutableID $immuID | epcsv -path "" -nti
}