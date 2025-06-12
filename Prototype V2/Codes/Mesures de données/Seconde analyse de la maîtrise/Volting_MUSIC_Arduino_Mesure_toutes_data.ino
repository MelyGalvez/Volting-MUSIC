// Inclusion des bibliothèques nécessaires
#include <Wire.h>                      // Communication I2C
#include <Adafruit_Sensor.h>          // Bibliothèque de base pour capteurs Adafruit
#include <Adafruit_BNO055.h>          // Bibliothèque pour le capteur de mouvement BNO055
#include <utility/imumaths.h>         // Mathématiques associées au BNO055 (quaternions, etc.)

// Initialisation du capteur BNO055
Adafruit_BNO055 bno = Adafruit_BNO055(55);

// Définition des broches pour les LEDs
const int BLUE_LED = 10;
const int GREEN_LED = 11;
const int RED_LED = 12;

// Définition des broches pour les deux capteurs ultrason
const int trigPin1 = 6;
const int echoPin1 = 7;
const int trigPin2 = 9;
const int echoPin2 = 8;

void setup(void) {
  Serial.begin(115200);  // Initialisation de la communication série à 115200 bauds

  // Configuration des LEDs en sortie
  pinMode(BLUE_LED, OUTPUT);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);
  digitalWrite(BLUE_LED, HIGH); // LED bleue allumée pendant l'initialisation

  // Configuration des capteurs ultrason (trig en sortie, echo en entrée)
  pinMode(trigPin1, OUTPUT);
  pinMode(echoPin1, INPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(echoPin2, INPUT);

  // Initialisation du capteur BNO055
  if (!bno.begin()) {
    Serial.println("Erreur capteur BNO055 non détecté.");
    digitalWrite(RED_LED, HIGH);  // LED rouge allumée si échec
    digitalWrite(BLUE_LED, LOW);
    while (1); // Boucle infinie en cas d'erreur
  }

  delay(10);
  bno.setExtCrystalUse(true);   // Utilisation du cristal externe pour meilleure précision
  digitalWrite(GREEN_LED, HIGH); // LED verte allumée quand tout est OK
  digitalWrite(BLUE_LED, LOW);
}

void loop(void) {
  // Récupération des différentes mesures du capteur BNO055
  sensors_event_t orientationData, linearAccelData, accelData, gyroData, magData;
  bno.getEvent(&orientationData, Adafruit_BNO055::VECTOR_EULER);        // Orientation
  bno.getEvent(&linearAccelData, Adafruit_BNO055::VECTOR_LINEARACCEL); // Accélération linéaire
  bno.getEvent(&accelData, Adafruit_BNO055::VECTOR_ACCELEROMETER);     // Accélération brute
  bno.getEvent(&gyroData, Adafruit_BNO055::VECTOR_GYROSCOPE);          // Vitesse angulaire
  bno.getEvent(&magData, Adafruit_BNO055::VECTOR_MAGNETOMETER);        // Champ magnétique

  imu::Quaternion quat = bno.getQuat(); // Récupération du quaternion (orientation complète)
  int8_t temp = bno.getTemp();          // Température interne du capteur

  // Mesure des distances par ultrasons
  long distance1 = mesureDistance(trigPin1, echoPin1);
  long distance2 = mesureDistance(trigPin2, echoPin2);

  // Envoi des données au format lisible (chaque ligne commence par un identifiant)
  Serial.print("O: "); // Orientation
  Serial.print(orientationData.orientation.x); Serial.print(", ");
  Serial.print(orientationData.orientation.y); Serial.print(", ");
  Serial.println(orientationData.orientation.z);

  Serial.print("L: "); // Accélération linéaire
  Serial.print(linearAccelData.acceleration.x); Serial.print(", ");
  Serial.print(linearAccelData.acceleration.y); Serial.print(", ");
  Serial.println(linearAccelData.acceleration.z);

  Serial.print("A: "); // Accélération brute
  Serial.print(accelData.acceleration.x); Serial.print(", ");
  Serial.print(accelData.acceleration.y); Serial.print(", ");
  Serial.println(accelData.acceleration.z);

  Serial.print("G: "); // Gyroscope
  Serial.print(gyroData.gyro.x); Serial.print(", ");
  Serial.print(gyroData.gyro.y); Serial.print(", ");
  Serial.println(gyroData.gyro.z);

  Serial.print("M: "); // Magnétomètre
  Serial.print(magData.magnetic.x); Serial.print(", ");
  Serial.print(magData.magnetic.y); Serial.print(", ");
  Serial.println(magData.magnetic.z);

  Serial.print("Q: "); // Quaternion
  Serial.print(quat.w(), 4); Serial.print(", ");
  Serial.print(quat.x(), 4); Serial.print(", ");
  Serial.print(quat.y(), 4); Serial.print(", ");
  Serial.println(quat.z(), 4);

  Serial.print("T: "); // Température
  Serial.println(temp);

  Serial.print("D1: "); // Distance capteur 1
  Serial.println(distance1);

  Serial.print("D2: "); // Distance capteur 2
  Serial.println(distance2);

  Serial.println("---"); // Séparateur pour lecture facile

  delay(100); // Pause pour éviter une surcharge de la liaison série
}

// Fonction pour mesurer la distance via capteur ultrason
long mesureDistance(int trig, int echo) {
  digitalWrite(trig, LOW);
  delayMicroseconds(2);
  digitalWrite(trig, HIGH);          // Envoi d’une impulsion de 10 µs
  delayMicroseconds(10);
  digitalWrite(trig, LOW);

  long duration = pulseIn(echo, HIGH, 30000); // Mesure du temps de retour, timeout à 30 ms
  long distance = (duration / 2) / 29.1;      // Conversion en cm
  return constrain(distance, 0, 200);         // Limite la distance entre 0 et 200 cm
}
