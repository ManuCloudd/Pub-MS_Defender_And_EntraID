<#
.SYNOPSIS
    Met à jour l'adresse SMTP principale d'utilisateurs Active Directory à partir d'un CSV.
.DESCRIPTION
    Pour chaque compte listé dans le CSV, génère une nouvelle adresse SMTP principale au format Prénom.Nom@suffixe,
    remplace l'ancienne principale par un alias en minuscules, et enregistre un log détaillé dans Active Directory on-prem.
.PARAMETER CsvPath
    Chemin complet vers le fichier CSV (doit contenir la colonne "EmailAddress").
.PARAMETER NewDomain
    Suffixe de domaine pour la nouvelle adresse SMTP (ex. "@domain.com").
.PARAMETER LogPath
    Chemin du fichier de log (par défaut "C:\temp\Add-SMTP-Address.log").
.EXAMPLE
    .\Add-SMTP-Address-v2.ps1 -CsvPath ".\users.csv" -NewDomain "@domain.com"
#>
param(
    [Parameter(Mandatory)] [string]$CsvPath,
    [Parameter(Mandatory)] [string]$NewDomain,
    [string]$LogPath = "C:\temp\Add-SMTP-Address.log"
)

# Démarrage du logging
Start-Transcript -Path $LogPath -Append

# Import du module Active Directory et SnapIn Exchange on-prem
try {
    Import-Module ActiveDirectory -ErrorAction Stop
    Add-PSSnapin Microsoft.Exchange.Management.PowerShell.SnapIn -ErrorAction Stop
} catch {
    Write-Error "Échec de l'importation des modules : $_"
    Exit 1
}

# Vérification du CSV
if (-not (Test-Path $CsvPath)) {
    Write-Error "CSV introuvable : $CsvPath"
    Exit 1
}

$csv = Import-Csv -Path $CsvPath -Delimiter ','

foreach ($row in $csv) {
    $email = $row.EmailAddress
    try {
        $user = Get-ADUser -Filter "mail -eq '$email'" -Properties proxyAddresses,GivenName,Surname,Mail
        if (-not $user) {
            Write-Warning "Utilisateur non trouvé pour $email"
            continue
        }

        # Génération de la nouvelle adresse et de l'alias
        $newMail      = ("{0}.{1}{2}" -f $user.GivenName, $user.Surname, $NewDomain).ToLower()
        $primaryProxy = $user.proxyAddresses | Where-Object { $_ -clike 'SMTP:*' }
        $lowerProxy   = $primaryProxy.ToLower()

        # Préparation des modifications
        $proxyChanges = @{
            proxyAddresses = @($lowerProxy, "SMTP:$newMail")
        }

        # Application en une seule commande
        Set-ADUser -Identity $user.SamAccountName -Replace $proxyChanges -EmailAddress $newMail -ErrorAction Stop -Verbose
        Write-Verbose "Traitement terminé pour $($user.SamAccountName)"

    } catch {
        Write-Error "Erreur sur $email : $_"
    }
}

Stop-Transcript
