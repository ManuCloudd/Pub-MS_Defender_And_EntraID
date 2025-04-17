write-host 
write-host --------------------------------------------
write-host Importing....
write-host --------------------------------------------
$count=import-csv .\domains.csv | measure
$domainlist=import-csv .\domains.csv
write-host 
write-host --------------------------------------------
write-host Importing $count.count Domains....
write-host --------------------------------------------
$logfile=".\domains.log"

Function LogWrite {
 Param ([string]$logstring)
 Add-content $logfile -value $logstring
 }

logwrite "Domain,TXTRecord"

foreach ($domain in $domainlist) 
{
New-MSOLDomain -name $domain.domain
$proof = (Get-MSOLDomainVerificationDNS -domainname $domain.domain | select-object -expandproperty label).split(".")[0]
$txtrecord="MS=" + $proof
$domainrecord=$domain.domain
logwrite "$domainrecord,$txtrecord"
}
