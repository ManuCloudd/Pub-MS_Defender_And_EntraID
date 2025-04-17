#V0.4
# Changelog : add Export csv 05.12.16 (FR)
#emmanuel
#
###########
write-host 
write-host --------------------------------------------
write-host verification des domaines....
write-host --------------------------------------------
write-host
# Variable
$domainlist = Get-MsolDomain -Status Unverified
$domainlistcheck = $domainlist
$domainOK = Get-MsolDomain -Status verified
$logfile=".\logfile.txt"
$exportUnverif = ".\unverified.txt"
$exportVerif = ".\Verified.txt"
#Shell
foreach ($domainlistcheck in $domainlistcheck)
{Confirm-MsolDomain -DomainName $domainlistcheck.Name | Export-csv -path "$logfile" -NotypeInformation
}
write-host --------------------------------------------
write-host fichier logfile => "$logfile" -Foregroundcolor Yellow
write-host --------------------------------------------
Write-host 
Get-msoldomain |  where { $_.Status -eq "unverified" }  | select Name, Status | Export-csv -path "$exportUnverif" -NotypeInformation
Write-host Export des domaines UNVERIFIED vers "$exportUnverif" -Foregroundcolor Green
Write-host 
Get-msoldomain |  where { $_.Status -eq "verified" }  | select Name, Status | Export-csv -path "$exportVerif" -NotypeInformation
Write-host Export des domaines VERIFIED "$exportVerif" -Foregroundcolor Green
