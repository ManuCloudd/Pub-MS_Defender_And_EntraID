# Generic-UPN-Management.ps1

Ce script PowerShell propose plusieurs opérations génériques de gestion des **UserPrincipalName (UPN)** et de consultation des comptes Active Directory dans un environnement anonymisé.

---

## 📋 Description

1. **Affichage des utilisateurs**  
   - Liste les comptes AD d’une unité d’organisation (OU) spécifiée en affichant `Name`, `UserPrincipalName` et `Mail`.

2. **Remplacement de suffixe UPN (Opération 1)**  
   - Recherche tous les UPN contenant `olddomain.local` dans l’OU cible.  
   - Remplace ce suffixe par `newdomain.example` pour chaque compte.

3. **Copie de l’attribut Mail vers le UPN**  
   - Sélectionne les comptes dont l’attribut `Mail` n’est pas vide.  
   - Met à jour `UserPrincipalName` avec la valeur de `Mail`.

4. **Remplacement de suffixe UPN (Opération 2)**  
   - Même logique que l’étape 2, mais remplace `olddomain.local` par `anotherdomain.example`.

5. **Test sur un seul utilisateur**  
   - Identifie un utilisateur via `DisplayName` strict (ex. `Test User`).  
   - Copie sa valeur `Mail` dans son `UserPrincipalName`.

---

## 🔧 Prérequis

- **Module ActiveDirectory** installé et chargé :  
  ```powershell  
  Import-Module ActiveDirectory  
  ```
- Droits AD suffisants pour exécuter `Get-ADUser` et `Set-ADUser`.
- Machine membre du domaine ou session avec accès au contrôleur de domaine.

---

## ⚙️ Configuration

- **OU cible** : remplacez `"OU=TargetOU,DC=example,DC=local"` par l’OU correspondant à votre environnement.
- **Suffixes UPN** : modifiez `olddomain.local`, `newdomain.example` et `anotherdomain.example` selon vos noms de domaine.
- **DisplayName de test** : ajustez `'Test User'` pour cibler un compte unique.

---

## 🚀 Usage

1. Placez le script `Generic-UPN-Management.ps1` sur votre machine.
2. Ouvrez PowerShell en tant qu’administrateur de domaine.
3. Exécutez :  
   ```powershell  
   .\Generic-UPN-Management.ps1  
   ```
4. Vérifiez les changements :  
   ```powershell  
   Get-ADUser -Filter {UserPrincipalName -like '*@newdomain.example'} -Properties Mail |  
     Format-Table Name, UserPrincipalName, Mail  
   ```

---

> ⚠️ **Important** : Testez impérativement dans un **environnement laboratoire** avant déploiement en production.  
> Adaptez tous les filtres, OU et suffixes UPN à la structure de votre annuaire.

