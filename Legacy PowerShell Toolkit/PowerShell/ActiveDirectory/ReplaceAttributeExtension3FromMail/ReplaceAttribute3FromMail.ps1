Get-ADUser -Filter * -Properties mail |
ForEach-Object {
    $_ | Set-ADUser -Replace @{'ExtensionAttribute3'="$($_.mail.Trim())"}
}