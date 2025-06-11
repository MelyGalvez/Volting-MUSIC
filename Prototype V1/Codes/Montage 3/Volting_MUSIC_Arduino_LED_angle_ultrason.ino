#include <Wire.h>                  // Bibliothèque pour la communication I2C
#include <Adafruit_Sensor.h>       // Bibliothèque de base pour les capteurs Adafruit
#include <Adafruit_BNO055.h>       // Bibliothèque pour le capteur d’orientation BNO055
#include <utility/imumaths.h>      // Fonctions mathématiques pour IMU

// Création d’un objet pour le capteur BNO055
Adafruit_BNO055 bno = Adafruit_BNO055(55);

// Définition des broches pour les LEDs
const int RED_LED = 3;
const int GREEN_LED = 4;
const int BLUE_LED = 5;

// Définition des broches pour le capteur à ultrasons
const int trigPin = 6;
const int echoPin = 7;

// Seuil de variation d’orientation (en degrés)
const float threshold = 3.0;

// Variables pour stocker la dernière orientation
float lastX = 0, lastY = 0, lastZ = 0;

void setup(void) {
  Serial.begin(9600); // Démarrage de la communication série

  // Déclaration des broches des LEDs comme sorties
  pinMode(RED_LED, OUTPUT);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(BLUE_LED, OUTPUT);
  
  // Déclaration des broches du capteur à ultrasons
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);

  // Initialisation du capteur BNO055
  if (!bno.begin()) {
    Serial.println("Oups, pas de BNO055 détecté ... Vérifiez votre câblage ou l'ADDR I2C !"); // Erreur si capteur non détecté
    while (1); // Boucle infinie en cas d’erreur
  }

  delay(1000); // Pause pour stabiliser le capteur
  bno.setExtCrystalUse(true); // Utilise un cristal externe pour plus de précision

  // Lecture initiale de l’orientation
  sensors_event_t event;
  bno.getEvent(&event);
  lastX = event.orientation.x;
  lastY = event.orientation.y;
  lastZ = event.orientation.z;
}

void loop(void) {
  // Lecture des données d’orientation
  sensors_event_t event;
  bno.getEvent(&event);

  float currentX = event.orientation.x;
  float currentY = event.orientation.y;
  float currentZ = event.orientation.z;

  // Allume la LED rouge si l’axe X a changé de plus de "threshold" degrés
  if (abs(currentX - lastX) > threshold) {
    digitalWrite(RED_LED, HIGH);
    Serial.println("X");
  } else {
    digitalWrite(RED_LED, LOW);
  }

  // Allume la LED verte si l’axe Y a changé de plus de "threshold" degrés
  if (abs(currentY - lastY) > threshold) {
    digitalWrite(GREEN_LED, HIGH);
    Serial.println("Y");
  } else {
    digitalWrite(GREEN_LED, LOW);
  }

  // Allume la LED bleue si l’axe Z a changé de plus de "threshold" degrés
  if (abs(currentZ - lastZ) > threshold) {
    digitalWrite(BLUE_LED, HIGH);
    Serial.println("Z");
  } else {
    digitalWrite(BLUE_LED, LOW);
  }

  // Mesure de la distance avec le capteur à ultrason
  long duration, distance;
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);                // Petit délai de sécurité
  digitalWrite(trigPin, HIGH);         // Envoie une impulsion de 10µs
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH);   // Mesure du temps de retour de l’écho
  distance = (duration / 2) / 29.1;    // Conversion du temps en distance en cm

  // Affiche la distance mesurée dans le moniteur série
  Serial.print("Distance: ");
  Serial.println(distance);

  // Convertit la distance en volume (plus proche = volume élevé)
  int volume = map(distance, 0, 200, 255, 0); // 0 cm = 255 (max), 200 cm = 0 (min)
  Serial.print("Volume: ");
  Serial.println(volume); // Cette valeur peut être utilisée par Processing par exemple

  // Mise à jour des valeurs d’orientation pour la prochaine boucle
  lastX = currentX;
  lastY = currentY;
  lastZ = currentZ;

  delay(10); // Petit délai pour ne pas saturer la lecture
}