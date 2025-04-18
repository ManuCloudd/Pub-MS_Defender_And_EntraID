import os
import zipfile

def extract_all_zips(root_dir):
    """
    Parcourt root_dir et ses sous-dossiers,
    extrait chaque .zip dans un dossier du même nom.
    """
    for dirpath, dirnames, filenames in os.walk(root_dir):
        for fname in filenames:
            if fname.lower().endswith('.zip'):
                zip_path = os.path.join(dirpath, fname)
                # Dossier cible = même dossier que le zip, nom = nom_du_zip_sans_.zip
                target_dir = os.path.join(dirpath, os.path.splitext(fname)[0])
                os.makedirs(target_dir, exist_ok=True)
                try:
                    with zipfile.ZipFile(zip_path, 'r') as z:
                        z.extractall(target_dir)
                    print(f"[OK] {zip_path} → {target_dir}")
                except zipfile.BadZipFile:
                    print(f"[ERREUR] Fichier corrompu : {zip_path}")

if __name__ == "__main__":
    # Remplacez par le chemin de votre répertoire principal
    racine = r"C:\Users\XXXXX"
    extract_all_zips(racine)
