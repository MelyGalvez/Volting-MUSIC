import serial
import pygame
import numpy as np

# Paramètres de la gamme de notes et des variables globales
gamme_base = [16.35, 18.35, 20.60, 21.83, 24.50, 27.50, 30.87]  # Do à Si
note_names = ["Do", "Ré", "Mi", "Fa", "Sol", "La", "Si"]

# Variables pour suivre l'état actuel
base_note_index = 0
current_octave = 0
current_volume = 0.5
current_freq = 0
note_active = False

# Initialisation de pygame
sample_rate = 44100
pygame.mixer.init(frequency=sample_rate, size=-16, channels=1)

# Fonction pour créer une onde sinusoïdale
def generate_sine_wave(freq, duration, volume):
    t = np.linspace(0, duration, int(sample_rate * duration), endpoint=False)
    wave = np.sin(2 * np.pi * freq * t) * volume
    return (wave * 32767).astype(np.int16)

# Fonction pour jouer une fréquence
def play_tone(freq, volume):
    global current_freq
    if freq != current_freq:
        current_freq = freq
        samples = generate_sine_wave(freq, 1.0, volume)
        sound = pygame.sndarray.make_sound(samples)
        sound.play(-1)  # En boucle
    else:
        pygame.mixer.fadeout(0)  # Stopper l'ancien son sans attendre
        samples = generate_sine_wave(freq, 1.0, volume)
        sound = pygame.sndarray.make_sound(samples)
        sound.play(-1)

# Communication série avec le HC-05
ser = serial.Serial('/dev/ttyUSB0', 9600)  # Changez ce port selon votre configuration série

while True:
    if ser.in_waiting:
        in_string = ser.readline().decode().strip()

        if in_string.startswith("X:"):
            angle_x = float(in_string.split(":")[1].strip())
            angle_x = max(0, min(angle_x, 360))
            zone = int(angle_x / (360 / 7))
            base_note_index = max(0, min(zone, 6))
            print(f"Note: {note_names[base_note_index]}")

        elif in_string.startswith("Z:"):
            angle_z = float(in_string.split(":")[1].strip())
            delta = abs(angle_z + 90)

            if delta < 2.5 or delta > 20:
                note_active = False
                pygame.mixer.stop()
                print("Silence")
            else:
                mapped = np.interp(delta, [2.5, 20], [0, 6])
                current_octave = int(round(mapped))
                freq = gamme_base[base_note_index] * (2 ** current_octave)
                note_active = True
                play_tone(freq, current_volume)
                print(f"Joue : {freq:.2f} Hz | Octave: {current_octave}")

        elif in_string.startswith("Volume:"):
            distance_cm = float(in_string.split(":")[1].strip())
            distance_cm = max(40, min(distance_cm, 300))
            norm = (distance_cm - 40) / (300 - 40)
            current_volume = (1 - norm) ** 2
            if note_active:
                play_tone(current_freq, current_volume)
            print(f"Volume: {current_volume:.2f}")
