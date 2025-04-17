# Add-ExtensionAttribute3-From-CSV.ps1

Ce script PowerShell lit un fichier CSV contenant les attributs `samAccountName` et `ExtensionAttribute3`, puis ajoute la valeur spécifiée dans **extensionAttribute3** de chaque compte Active Directory.

---

## 📋 Description

1. **Importation des données**  
   - `Import-Csv C:\Users\ADUsers.csv` : lit chaque ligne du fichier CSV et crée un objet avec les propriétés du CSV.

2. **Mise à jour de l’attribut**  
   - Pour chaque utilisateur (`ForEach-Object`) :  
     - Récupère le `samAccountName` (`$_.samAccountName`).  
     - Récupère la valeur `ExtensionAttribute3` (`$_.ExtensionAttribute3`).  
     - Exécute `Set-ADUser -Add @{ExtensionAttribute3 = '<valeur>'}` pour ajouter la valeur à l’attribut **extensionAttribute3**.

3. **Résultat**  
   - Chaque compte AD se voit ajouter la chaîne CSV fournie dans **extensionAttribute3**.  
   - Utile pour peupler des attributs personnalisés en masse.

---

## 🔧 Prérequis

- **Module ActiveDirectory** installé et importé :
  ```powershell
  Import-Module ActiveDirectory
  ```
- Droits suffisants pour modifier les comptes AD.  
- Machine membre du domaine ou session distante avec accès AD.  

---

## 📝 Format du CSV

Le fichier doit contenir au moins ces colonnes (séparateur point-virgule ou virgule) :

| samAccountName | ExtensionAttribute3   |
|---------------:|----------------------|
| jdupont        | prénom.nom@domain.com |
| mmartin        | autrevaleur          |

Enregistrez-le sous : `C:\Users\ADUsers.csv` (ou ajustez le chemin dans le script).

---

## 🚀 Usage

1. **Adapter le chemin du CSV** dans le script si nécessaire :  
   ```powershell
   $CsvPath = 'C:\Users\ADUsers.csv'
   ```
2. **Exécuter le script** :  
   ```powershell
   Import-Csv $CsvPath | ForEach-Object {
     Set-ADUser $_.samAccountName -Add @{ExtensionAttribute3 = $_.ExtensionAttribute3} -Verbose
   }
   ```
3. **Vérifier** la mise à jour :  
   ```powershell
   Get-ADUser -Filter * -Properties extensionAttribute3 |
     Select-Object Name,extensionAttribute3
   ```

---

> ⚠️ **Tester impérativement** dans un **environnement laboratoire** avant tout déploiement en production.  
> Assurez-vous que le CSV est correct (aucune ligne vide, noms valides) pour éviter toute erreur ou doublon d’attribut.  

> ℹ️ **Note** : l’utilisation de `-Add` peut créer plusieurs valeurs dans `extensionAttribute3`. Pour écraser ou remplacer, utilisez plutôt `-Replace`.  