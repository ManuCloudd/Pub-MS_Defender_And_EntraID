# Latency & Packet Loss Monitor

Ce script PowerShell effectue un **monitoring en continu** de la latence et des pertes de paquets vers une cible réseau (ex. `google.fr`). Il affiche en temps réel :

- La **latence** (ping) mise à jour toutes les 500 ms.
- Un message rouge lors de la première perte de paquet.
- La durée totale de la perte de paquet (en secondes) en jaune.
- Un avertissement jaune si la latence dépasse un seuil (par défaut 100 ms).

---

## 📋 Description

- **Boucle infinie** : exécute indéfiniment un `ping` avec un timeout de 1500 ms.  
- **Parsing du résultat** : extrait la valeur de latence (`temps=XX ms`) via regex.  
- **Gestion des pertes** : détecte si aucun `temps=` n’apparaît et affiche un message de **perte de paquets**.  
- **Suivi de la perte** : mesure la durée entre la première et la dernière perte, puis réinitialise.  
- **Highlight latence élevée** : si la latence dépasse 100 ms, affiche le détail.
- **Mise à jour console** : utilise `Set-ConsoleCursorPosition` pour rafraîchir proprement l’affichage.

---

## 🔧 Prérequis

- PowerShell (5.1 ou supérieur) sur Windows.  
- Cmdlet `ping` disponible dans l’environnement.  
- Console PowerShell prenant en charge les méthodes `[console]::SetCursorPosition` et `Write-Host`.

---

## ⚙️ Usage

1. **Copiez** le contenu du script dans un fichier `Monitor-Latency.ps1`.  
2. Ouvrez **PowerShell** (sans ISE, pour supporter la mise à jour de la console).  
3. Positionnez-vous dans le dossier contenant le script.  
4. **Exécutez** :
   ```powershell
   .\Monitor-Latency.ps1
   ```
5. Pour **arrêter** le monitoring, pressez `Ctrl+C`.

---

## ⚙️ Personnalisation

- **Cible du ping** : modifiez `google.fr` en début de script pour tester un autre hôte ou IP.  
- **Intervalle** : ajustez `Start-Sleep -m 500` pour changer la fréquence (en ms).  
- **Seuil de latence** : changez `100` dans la condition `[int]($Matches[1]) -gt 100` pour définir votre propre seuil.  
- **Format d’affichage** : adaptez les couleurs et messages via `Write-Host -ForegroundColor`.

---

> ⚠️ **Conseil** : testez d’abord dans une console de laboratoire pour vérifier les positions de curseur et la compatibilité avant de l’utiliser en production.  
> Gardez à l’esprit que la boucle est infinie ; prévoyez un moyen d’interruption (`Ctrl+C`).

