# ExtensionAttribute3-Updater.ps1

Ce dépôt contient le script **ExtensionAttribute3-Updater.ps1**, qui permet de remplir l’attribut `extensionAttribute3` d’utilisateurs Active Directory à partir d’un fichier CSV.

---

## 📋 Description

- Lit un CSV (`exportAduser.csv`) avec les colonnes :
  - `GivenName` (Prénom)
  - `SurName` (Nom)
  - `samAccountName`
- Construit une adresse e-mail au format `Prénom.Nom@domain.com`.
- Supprime les espaces éventuels dans l’adresse.
- Écrit la valeur finale dans l’attribut **extensionAttribute3** de chaque compte AD.

## 🔧 Prérequis

- Machine jointe au domaine Active Directory.
- Module **ActiveDirectory** installé.
- Droits suffisants pour modifier des comptes AD.
- Fichier CSV `exportAduser.csv` placé dans le même répertoire que le script (ou adapter `$CsvPath`).

## ⚙️ Utilisation

1. **Modifier les variables** en début de script si besoin :  
   ```powershell
   $CsvPath = "C:\exportAduser.csv"    # Chemin vers votre CSV
   $domain  = "@domain.com"           # Suffixe de domaine à appliquer
   ```

2. **Exécuter le script** :  
   ```powershell
   .\ExtensionAttribute3-Updater.ps1
   ```

3. **Vérifier le résultat** :
   - Ouvrez **Active Directory Users and Computers** ou utilisez `Get-ADUser -Properties extensionAttribute3` pour confirmer la mise à jour.

## ▶️ Exemple de CSV

```csv
GivenName;SurName;samAccountName
Jean;Dupont;jdupont
Marie;Martin;mmartin
```

---

> ⚠️ **À tester impérativement** en environnement de laboratoire avant tout déploiement en production.  
> Assurez-vous que le fichier CSV et le nom de domaine sont corrects pour éviter toute écriture incorrecte dans AD.

