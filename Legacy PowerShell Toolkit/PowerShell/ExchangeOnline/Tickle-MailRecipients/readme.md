# Tickle-MailRecipients.ps1

**Version** : 1.0  
**Auteur** : Joseph Palarchio

Ce script « tickle » les boîtes aux lettres, les mail users et les groupes de distribution dans Exchange Online afin de forcer la mise à jour des Address Lists, qui ne se peuplent pas automatiquement après la création des objets.

---

## 📋 Description

1. **Collecte des objets**  
   - Récupère toutes les boîtes aux lettres (`Get-Mailbox -ResultSize Unlimited`).  
   - Récupère tous les mail users (`Get-MailUser -ResultSize Unlimited`).  
   - Récupère tous les groupes de distribution (`Get-DistributionGroup -ResultSize Unlimited`).

2. **Tickle**  
   Pour chaque objet :  
   - Exécute la cmdlet `Set-Mailbox`, `Set-MailUser` ou `Set-DistributionGroup` en réécrivant le `-SimpleDisplayName` existant.  
   - Affiche la progression avec `Write-Progress` et des compteurs.

3. **Finalisation**  
   - Affiche « Tickling Complete » lorsque tous les objets ont été traités.

---

## 🔧 Prérequis

- **Exchange Online PowerShell** (ancien module) ou **ExchangeOnlineManagement** (recommandé).  
  - Pour l’ancien module : `Import-Module MSOnline` ou session PSSession vers `outlook.office365.com`.  
  - Pour le module moderne : `Install-Module ExchangeOnlineManagement` puis `Connect-ExchangeOnline`.
- Compte disposant des droits d’administration Exchange (rôle View-Only ou équivalent).  
- Autorisation réseau vers Exchange Online PowerShell.

> ⚠️ **Note** : la méthode d’import et de connexion peut évoluer ; adaptez-la selon les modules supportés par Microsoft (AzureAD / Microsoft Graph PowerShell, ExchangeOnlineManagement, etc.).

---

## ⚙️ Utilisation

1. **Téléchargez** le script `Tickle-MailRecipients.ps1`.  
2. Ouvrez **PowerShell** (ou **Exchange Management Shell**) et connectez-vous :  
   - **Module moderne** :  
     ```powershell
     Import-Module ExchangeOnlineManagement
     Connect-ExchangeOnline -UserPrincipalName admin@domain.com
     ```  
   - **Ancienne méthode** :  
     ```powershell
     $session = New-PSSession -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential (Get-Credential) -Authentication Basic -AllowRedirection
     Import-PSSession $session
     ```
3. **Exécutez** le script :  
   ```powershell
   .\Tickle-MailRecipients.ps1
   ```
4. **Vérifiez** les Address Lists : les listes devraient désormais inclure les objets récemment provisionnés.

---

## 🚀 Exemple de sortie console

```text
Mailboxes Found: 1250
Tickling Mailboxes [1250]...50%
Mail Users Found: 200
Tickling Mail Users [200]...100%
Distribution Groups Found: 75
Tickling Distribution Groups [75]...100%
Tickling Complete
```

---

> ⚠️ **Tester impérativement** en environnement de labo avant toute utilisation en production.  
> **Sauvegardez** vos configurations si nécessaire et planifiez une fenêtre de maintenance pour limiter l’impact sur les utilisateurs.

