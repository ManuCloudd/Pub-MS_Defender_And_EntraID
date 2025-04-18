# Extract-AllZips.py

Ce script Python parcourt récursivement un répertoire donné et extrait **tous** les fichiers `.zip` qu’il contient dans des sous-dossiers nommés d’après les archives.

---

## 📋 Description

- **Balayage récursif** : utilise `os.walk` pour explorer chaque sous-dossier du répertoire racine.  
- **Extraction** : pour chaque fichier finissant par `.zip`, crée un dossier du même nom (sans extension) et y extrait tout le contenu.  
- **Journalisation console** : affiche un message `[OK]` en cas de succès, ou `[ERREUR]` si le fichier ZIP est corrompu.

---

## 🔧 Prérequis

- **Python 3.x** installé.  
- Modules **standards** : `os`, `zipfile` (inclus dans la bibliothèque standard).  
- Droits de lecture/écriture sur le répertoire racine et ses sous-dossiers.

---

## ⚙️ Utilisation

1. **Copiez** le script dans un fichier, par exemple :  
   ```bash
   extract_all_zips.py
   ```
2. **Modifiez** la variable `racine` en bas du script pour indiquer le chemin à traiter :  
   ```python
   racine = r"C:\Users\XXXXX"
   ```
3. **Exécutez** le script depuis un terminal :  
   ```bash
   python extract_all_zips.py
   ```
4. **Résultat** : pour chaque `archive.zip`, un dossier `archive/` est créé et son contenu extrait.

---

## 📝 Exemple de sortie console

```text
[OK] C:\Users\XXXXX\docs\rapport.zip → C:\Users\XXXXX\docs\rapport
[ERREUR] Fichier corrompu : C:\Users\XXXXX\downloads\archive_abimee.zip
...
```

---

## 🚀 Améliorations possibles

- **Arguments en ligne de commande** : utiliser `argparse` pour passer le chemin racine sans modifier le script.  
- **Filtrage** : ajouter des options pour ne cibler que certains sous-dossiers ou motifs de fichiers.  
- **Logs en fichier** : diriger les messages vers un fichier de log plutôt que la console.

> ⚠️ **Tester d’abord** sur un petit répertoire pour vérifier le bon fonctionnement avant de lancer sur de larges