# Export-ADUsers-Report.ps1

Ce script PowerShell génère un rapport détaillé de vos utilisateurs Active Directory et l’exporte au format CSV, horodaté.

---

## 📋 Description

1. **Détermination du chemin et de l’horodatage**  
   - Utilise `Split-Path -Parent` pour récupérer le dossier du script.  
   - Génère un timestamp (`Get-Date -f yyyyMMddhhmm`) pour nommer le fichier de sortie.

2. **Import du module AD**  
   - `Import-Module ActiveDirectory` pour accéder aux cmdlets AD.

3. **Configuration des OUs**  
   - Liste `$DNs` des distinguishedNames (OU racines) à scanner.  
   - Vous pouvez spécifier une ou plusieurs OUs, ou la racine du domaine (`DC=exemple,DC=local`).

4. **Collecte des utilisateurs**  
   - Itère sur chaque OU, exécute `Get-ADUser -SearchBase $DN -Filter * -Properties *`.  
   - Concatène tous les résultats dans un tableau `$AllADUsers`.

5. **Sélection des attributs**  
   - Trie les utilisateurs par `Name`.  
   - Sélectionne un ensemble riche de propriétés AD via `Select-Object` avec des labels personnalisés :  
     - Prénom, Nom, DisplayName, SamAccountName, UserPrincipalName  
     - Adresse (rue, ville, État, code postal, pays)  
     - Titre, Département, Société  
     - Manager (récupère le DisplayName du manager)  
     - Description, Bureau, Téléphone, Mobile, Notes  
     - Statut du compte (`Enabled`/`Disabled`) et date du dernier logon

6. **Export CSV**  
   - Exporte le tableau final dans `AllADUsers_<timestamp>.csv` avec `Export-Csv -NoTypeInformation`.

---

## 🔧 Prérequis

- **Module ActiveDirectory** installé :  
  ```powershell  
  Install-WindowsFeature RSAT-AD-PowerShell  
  ```
- Compte disposant des droits de lecture sur les comptes AD.
- Permission d’écriture dans le dossier du script pour générer le CSV.

---

## ⚙️ Utilisation

1. **Adapter les OUs** dans la section `$DNs` du script :  
   ```powershell  
   $DNs = @(  
       "OU=Sales,OU=Users,DC=contoso,DC=local",  
       "OU=IT,OU=Users,DC=contoso,DC=local"  
   )  
   ```
2. **Placer** `Export-ADUsers-Report.ps1` dans le dossier souhaité.
3. **Exécuter** le script dans PowerShell :  
   ```powershell  
   .\Export-ADUsers-Report.ps1  
   ```
4. **Vérifier** le fichier généré :  
   ```text  
   C:\scripts\AllADUsers_202504171230.csv  
   ```

---

> ⚠️ **Tester d’abord** en environnement de laboratoire avant tout déploiement en production.  
> Ajustez les OUs et les chemins selon votre infrastructure.

