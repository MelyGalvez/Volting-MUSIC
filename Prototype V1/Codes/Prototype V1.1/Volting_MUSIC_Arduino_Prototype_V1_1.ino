// --- Bibliothèques nécessaires pour le capteur BNO055 ---
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

// Création de l’objet BNO055 avec l’ID 55
Adafruit_BNO055 bno = Adafruit_BNO055(55);

// --- Définition des broches pour les LEDs ---
const int BLUE_LED = 10;
const int GREEN_LED = 11;
const int RED_LED = 12;

// --- Définition des broches pour le capteur ultrason n°1 ---
const int trigPin1 = 6;
const int echoPin1 = 7;

// --- Définition des broches pour le capteur ultrason n°2 ---
const int trigPin2 = 9;
const int echoPin2 = 8;

void setup(void) {
  Serial.begin(115200); // Initialisation de la communication série à 115200 bauds

  // Configuration des broches des LEDs en sortie
  pinMode(BLUE_LED, OUTPUT);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);

  // État initial : LED bleue allumée pour signaler l’initialisation
  digitalWrite(BLUE_LED, HIGH);
  digitalWrite(GREEN_LED, LOW);
  digitalWrite(RED_LED, LOW);

  // Configuration des broches des capteurs à ultrasons
  pinMode(trigPin1, OUTPUT);
  pinMode(echoPin1, INPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(echoPin2, INPUT);

  // Initialisation du capteur d’orientation BNO055
  if (!bno.begin()) {
    // Si le capteur n’est pas détecté, afficher un message d’erreur et allumer la LED rouge
    Serial.println("Erreur capteur BNO055 non détecté.");
    digitalWrite(RED_LED, HIGH);    // signal d'erreur
    digitalWrite(BLUE_LED, LOW);
    while (1); // Stop le programme ici
  }

  delay(10);
  bno.setExtCrystalUse(true); // Utilisation du cristal externe pour plus de précision

  // Initialisation réussie : allumer la LED verte (prêt) et éteindre la bleue
  digitalWrite(GREEN_LED, HIGH);
  digitalWrite(BLUE_LED, LOW);
}

void loop(void) {
  // --- Lecture des données d’orientation depuis le BNO055 ---
  sensors_event_t event;
  bno.getEvent(&event);

  float currentX = event.orientation.x; // Angle de rotation sur l'axe X
  float currentZ = event.orientation.z; // Angle de rotation sur l'axe Z

  // Affichage des valeurs d’orientation sur le moniteur série
  Serial.print("X:");
  Serial.println(currentX);

  Serial.print("Z:");
  Serial.println(currentZ);

  // --- Mesure de la distance avec le capteur ultrason 1 ---
  long distance1 = mesureDistance(trigPin1, echoPin1);

  // --- Mesure de la distance avec le capteur ultrason 2 ---
  long distance2 = mesureDistance(trigPin2, echoPin2);

  // --- Calcul de la distance totale mesurée ---
  long totalDistance = distance1 + distance2;
  totalDistance = constrain(totalDistance, 0, 400); // Limite à 400 cm (200 cm max par capteur)

  // Affichage de la distance totale comme estimation d’un "volume"
  Serial.print("Volume:");
  Serial.println(totalDistance);

  delay(10); // Petite pause pour éviter de saturer le port série
}

// --- Fonction utilitaire pour mesurer une distance avec un capteur ultrason ---
long mesureDistance(int trig, int echo) {
  digitalWrite(trig, LOW);
  delayMicroseconds(1);
  digitalWrite(trig, HIGH); // Envoi d’une impulsion de 1 µs
  delayMicroseconds(1);
  digitalWrite(trig, LOW);

  // Mesure du temps que met l’écho à revenir
  long duration = pulseIn(echo, HIGH);

  // Conversion en distance (en cm)
  long distance = (duration / 2) / 29.1;

  // Limite la distance à 200 cm pour éviter des valeurs aberrantes
  return constrain(distance, 0, 200);
}