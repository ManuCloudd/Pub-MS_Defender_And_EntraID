import msal
import os

# === Configuration de l'application ===
CLIENT_ID = "VOTRE_CLIENT_ID"
TENANT_ID = "VOTRE_TENANT_ID"
SCOPES = ["Mail.Read", "User.Read"]

# === Création de l'application MSAL ===
authority_url = f"https://login.microsoftonline.com/{TENANT_ID}"
app = msal.PublicClientApplication(CLIENT_ID, authority=authority_url)

# === Recherche d'un token déjà disponible ===
accounts = app.get_accounts()
result = None
if accounts:
    result = app.acquire_token_silent(SCOPES, account=accounts[0])

# === Si aucun token trouvé, lancer le Device Code Flow ===
if not result:
    flow = app.initiate_device_flow(scopes=SCOPES)
    if "user_code" not in flow:
        raise ValueError("Échec du Device Code Flow")

    print("\n\033[92m[MSAL] Ouvre ce lien et saisis le code :\033[0m")
    print(flow["message"])

    result = app.acquire_token_by_device_flow(flow)

# === Affichage ou sauvegarde du token ===
if "access_token" in result:
    print("\n\033[94m[SUCCÈS] Access token généré :\033[0m")
    print(result["access_token"])

    # Facultatif : écrire dans un fichier
    with open("token.txt", "w") as f:
        f.write(result["access_token"])
    print("\nToken sauvegardé dans token.txt")
else:
    print("\033[91m[ERREUR] Échec d'obtention du token :\033[0m")
    print(result.get("error_description"))
