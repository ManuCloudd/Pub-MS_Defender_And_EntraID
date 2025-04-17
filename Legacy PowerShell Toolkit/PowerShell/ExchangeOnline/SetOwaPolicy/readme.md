# Set-OwaMailboxPolicy.ps1

Ce script PowerShell permet de repérer les boîtes aux lettres CAS (Client Access Services) sur Exchange dont la version correspond à **0.20 (15.0.0.0)** et qui n'ont **aucune politique OWA**, puis d'appliquer la politique **Default**.

---

## 📋 Description

1. **Récupération des boîtes**  
   - `Get-CASMailbox -Filter {ExchangeVersion -eq "0.20 (15.0.0.0)"}` : sélectionne les boîtes CAS dont la version Exchange est exactement 0.20 (15.0.0.0).  
   - `| Where-Object {$_.OwaMailboxPolicy -like "$Null"}` : filtre celles qui n'ont pas de politique OWA attribuée.

2. **Application de la politique OWA**  
   - `Set-CASMailbox -OwaMailboxPolicy "Default"` : assigne la politique nommée **Default** à chaque boîte sans politique.

---

## 🔧 Prérequis

- **Exchange Management Shell** (on‑premise) ou module Exchange Online (selon votre infrastructure).  
- Droits d’administration Exchange suffisants pour exécuter `Get-CASMailbox` et `Set-CASMailbox`.  
- Chargement du module Exchange (automatique dans l’EMS).

---

## ⚙️ Script complet

```powershell
# Sélection des boîtes CAS sans politique OWA sur la version 0.20 (15.0.0.0)
$getmailbox = Get-CASMailbox -Filter {ExchangeVersion -eq "0.20 (15.0.0.0)"} |
              Where-Object { $_.OwaMailboxPolicy -eq $null }

# Assignation de la politique Default à chaque boîte concernée
$getmailbox | Set-CASMailbox -OwaMailboxPolicy "Default"
```

---

## ▶️ Utilisation

1. Ouvrez **Exchange Management Shell** (ou un shell connecté à votre tenant Exchange).  
2. Collez et exécutez les commandes ci‑dessous :  
   ```powershell
   .\Set-OwaMailboxPolicy.ps1
   ```
3. Vérifiez la mise à jour :  
   ```powershell
   Get-CASMailbox -Filter {ExchangeVersion -eq "0.20 (15.0.0.0)"} |
   Where-Object { $_.OwaMailboxPolicy -eq $null }
   ```  
   Si la commande ne retourne aucun résultat, toutes les boîtes ont la politique **Default**.

---

> ⚠️ **Tester d’abord** en environnement de labo avant déploiement en production pour éviter toute interruption de service.  
> Adaptez le filtre `ExchangeVersion` et le nom de la politique OWA si nécessaire pour votre environnement.

