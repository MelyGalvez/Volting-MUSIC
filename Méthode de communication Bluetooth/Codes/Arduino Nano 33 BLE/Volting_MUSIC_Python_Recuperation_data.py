# Importation du module asyncio pour gérer les opérations asynchrones
import asyncio

# Importation du client Bluetooth Low Energy de la bibliothèque Bleak
from bleak import BleakClient

# Adresse MAC Bluetooth de l'appareil cible (ici, l'Arduino Nano 33 BLE Sense)
adresse_ble = "3C:6B:62:36:31:17"

# UUID (Identifiant unique) de la caractéristique GATT à laquelle on veut accéder (à adapter selon l'Arduino)
uuid_caracteristique = "2A56"

# Fonction principale asynchrone
async def main():
    # Création d'un client BLE et tentative de connexion à l'appareil distant
    async with BleakClient(adresse_ble) as client:
        print("Connexion en cours...")

        # Vérification que la connexion a bien été établie
        if not client.is_connected:
            print("Erreur de connexion")
            return  # On quitte si la connexion a échoué

        try:
            # Boucle de lecture continue des données envoyées par l'Arduino
            while True:
                # Lecture de la caractéristique GATT spécifiée
                data = await client.read_gatt_char(uuid_caracteristique)

                # Affichage des données reçues (en supposant qu'elles sont encodées en UTF-8)
                print(f"Reçu de {uuid_caracteristique}: {data.decode()}")

                # Pause de 10 ms pour laisser le temps à l'Arduino d'envoyer les prochaines données
                await asyncio.sleep(0.01)

        # Gestion des erreurs pendant la lecture BLE
        except Exception as e:
            print(f"Erreur de lecture: {e}")

# Exécution de la boucle asynchrone
asyncio.run(main())