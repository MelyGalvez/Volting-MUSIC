#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

Adafruit_BNO055 bno = Adafruit_BNO055(55);

// LEDs
const int BLUE_LED = 10;
const int GREEN_LED = 11;
const int RED_LED = 12;

// Capteurs ultrason
const int trigPin1 = 6;
const int echoPin1 = 7;
const int trigPin2 = 9;
const int echoPin2 = 8;

void setup(void) {
  Serial.begin(115200);

  pinMode(BLUE_LED, OUTPUT);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(RED_LED, OUTPUT);
  digitalWrite(BLUE_LED, HIGH);

  pinMode(trigPin1, OUTPUT);
  pinMode(echoPin1, INPUT);
  pinMode(trigPin2, OUTPUT);
  pinMode(echoPin2, INPUT);

  if (!bno.begin()) {
    Serial.println("Erreur capteur BNO055 non détecté.");
    digitalWrite(RED_LED, HIGH);
    digitalWrite(BLUE_LED, LOW);
    while (1);
  }

  delay(10);
  bno.setExtCrystalUse(true);
  digitalWrite(GREEN_LED, HIGH);
  digitalWrite(BLUE_LED, LOW);
}

void loop(void) {
  // Orientation (Euler angles)
  sensors_event_t orientationData, linearAccelData, accelData, gyroData, magData;
  bno.getEvent(&orientationData, Adafruit_BNO055::VECTOR_EULER);
  bno.getEvent(&linearAccelData, Adafruit_BNO055::VECTOR_LINEARACCEL);
  bno.getEvent(&accelData, Adafruit_BNO055::VECTOR_ACCELEROMETER);
  bno.getEvent(&gyroData, Adafruit_BNO055::VECTOR_GYROSCOPE);
  bno.getEvent(&magData, Adafruit_BNO055::VECTOR_MAGNETOMETER);

  imu::Quaternion quat = bno.getQuat();
  int8_t temp = bno.getTemp();

  // Capteurs ultrason
  long distance1 = mesureDistance(trigPin1, echoPin1);
  long distance2 = mesureDistance(trigPin2, echoPin2);

  // Envoi des données sur une ligne JSON-friendly
  Serial.print("O: ");
  Serial.print(orientationData.orientation.x); Serial.print(", ");
  Serial.print(orientationData.orientation.y); Serial.print(", ");
  Serial.println(orientationData.orientation.z);

  Serial.print("L: ");
  Serial.print(linearAccelData.acceleration.x); Serial.print(", ");
  Serial.print(linearAccelData.acceleration.y); Serial.print(", ");
  Serial.println(linearAccelData.acceleration.z);

  Serial.print("A: ");
  Serial.print(accelData.acceleration.x); Serial.print(", ");
  Serial.print(accelData.acceleration.y); Serial.print(", ");
  Serial.println(accelData.acceleration.z);

  Serial.print("G: ");
  Serial.print(gyroData.gyro.x); Serial.print(", ");
  Serial.print(gyroData.gyro.y); Serial.print(", ");
  Serial.println(gyroData.gyro.z);

  Serial.print("M: ");
  Serial.print(magData.magnetic.x); Serial.print(", ");
  Serial.print(magData.magnetic.y); Serial.print(", ");
  Serial.println(magData.magnetic.z);

  Serial.print("Q: ");
  Serial.print(quat.w(), 4); Serial.print(", ");
  Serial.print(quat.x(), 4); Serial.print(", ");
  Serial.print(quat.y(), 4); Serial.print(", ");
  Serial.println(quat.z(), 4);

  Serial.print("T: ");
  Serial.println(temp);

  Serial.print("D1: ");
  Serial.println(distance1);

  Serial.print("D2: ");
  Serial.println(distance2);

  Serial.println("---"); // Séparateur de trames

  delay(100); // pour éviter de saturer la liaison série
}

long mesureDistance(int trig, int echo) {
  digitalWrite(trig, LOW);
  delayMicroseconds(2);
  digitalWrite(trig, HIGH);
  delayMicroseconds(10);
  digitalWrite(trig, LOW);

  long duration = pulseIn(echo, HIGH, 30000); // Timeout de 30 ms
  long distance = (duration / 2) / 29.1;
  return constrain(distance, 0, 200);
}
