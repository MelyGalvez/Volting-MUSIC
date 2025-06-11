#include <Wire.h>                   // Bibliothèque pour la communication I2C
#include <Adafruit_Sensor.h>       // Bibliothèque de base pour les capteurs Adafruit
#include <Adafruit_BNO055.h>       // Bibliothèque spécifique au capteur BNO055
#include <utility/imumaths.h>      // Bibliothèque pour les mathématiques liées à l’IMU

// Création d’un objet BNO055 avec l’identifiant 55
Adafruit_BNO055 bno = Adafruit_BNO055(55);

// Définition des pins pour les LEDs
const int RED_LED = 3;
const int GREEN_LED = 4;
const int BLUE_LED = 5;

// Seuil de détection de variation d’angle (en degrés)
const float threshold = 3.0; // Un seuil plus grand réduit la sensibilité

// Dernières valeurs mesurées sur chaque axe
float lastX = 0, lastY = 0, lastZ = 0;

void setup(void) {
  Serial.begin(9600);  // Démarre la communication série à 9600 bauds
  Serial.println("Test du capteur d'orientation");  // Affiche un message d'initialisation

  // Définition des pins des LEDs comme sorties
  pinMode(RED_LED, OUTPUT);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(BLUE_LED, OUTPUT);

  // Initialisation du capteur BNO055
  if (!bno.begin()) {
    // Affiche un message d’erreur si le capteur n’est pas détecté
    Serial.println("Oups, pas de BNO055 détecté ... Vérifiez votre câblage ou l'ADDR I2C !");
    while (1); // Bloque le programme
  }

  delay(1000);  // Pause d'une seconde pour laisser le capteur se stabiliser
  bno.setExtCrystalUse(true);  // Utilise un cristal externe si disponible pour plus de précision

  // Lecture initiale des angles pour référence
  sensors_event_t event;
  bno.getEvent(&event);
  lastX = event.orientation.x;
  lastY = event.orientation.y;
  lastZ = event.orientation.z;
}

void loop(void) {
  // Lecture d’un nouvel événement de capteur (angles actuels)
  sensors_event_t event;
  bno.getEvent(&event);

  // Récupération des valeurs d’orientation sur les axes X, Y, Z
  float currentX = event.orientation.x;
  float currentY = event.orientation.y;
  float currentZ = event.orientation.z;

  // Allume ou éteint les LEDs selon si la variation d'angle dépasse le seuil
  digitalWrite(RED_LED, abs(currentX - lastX) > threshold ? HIGH : LOW);
  digitalWrite(GREEN_LED, abs(currentY - lastY) > threshold ? HIGH : LOW);
  digitalWrite(BLUE_LED, abs(currentZ - lastZ) > threshold ? HIGH : LOW);

  // Met à jour les dernières valeurs pour comparaison au prochain tour
  lastX = currentX;
  lastY = currentY;
  lastZ = currentZ;

  // Affiche les valeurs actuelles dans le moniteur série
  Serial.print("X: ");
  Serial.print(currentX, 4);
  Serial.print("\tY: ");
  Serial.print(currentY, 4);
  Serial.print("\tZ: ");
  Serial.print(currentZ, 4);
  Serial.println("");

  delay(100);  // Attend 100 millisecondes avant la prochaine mesure
}