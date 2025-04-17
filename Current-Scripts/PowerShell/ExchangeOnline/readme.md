# Inspect-External-Forwarding.ps1

Ce script PowerShell se connecte à Exchange Online, parcourt toutes les boîtes aux lettres et identifie les règles de transfert configurées vers des destinataires externes. Il exporte ces règles dans un fichier CSV pour audit.

---

## 📋 Description

1. **Connexion à Exchange Online**  
   - Fonction `Connect-EXOnline` : ouvre une session distante via `New-PSSession` et `Import-PSSession`.  
   - **Note** : cette méthode utilise les anciens modules MSOnline/Remote PowerShell qui peuvent être dépréciés ; il est recommandé de migrer vers le module **ExchangeOnlineManagement** et la cmdlet `Connect-ExchangeOnline`, ou d’envisager Microsoft Graph PowerShell.

2. **Récupération des données**  
   - `Get-AcceptedDomain` : liste les domaines internes acceptés.  
   - `Get-Mailbox -ResultSize Unlimited` : récupère toutes les boîtes aux lettres Exchange Online.

3. **Analyse des règles de boîte de réception**  
   Pour chaque mailbox :  
   - Récupère les règles avec `Get-InboxRule -Mailbox <PrimarySmtpAddress>`.  
   - Filtre celles comportant `ForwardTo` ou `ForwardAsAttachmentTo`.

4. **Identification des destinataires externes**  
   - Extrait les adresses SMTP et en isole le domaine.  
   - Compare à la liste des domaines internes ; tout domaine non listé est considéré comme **externe**.

5. **Rapport et export CSV**  
   - Affiche en console chaque règle pointant vers un destinataire externe.  
   - Assemble un objet PSObject avec : `PrimarySmtpAddress`, `DisplayName`, `RuleId`, `RuleName`, `RuleDescription`, `ExternalRecipients`.  
   - Exporte ou ajoute (`-Append`) ces objets dans `C:\temp\externalrules.csv`.

---

## 🔧 Prérequis

- **Module Exchange Online remote PowerShell** natif ou **ExchangeOnlineManagement** plus récent.  
- Compte disposant des droits d’administration Exchange Online.  
- Permissions réseau pour se connecter à Exchange Online PowerShell.  
- Dossier **C:\temp** accessible en écriture (modifiable dans le script).

---

## ⚙️ Utilisation

1. Copiez le script dans `Inspect-External-Forwarding.ps1`.  
2. Ouvrez **PowerShell** (privilèges d’administration).  
3. Exécutez :  
   ```powershell
   .\Inspect-External-Forwarding.ps1
   ```
4. Entrez vos identifiants Office 365.  
5. Le fichier `C:\temp\externalrules.csv` sera généré ou mis à jour.

---

## 🚀 Exemple d’usage

```powershell
Inspect-External-Forwarding.ps1
# Résultat : CSV avec colonnes 
# PrimarySmtpAddress, DisplayName, RuleId, RuleName, RuleDescription, ExternalRecipients
```  

---

> ⚠️ **Tester en environnement de laboratoire** avant de lancer en production.  
> **Migrer** la méthode de connexion si votre organisation passe aux modules modernes ExchangeOnlineManagement ou Microsoft Graph PowerShell.  
> Ajustez le chemin de sortie et les paramètres selon votre infrastructure.

