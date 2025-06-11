// Importation des bibliothèques nécessaires
import ddf.minim.*;             // Bibliothèque Minim pour l'audio
import ddf.minim.signals.*;     // Pour générer des signaux audio comme une onde sinusoïdale
import processing.serial.*;     // Pour la communication série (Arduino)

// Déclarations globales
Serial myPort;                  // Objet pour la communication série
Minim minim;                    // Objet principal Minim
AudioOutput out;                // Sortie audio
SineWave sine;                  // Onde sinusoïdale pour générer le son

// Variables pour suivre l'état actuel
float currentFreq = 0;          // Fréquence actuelle de la note
float currentVolume = 0.5;      // Volume actuel
int currentOctave = 0;          // Octave actuelle
int baseNoteIndex = 0;          // Index de la note de base (Do à Si)
boolean noteActive = false;     // Indique si une note est jouée
String currentNote = "";        // Nom de la note actuelle

void setup() {
  size(300, 200);               // Taille de la fenêtre d'affichage
  minim = new Minim(this);      // Initialisation Minim
  out = minim.getLineOut(Minim.STEREO);   // Sortie stéréo
  sine = new SineWave(0, 0, out.sampleRate()); // Onde sinusoïdale initiale (0 Hz, 0 volume)
  out.addSignal(sine);          // Ajoute l'onde à la sortie audio

  myPort = new Serial(this, "COM11", 115200); // Ouverture du port série (à adapter si besoin)
  println("Connecté, prêt à recevoir les données.");
}

void draw() {
  // Lecture en boucle des données série
  while (myPort.available() > 0) {
    String inString = myPort.readStringUntil('\n'); // Lecture ligne par ligne
    if (inString != null) {
      processSerial(inString.trim()); // Nettoie et traite la ligne reçue
    }
  }

  // Affichage graphique
  background(0);                // Fond noir
  fill(255);                    // Texte blanc
  textAlign(CENTER, CENTER);    // Texte centré

  if (noteActive) {
    // Affiche les infos de la note active
    text("Fréquence : " + nf(currentFreq, 1, 1) + " Hz", width / 2, height / 2 - 60);
    text("Volume : " + nf(currentVolume, 1, 2), width / 2, height / 2 - 30);
    text("Octave : " + currentOctave, width / 2, height / 2);
    text("Note : " + currentNote, width / 2, height / 2 + 30);
  } else {
    // Affiche "Silence" si aucune note n'est jouée
    text("Silence", width / 2, height / 2);
  }
}

void processSerial(String inString) {
  // Traitement des données X (choix de la note)
  if (inString.startsWith("X:")) {
    float angleX = float(inString.split(":")[1].trim());     // Extrait l'angle
    angleX = constrain(angleX, 0, 360);                      // Contraint l'angle entre 0 et 360°
    int zone = int(map(angleX, 0, 360, 0, 7));               // Divise en 7 zones (Do à Si)
    baseNoteIndex = constrain(zone, 0, 6);                   // Assure une indexation valide

    String[] notes = {"Do", "Ré", "Mi", "Fa", "Sol", "La", "Si"};
    currentNote = notes[baseNoteIndex];                     // Met à jour le nom de la note
  }

  // Traitement des données Z (choix de l'octave + activation note)
  else if (inString.startsWith("Z:")) {
    float angleZ = float(inString.split(":")[1].trim());    // Extrait l'angle Z
    float delta = abs(angleZ + 90);                         // Corrige et centre la valeur

    if (delta < 2.5 || delta > 20) {
      // Zone hors plage : silence
      sine.setAmp(0);
      noteActive = false;
      currentOctave = 0;
    } else {
      // Zone valide : calcul de l'octave
      float mapped = map(delta, 2.5, 20, 0, 6);             // Mappe angle -> octave
      currentOctave = round(mapped);                        // Arrondi à l'octave entier

      // Fréquences de base des notes (octave 0)
      float[] gammeBase = {
        16.35, 18.35, 20.60, 21.83, 24.50, 27.50, 30.87
      };

      float freq = gammeBase[baseNoteIndex] * pow(2, currentOctave); // Calcule la fréquence
      playTone(freq);                         // Joue la note
      noteActive = true;
    }
  }

  // Traitement du volume (distance en cm)
  else if (inString.startsWith("Volume:")) {
    float distanceCm = float(inString.split(":")[1].trim()); // Extrait la distance
    distanceCm = constrain(distanceCm, 40, 300);             // Plage utile

    float norm = map(distanceCm, 40, 300, 0, 1);             // Normalise de 0 à 1
    float volNorm = pow(1 - norm, 2);                        // Amplifie proximité (exponentielle)

    currentVolume = volNorm;                                // Met à jour le volume

    if (noteActive) {
      sine.setAmp(currentVolume);                           // Applique le volume si actif
    }
  }
}

// Fonction pour jouer une note
void playTone(float freq) {
  if (freq != currentFreq) {
    currentFreq = freq;             // Met à jour la fréquence si différente
    sine.setFreq(currentFreq);     // Applique à l'onde sinusoïdale
  }
  sine.setAmp(currentVolume);      // Applique le volume actuel
}
