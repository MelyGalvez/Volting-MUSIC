# Importation des bibliothèques nécessaires
import serial              # Pour la communication série
import csv                 # Pour l’écriture des données dans un fichier CSV
import time                # Pour récupérer le timestamp (en secondes depuis Epoch)
from datetime import datetime  # Pour créer un nom de fichier horodaté

# Ouverture du port série COM8 avec un débit de 115200 bauds
ser = serial.Serial('COM8', 115200, timeout=1)

# Création du chemin du fichier CSV avec un nom basé sur la date et l'heure
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
path = rf"C:\Users\userlisv\Desktop\Projet Volting Instrument\Mesures Volting\Mesures\donnees_volting_{timestamp}.csv"

# Ouverture du fichier CSV en écriture
with open(path, 'w', newline='') as csvfile:
    # Définition des en-têtes du CSV
    fieldnames = [
        'time',
        'O_x', 'O_y', 'O_z',           # Orientation (Euler angles)
        'L_x', 'L_y', 'L_z',           # Accélération linéaire
        'A_x', 'A_y', 'A_z',           # Accélération brute
        'G_x', 'G_y', 'G_z',           # Gyroscope
        'M_x', 'M_y', 'M_z',           # Magnétomètre
        'Q_w', 'Q_x', 'Q_y', 'Q_z',    # Quaternion
        'T',                           # Température
        'D1',                          # Distance capteur 1
        'D2'                           # Distance capteur 2
    ]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()  # Écriture de la ligne d’en-tête dans le fichier

    data = {}  # Dictionnaire temporaire pour stocker les mesures d’un cycle

    try:
        while True:  # Boucle principale de lecture
            # Lecture d'une ligne sur le port série
            line = ser.readline().decode('utf-8').strip()
            if not line:
                continue  # Ligne vide, on ignore

            # Traitement selon le type de donnée (préfixe)
            if line.startswith('O:'):
                parts = line[2:].strip().split(',')
                if len(parts) == 3:
                    data['O_x'], data['O_y'], data['O_z'] = [p.strip() for p in parts]

            elif line.startswith('L:'):
                parts = line[2:].strip().split(',')
                if len(parts) == 3:
                    data['L_x'], data['L_y'], data['L_z'] = [p.strip() for p in parts]

            elif line.startswith('A:'):
                parts = line[2:].strip().split(',')
                if len(parts) == 3:
                    data['A_x'], data['A_y'], data['A_z'] = [p.strip() for p in parts]

            elif line.startswith('G:'):
                parts = line[2:].strip().split(',')
                if len(parts) == 3:
                    data['G_x'], data['G_y'], data['G_z'] = [p.strip() for p in parts]

            elif line.startswith('M:'):
                parts = line[2:].strip().split(',')
                if len(parts) == 3:
                    data['M_x'], data['M_y'], data['M_z'] = [p.strip() for p in parts]

            elif line.startswith('Q:'):
                parts = line[2:].strip().split(',')
                if len(parts) == 4:
                    data['Q_w'], data['Q_x'], data['Q_y'], data['Q_z'] = [p.strip() for p in parts]

            elif line.startswith('T:'):
                temp = line[2:].strip()
                data['T'] = temp

            elif line.startswith('D1:'):
                distance1 = line[3:].strip()
                data['D1'] = distance1

            elif line.startswith('D2:'):
                distance2 = line[3:].strip()
                data['D2'] = distance2

            # Lorsque la ligne "---" est reçue, cela indique la fin d’un cycle complet
            elif line == '---':
                data['time'] = time.time()  # Horodatage (secondes depuis Epoch)
                # Si toutes les données attendues sont présentes, on écrit dans le fichier
                if all(key in data for key in fieldnames):
                    writer.writerow(data)   # Enregistrement dans le fichier CSV
                    csvfile.flush()         # Sauvegarde immédiate sur disque
                data = {}  # Réinitialisation du dictionnaire pour la prochaine lecture

    except KeyboardInterrupt:
        print("Arrêt par utilisateur")  # Fin du script avec Ctrl+C

    finally:
        ser.close()  # Fermeture propre du port série
