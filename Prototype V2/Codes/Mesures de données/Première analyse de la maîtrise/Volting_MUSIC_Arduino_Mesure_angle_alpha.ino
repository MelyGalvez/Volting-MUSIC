// --- Bibliothèques nécessaires pour le capteur BNO055 ---
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

// Création de l’objet BNO055 avec l’ID 55
Adafruit_BNO055 bno = Adafruit_BNO055(55);

void setup(void) {
  // Initialisation de la communication série à 115200 bauds
  Serial.begin(115200); 

  // Initialisation du capteur d’orientation BNO055
  if (!bno.begin()) {
    // Si le capteur n’est pas détecté, afficher un message d’erreur
    Serial.println("Erreur capteur BNO055 non détecté.");
    while (1); // Stop le programme ici
  }

  delay(10);
  bno.setExtCrystalUse(true); // Utilisation du cristal externe pour plus de précision
}

void loop(void) {
  // --- Lecture des données d’orientation depuis le BNO055 ---
  sensors_event_t event;
  bno.getEvent(&event);

  // Récupération de l'angle sur l'axe Z
  float currentZ = event.orientation.z; 

  // Affichage de l'angle Z pour le Serial Plotter
  Serial.print("AngleZ:");  // Nom de la donnée pour le plotter
  Serial.println(currentZ);  // Affiche l'angle Z

  delay(10); // Petite pause pour éviter de saturer le port série
}