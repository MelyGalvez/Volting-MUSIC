// Importation des bibliothèques nécessaires
import ddf.minim.*;               // Bibliothèque Minim pour gérer le son
import ddf.minim.signals.*;       // Permet d'utiliser des signaux comme les ondes sinusoïdales
import processing.serial.*;       // Bibliothèque pour la communication série avec Arduino

// Déclaration des objets
Serial myPort;                    // Port série pour communiquer avec Arduino
Minim minim;                      // Objet principal pour Minim
AudioOutput out;                  // Sortie audio
SineWave sine;                    // Onde sinusoïdale générée

float currentFreq = 0;            // Fréquence courante du son (en Hz)
float currentVolume = 0.5;        // Volume courant (de 0 à 1)

void setup() {
  size(200, 200);                 // Taille de la fenêtre graphique

  minim = new Minim(this);        // Initialisation de Minim
  out = minim.getLineOut(Minim.STEREO); // Utilisation de la sortie audio stéréo

  // Création d'une onde sinusoïdale muette (fréquence 0, volume 0.5)
  sine = new SineWave(0, 0.5, out.sampleRate());
  out.addSignal(sine);            // Ajout de l'onde à la sortie audio

  // Connexion au port série (adapter COM3 si besoin)
  myPort = new Serial(this, "COM3", 9600);
  myPort.bufferUntil('\n');      // Attente d'une ligne complète avant de déclencher serialEvent()

  println("Connecté, prêt à recevoir les données.");
}

void draw() {
  background(0); // Fond noir (aucune visualisation dans cette version)
}

// Fonction appelée automatiquement quand un message est reçu depuis le port série
void serialEvent(Serial myPort) {
  String inString = myPort.readStringUntil('\n'); // Lecture jusqu'à la fin de ligne
  if (inString != null) {
    inString = inString.trim(); // Supprime les espaces blancs ou retours chariot
    println("Reçu : " + inString); // Affiche ce qui a été reçu

    // Si un axe a bougé, change la fréquence du son
    if (inString.equals("X")) {
      playTone(500); // X → 500 Hz
    } else if (inString.equals("Y")) {
      playTone(800); // Y → 800 Hz
    } else if (inString.equals("Z")) {
      playTone(1000); // Z → 1000 Hz

    // Si on reçoit une distance, on ajuste le volume du son
    } else if (inString.startsWith("Distance:")) {
      float distance = float(inString.split(":")[1].trim()); // Extrait la valeur
      float volume = map(distance, 0, 30, 1, 0);  // Distance courte = volume élevé
      volume = constrain(volume, 0, 1);           // S'assure que le volume reste entre 0 et 1
      currentVolume = volume;
      sine.setAmp(currentVolume);                // Applique le nouveau volume
    }
  }
}

// Modifie la fréquence du son en gardant le volume actuel
void playTone(float freq) {
  currentFreq = freq;              // Met à jour la fréquence
  sine.setFreq(currentFreq);       // Applique la fréquence à l'onde
  sine.setAmp(currentVolume);      // Réapplique le volume pour s'assurer de la cohérence
}
