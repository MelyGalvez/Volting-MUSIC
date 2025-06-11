import serial
import csv
import time
from datetime import datetime

ser = serial.Serial('COM8', 115200, timeout=1)

# Créer un nom de fichier avec date et heure
timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
path = rf"C:\Users\userlisv\Desktop\Projet Volting Instrument\Mesures Volting\Mesures\donnees_volting_{timestamp}.csv"

with open(path, 'w', newline='') as csvfile:
    fieldnames = [
        'time',
        'O_x', 'O_y', 'O_z',
        'L_x', 'L_y', 'L_z',
        'A_x', 'A_y', 'A_z',
        'G_x', 'G_y', 'G_z',
        'M_x', 'M_y', 'M_z',
        'Q_w', 'Q_x', 'Q_y', 'Q_z',
        'T',
        'D1',
        'D2'
    ]
    writer = csv.DictWriter(csvfile, fieldnames=fieldnames)
    writer.writeheader()

    data = {}

    try:
        while True:
            line = ser.readline().decode('utf-8').strip()
            if not line:
                continue

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

            elif line == '---':
                data['time'] = time.time()
                if all(key in data for key in fieldnames):
                    writer.writerow(data)
                    csvfile.flush()
                data = {}

    except KeyboardInterrupt:
        print("Arrêt par utilisateur")

    finally:
        ser.close()
