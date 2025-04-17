# Import-Domains-Verification.ps1

Ce document présente le script PowerShell **Import-Domains-Verification.ps1** et en explique le fonctionnement.

---

## 1. Script complet

```powershell
write-host --------------------------------------------
write-host Importing....
write-host --------------------------------------------

# Import et comptage des domaines depuis un fichier CSV
$count      = Import-Csv .\domains.csv | Measure-Object
$domainlist = Import-Csv .\domains.csv

write-host
write-host --------------------------------------------
write-host Importing $($count.Count) Domains....
write-host --------------------------------------------

$logfile = ".\domains.log"

# Fonction pour ajouter une ligne au fichier de log
Function LogWrite {
    Param ([string]$logstring)
    Add-Content $logfile -Value $logstring
}

# En-tête du CSV de log
LogWrite "Domain,TXTRecord"

# Boucle sur chaque domaine
foreach ($domain in $domainlist) {
    # Création du domaine dans MSO (Microsoft Online)
    New-MSOLDomain -Name $domain.domain

    # Récupération du proof token DNS
    $proof   = (Get-MSOLDomainVerificationDNS -DomainName $domain.domain `
               | Select-Object -ExpandProperty Label).Split(".")[0]
    $txtrecord = "MS=$proof"

    # Enregistrement dans le log
    LogWrite "$($domain.domain),$txtrecord"
}
```

---

## 2. Explication détaillée

1. **Importation des domaines**  
   - Lit le fichier `domains.csv` (colonne `domain`) et en compte le nombre (`$count.Count`).  
   - Stocke la liste complète dans `$domainlist`.

2. **Affichage console**  
   - Utilise `Write-Host` pour indiquer le démarrage et le nombre de domaines à traiter.

3. **Gestion du log**  
   - Définit `$logfile` (`domains.log`).  
   - Fonction `LogWrite()` pour ajouter une ligne au fichier de log.  
   - Initialise le log avec un en-tête CSV : `Domain,TXTRecord`.

4. **Boucle de traitement**  
   Pour chaque domaine de la liste :
   - **New-MSOLDomain** : ajoute le domaine dans Azure AD via MSOnline.
   - **Get-MSOLDomainVerificationDNS** : récupère l’enregistrement DNS à créer pour la validation.
     - `.Label` donne une valeur du type `proofstring.domain.com`.  
     - `.Split('.')[0]` isole le token de validation (`proofstring`).  
   - Construit la chaîne TXT à publier : `MS=proofstring`.
   - Écrit dans le log une ligne CSV : `domain,MS=proofstring`.

---

## 3. Utilisation

1. Créez **domains.csv** avec une colonne `domain` :
   ```csv
   domain
   contoso.com
   fabrikam.net
   ```
2. Placez le script et `domains.csv` dans le même dossier.
3. Exécutez :
   ```powershell
   .\Import-Domains-Verification.ps1
   ```
4. Consultez `domains.log` pour obtenir la liste des enregistrements TXT à ajouter dans votre zone DNS.

---

> ⚠️ **Important** : Assurez-vous d’être connecté à votre tenant Azure AD avec un compte disposant des droits nécessaires :
> ```powershell
> Connect-MsolService
> ```

