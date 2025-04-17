# Activer TLS 1.2 via PowerShell

Ce script configure Windows Server et le framework .NET pour forcer l’utilisation de **TLS 1.2**, en créant ou modifiant les clés de registre nécessaires.

---

## 📋 Description

1. **Framework .NET 4.0 (32‑bits et 64‑bits)**  
   - Vérifie et crée la clé de registre `v4.0.30319` sous `WOW6432Node` et sous le chemin natif.  
   - Active les valeurs :`SystemDefaultTlsVersions=1` et `SchUseStrongCrypto=1` pour forcer TLS 1.2.

2. **Schannel Protocols (Server & Client)**  
   - Vérifie et crée les clés de registre pour le protocole `TLS 1.2` en mode **Server** et **Client**.  
   - Définit : `Enabled=1` et `DisabledByDefault=0` pour autoriser TLS 1.2 et désactiver les versions inférieures.

3. **Feedback console**  
   - Affiche un message final en couleur cyan pour indiquer que **TLS 1.2** est activé et rappeler de **redémarrer** le serveur.

---

## 🔧 Prérequis

- Exécuter le script **en tant qu’administrateur**.  
- Machine sous **Windows Server** avec .NET Framework 4.x installé.  
- Sauvegarde du registre recommandée avant toute modification.

---

## ⚙️ Utilisation

1. Copiez le contenu du script dans un fichier `.ps1`, par exemple :  
   ```powershell
   Enable-TLS12.ps1
   ```
2. Ouvrez **PowerShell** en mode administrateur.  
3. Exécutez :  
   ```powershell
   .\Enable-TLS12.ps1
   ```
4. **Redémarrez** immédiatement le serveur pour que les changements prennent effet.

---

> ⚠️ **Attention** : Ces modifications affectent l’ensemble des applications .NET et la sécurité réseau.  
> Testez d’abord dans un environnement de laboratoire avant de déployer en production.  
> Pensez à sauvegarder le registre (`reg export`) pour pouvoir revenir en arrière si besoin.  

---

*Fonce, active TLS 1.2 et renforce la sécurité de tes serveurs !*

