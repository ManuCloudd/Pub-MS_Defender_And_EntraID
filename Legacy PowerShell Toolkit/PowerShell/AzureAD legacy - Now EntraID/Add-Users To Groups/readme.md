# Add-ADUsers-To-Group.ps1

Ce script PowerShell automatise l’ajout d’utilisateurs Active Directory à un groupe cible, à partir d’un fichier CSV listant leurs alias (`mailNickname`). Le processus est documenté via un log de transcription.

---

## 📋 Description

1. **Transcription & logging**  
   - Démarre un log détaillé de la session dans `C:\Temp\Add-ADUsers.log` (`Start-Transcript -Append`).  
2. **Import des modules**  
   - Charge le module **ActiveDirectory** (cmdlets AD).  
3. **Lecture du CSV**  
   - Importe le fichier CSV (`users.csv`) contenant au minimum la colonne `mailNickname`.  
   - Stocke chaque ligne dans la variable `$Users`.
4. **Configuration du groupe cible**  
   - Spécifie la variable `$Group` (nom ou distinguishedName du groupe AD).  
5. **Boucle de traitement**  
   Pour chaque alias (`$mailNickname`):
   - **Vérifie l’existence** de l’utilisateur en AD (`Get-ADUser -Filter "mailNickname -eq '$mailNickname'"`).  
   - Si inexistant : affiche un message rouge.  
   - Si existant : récupère ses groupes (`Get-ADPrincipalGroupMembership`).  
     - Si déjà membre du groupe : affiche un avertissement jaune.  
     - Sinon : exécute `Add-ADGroupMember` pour ajouter l’utilisateur et affiche un message vert.
6. **Arrêt de la transcription**  
   - Clôt le log (`Stop-Transcript`).

---

## 🔧 Prérequis

- Machine Windows jointe au domaine AD.  
- Module **ActiveDirectory** (RSAT) installé.  
- Droits suffisants pour lire les comptes et ajouter des membres de groupe.  
- Fichier `users.csv` disponible et accessible (mêmes permissions de lecture).  

---

## ⚙️ Utilisation

1. **Préparer le CSV**  
   - Créez un fichier `users.csv` avec une colonne `mailNickname` :  
     ```csv
     mailNickname
     jdupont
     mmartin
     ```
2. **Modifier les variables du script** si nécessaire :  
   ```powershell
   $CsvPath = "C:\Users\Manu\Desktop\users.csv"      # Chemin vers votre CSV
   $Group   = "Full_F3"                                # Nom ou DN du groupe cible
   $LogPath = "C:\Temp\Add-ADUsers.log"              # Chemin du fichier de log
   ```
3. **Exécuter le script** :  
   ```powershell
   .\Add-ADUsers-To-Group.ps1
   ```
4. **Vérifier les logs et le groupe** :  
   - Consultez `C:\Temp\Add-ADUsers.log` pour le détail de chaque étape.  
   - Ouvrez **Active Directory Users and Computers** pour confirmer que les membres ont été ajoutés.

---

> ⚠️ **Tester d’abord** en environnement labo avant exécution en production pour éviter tout effet indésirable sur vos groupes AD.  
> Assurez-vous que le groupe cible existe et que vos alias correspondent bien à des comptes AD actifs.

