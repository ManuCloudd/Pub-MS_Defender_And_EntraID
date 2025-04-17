$getmailbox = Get-CASMailbox -Filter {ExchangeVersion -eq "0.20 (15.0.0.0)"} | ?{$_.OwaMailboxPolicy -like "$Null"}
$getmailbox |  Set-CASMailbox -OwaMailboxPolicy "Default"

