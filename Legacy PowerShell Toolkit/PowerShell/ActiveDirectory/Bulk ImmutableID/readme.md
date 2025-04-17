# Set-ImmutableID-FromCSV.ps1

Ce script PowerShell permet de définir l’`ImmutableID` (ImmutableID/Azure AD Source Anchor) des utilisateurs Azure AD via le module **MSOnline**, à partir d’un fichier CSV.

---

## 📋 Description

1. **Import du CSV**  
   - `Import-Csv "UPNtoImmutableID.csv"` : lit chaque ligne du fichier et crée un objet avec les propriétés du CSV.  
   - Stocke l’ensemble dans `$immuID`.

2. **Boucle de traitement**  
   - Parcourt la collection `$Users` (attention, `$Users` doit idéalement être `$immuID`).  
   - Pour chaque entrée, exécute :  
     ```powershell
     Set-MsolUser -UserPrincipalName $_.UserPrincipalName -ImmutableID $immuID
     ```  
     afin d’appliquer la valeur d’`ImmutableID` depuis le CSV.

3. **Export du résultat**  
   - Tente d’exporter le résultat via `epcsv -path "" -nti` (probablement `Export-Csv`), mais le chemin est vide et la cmdlet abrégée.

---

## 🔧 Prérequis

- Module **MSOnline** installé :  
  ```powershell
  Install-Module MSOnline
  ```
- Connexion au service :  
  ```powershell
  Connect-MsolService
  ```
- Compte Azure AD avec droits suffisants pour exécuter `Set-MsolUser`.
- Fichier CSV `UPNtoImmutableID.csv` placé dans le même dossier ou spécifier son chemin complet.

---

## 📝 Format attendu du CSV

Le fichier `UPNtoImmutableID.csv` doit contenir au minimum ces colonnes :

| UserPrincipalName           | ImmutableID                       |
|-----------------------------|-----------------------------------|
| user1@domain.com            | a1b2c3d4e5f6g7h8i9j0               |
| user2@domain.com            | z9y8x7w6v5u4t3s2r1                 |

---

## ⚙️ Script complet

```powershell
$immuID = Import-Csv "UPNtoImmutableID.csv"

# Boucle pour chaque utilisateur (vérifier la variable)  
$Users | ForEach-Object {
    Set-MsolUser -UserPrincipalName $_.UserPrincipalName -ImmutableID $immuID |
    epcsv -path "" -nti
}
```

---

## 🚀 Utilisation

1. Placez `UPNtoImmutableID.csv` et `Set-ImmutableID-FromCSV.ps1` dans le même dossier (ou modifiez les chemins).  
2. Connectez-vous :  
   ```powershell
   Connect-MsolService
   ```
3. Exécutez le script :  
   ```powershell
   .\Set-ImmutableID-FromCSV.ps1
   ```
4. Vérifiez dans Azure AD que l’`ImmutableID` a été mis à jour pour chaque UPN.

---

> ⚠️ **Note** : Le script, tel quel, référence `$Users` au lieu de `$immuID` et utilise `epcsv` avec un chemin vide. Vous pouvez :
> - Remplacer `$Users` par `$immuID`.  
> - Utiliser la cmdlet complète `Export-Csv -Path "results.csv" -NoTypeInformation` pour générer un rapport.
>
> **Tester toujours** dans un environnement laboratoire avant tout déploiement en production.  

