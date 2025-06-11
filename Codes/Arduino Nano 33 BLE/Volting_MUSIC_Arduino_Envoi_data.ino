#include <SoftwareSerial.h>
#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>

#define rxPin 0   // RX du HC-05 sur D0
#define txPin 1  // TX du HC-05 sur D11

#define trigPin1 6   // Trig du premier capteur ultrason sur D6
#define echoPin1 7   // Echo du premier capteur ultrason sur D7
#define trigPin2 9   // Trig du deuxième capteur ultrason sur D9
#define echoPin2 8   // Echo du deuxième capteur ultrason sur D8

SoftwareSerial mySerial(rxPin, txPin);  // Communication série avec HC-05

Adafruit_BNO055 bno = Adafruit_BNO055(55, 0x28);  // Adresse de l'IMU BNO-055

void setup() {
  // Initialisation des capteurs et de la communication série
  Serial.begin(9600);
  mySerial.begin(9600);

  // Initialisation de l'IMU BNO-055
  if (!bno.begin()) {
    Serial.println("Impossible de détecter le capteur BNO055.");
    while (1);
  }

  // Initialisation des pins des capteurs à ultrasons
  pinMode(trigPin1, OUTPUT);
  pinMode(echoPin1, INPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(echoPin2, INPUT);
}

long getDistance(int trigPin, int echoPin) {
  // Envoie d'une impulsion pour mesurer la distance avec un capteur ultrason
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  long duration = pulseIn(echoPin, HIGH);
  long distance = duration * 0.034 / 2;  // Calcul de la distance en cm
  return distance;
}

void loop() {
  // Mesure des distances des capteurs à ultrasons
  long distance1 = getDistance(trigPin1, echoPin1);
  long distance2 = getDistance(trigPin2, echoPin2);

  // Lecture des angles de rotation de l'IMU BNO-055
  sensors_event_t event;
  bno.getEvent(&event);

  float roll = event.orientation.x;   // Angle de roulis (Roll)
  float pitch = event.orientation.y;  // Angle de tangage (Pitch)
  float yaw = event.orientation.z;    // Angle de lacet (Yaw)

  // Formatage des données pour l'envoi via Bluetooth
  String data = String(distance1+distance2) + "," +
                String(roll) + "," + String(yaw);

  // Envoi des données via Bluetooth
  mySerial.println(data);
  Serial.println(data);

  delay(10);  // Délai pour la prochaine lecture
}