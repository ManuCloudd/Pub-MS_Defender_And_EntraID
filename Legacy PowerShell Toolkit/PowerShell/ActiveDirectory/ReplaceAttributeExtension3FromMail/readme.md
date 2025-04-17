# Bulk-ExtensionAttribute3-From-Mail

Ce script PowerShell remplit l’attribut **extensionAttribute3** de chaque compte Active Directory en utilisant la valeur de leur attribut **mail** existant.

---

## 📋 Description

1. **Récupération des utilisateurs**  
   - `Get-ADUser -Filter * -Properties mail` : récupère tous les comptes AD et charge la propriété `mail`.

2. **Boucle de mise à jour**  
   - Pour chaque objet utilisateur (`ForEach-Object`) :  
     - Lit l’adresse mail (`$_.mail`), retire les espaces superflus avec `.Trim()`.  
     - Utilise `Set-ADUser -Replace` pour écrire cette adresse dans `extensionAttribute3`.

3. **Résultat**  
   - Chaque compte AD dispose désormais d’une valeur dans **extensionAttribute3** identique à sa valeur de **mail**, nettoyée des espaces.

---

## 🔧 Prérequis

- **Module ActiveDirectory** installé et importé (`Import-Module ActiveDirectory`).  
- Droits suffisants pour lire et modifier les comptes AD.  
- Exécuté sur une machine membre du domaine ou depuis une session distante avec accès AD.

---

## ⚙️ Script complet

```powershell
Get-ADUser -Filter * -Properties mail |
ForEach-Object {
    $_ | Set-ADUser -Replace @{
        'extensionAttribute3' = $_.mail.Trim()
    } -Verbose
}
```

---

## ▶️ Utilisation

1. Ouvrez **Windows PowerShell** (ou **Active Directory Module for Windows PowerShell**).  
2. Collez le script ci-dessus ou sauvegardez-le dans un fichier `.ps1`, par exemple `Bulk-ExtAttr3-From-Mail.ps1`.  
3. Exécutez-le :  
   ```powershell
   .\Bulk-ExtAttr3-From-Mail.ps1
   ```
4. Vérifiez le résultat :  
   ```powershell
   Get-ADUser -Filter * -Properties extensionAttribute3,mail |
     Select-Object Name,mail,extensionAttribute3
   ```  
   Vous devez voir que `extensionAttribute3` contient la même valeur que `mail`.

---

> ⚠️ **Tester toujours** le script sur un **petit groupe** ou dans un **environnement labo** avant de l’exécuter sur l’ensemble de vos comptes AD.  
> Vous pouvez limiter la portée du filtre (`-Filter`) pour cibler une unité d’organisation spécifique ou un groupe d’utilisateurs avant un déploiement global.

