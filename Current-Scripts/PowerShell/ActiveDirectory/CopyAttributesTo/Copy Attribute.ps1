# Affiche tous les utilisateurs d'une OU cible
Get-ADUser -Filter * -SearchBase "OU=TargetOU,DC=example,DC=local" |
    Format-Table Name, UserPrincipalName, Mail

# Remplace le suffixe UPN pour tous les users d'une OU spécifique
$LocalUsers = Get-ADUser -Filter { UserPrincipalName -like '*olddomain.local' } `
    -SearchBase "OU=TargetOU,DC=example,DC=local" `
    -Properties UserPrincipalName -ResultSetSize $null

$LocalUsers | ForEach-Object {
    $newUpn = $_.UserPrincipalName.Replace('olddomain.local','newdomain.example')
    $_ | Set-ADUser -UserPrincipalName $newUpn
}

# Copie la valeur de Mail dans le UPN pour les comptes ayant un mail défini
$users = Get-ADUser -Filter { UserPrincipalName -like '*olddomain.local' } `
    -SearchBase "OU=TargetOU,DC=example,DC=local" `
    -Properties Mail |
    Where-Object { $_.Mail }

foreach ($user in $users) {
    Set-ADUser $user -Replace @{ UserPrincipalName = $user.Mail }
}

# Nouveau remplacement de suffixe UPN, même logique
$LocalUsers = Get-ADUser -Filter { UserPrincipalName -like '*olddomain.local' } `
    -SearchBase "OU=TargetOU,DC=example,DC=local" `
    -Properties Mail |
    Where-Object { $_.Mail }

$LocalUsers | ForEach-Object {
    $newUpn = $_.UserPrincipalName.Replace('olddomain.local','anotherdomain.example')
    $_ | Set-ADUser -UserPrincipalName $newUpn
}

# Test sur un seul utilisateur identifié par DisplayName
$single = Get-ADUser -Filter { DisplayName -eq 'Test User' } `
    -Properties UserPrincipalName, Mail

foreach ($user in $single) {
    Set-ADUser $user -Replace @{ UserPrincipalName = $user.Mail }
}
