# Verify-Domains.ps1 (v0.4)

> ⚠️ **Statut : Déprécié**  
> Ce script est basé sur le module MSOnline et **ne fonctionne plus** avec les dernières versions d’Azure. Il est conservé pour historique et référence.

---

## 📋 Description

- Interroge Azure AD via MSOnline pour récupérer les domaines non vérifiés et vérifiés.
- Tente de valider automatiquement chaque domaine non vérifié (`Confirm-MsolDomain`).
- Enregistre un journal d’activité et exporte deux fichiers :
  - `unverified.txt` : domaines toujours non vérifiés.
  - `Verified.txt` : domaines confirmés.

## 🔧 Prérequis

- Module **MSOnline** installé (`Install-Module MSOnline`).
- Compte Azure AD avec droits de gestion des domaines.
- Connexion au service MSOnline avant exécution :
  ```powershell
  Connect-MsolService
  ```
- Script à placer dans un dossier où l’on dispose de droits d’écriture.

## ⚙️ Fonctionnement du script

```powershell
# Affichage de démarrage
Write-Host --------------------------------------------
Write-Host verification des domaines....
Write-Host --------------------------------------------

# Récupération des domaines
$domainlist      = Get-MsolDomain -Status Unverified
$domainlistcheck = $domainlist
$domainOK        = Get-MsolDomain -Status Verified

# Fichiers de sortie
$logfile         = ".\logfile.txt"
$exportUnverif   = ".\unverified.txt"
$exportVerif     = ".\Verified.txt"

# Confirmation automatique des domaines non vérifiés
foreach ($d in $domainlistcheck) {
  Confirm-MsolDomain -DomainName $d.Name | Export-Csv -Path $logfile -NoTypeInformation
}

# Export des listes finales
Get-MsolDomain | Where Status -eq 'unverified' |
  Select Name,Status | Export-Csv -Path $exportUnverif -NoTypeInformation
Write-Host "Export des domaines UNVERIFIED vers $exportUnverif" -ForegroundColor Green

Get-MsolDomain | Where Status -eq 'verified' |
  Select Name,Status | Export-Csv -Path $exportVerif -NoTypeInformation
Write-Host "Export des domaines VERIFIED vers $exportVerif" -ForegroundColor Green
```  

## 🚧 Limitations et dépréciation

- **MSOnline** ne reçoit plus de mises à jour ; migrer vers **AzureAD** ou **Microsoft Graph PowerShell**.
- Les cmdlets `Confirm-MsolDomain`, `Get-MsolDomain` sont obsolètes et peuvent retourner des erreurs.
- À utiliser uniquement à titre historique ou dans des environnements legacy.

---

> **Conseil** : Testez toute opération de domaine dans un environnement de laboratoire avant toute tentative en production.  
> Pour la migration, consultez la documentation Microsoft Graph PowerShell sur la gestion des domaines Azure AD.

