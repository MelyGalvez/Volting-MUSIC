# Importation de la bibliothèque Bleak, qui permet de gérer les communications Bluetooth Low Energy (BLE)
from bleak import BleakScanner

# Importation du module asyncio pour la gestion des fonctions asynchrones
import asyncio

# Définition d'une fonction asynchrone qui va scanner les périphériques BLE à proximité
async def run():
    # Découverte des périphériques Bluetooth à portée
    devices = await BleakScanner.discover()
    
    # Affichage des informations sur chaque périphérique détecté
    for d in devices:
        print(d)

# Vérification si une boucle d'événements asyncio est déjà en cours d'exécution
try:
    loop = asyncio.get_running_loop()
except RuntimeError:
    # Si aucune boucle n'existe, on initialise loop à None
    loop = None

# Si une boucle est déjà en cours (cas typique dans un environnement interactif comme Jupyter ou Spyder)
if loop and loop.is_running():
    print("Boucle détectée, exécution adaptée...")
    # On planifie l'exécution de la fonction run dans la boucle existante
    task = asyncio.ensure_future(run())
else:
    # Si on est dans un script Python classique, on lance une nouvelle boucle pour exécuter run
    asyncio.run(run())