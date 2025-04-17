#################################################################
#
#Transfert via CSV d'une adresse vers un groupe ou adresse
#
####
$filepath = "C:\Users\Manu\Desktop\transfertTOCSV\Import-CSV-TransfertTO.csv"

import-csv $filepath | foreach {
Set-Mailbox -Identity $_.upn -DeliverToMailboxAndForward $true -ForwardingSMTPAddress $_.forwardto -verbose
}
# Check and Export

$filepathExport = "C:\Users\Manu\Desktop\transfertTOCSV\results.csv"

import-csv $filepath | foreach {
Get-Mailbox | where { $_.DeliverToMailboxAndForward -like "True" -or "false" } | select DisplayName,UserPrincipalName,ForwardingSmtpAddress,delivertomailboxandforward | sort "DeliverToMailboxAndForward" | export-csv -path $filepathExport -NotypeInformation
}
Write-host "Export du resultat vers $filepathExport " -ForegroundColor Green