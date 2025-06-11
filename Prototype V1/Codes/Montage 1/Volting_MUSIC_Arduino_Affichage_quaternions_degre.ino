#include <Wire.h>
#include <Adafruit_Sensor.h>
#include <Adafruit_BNO055.h>
#include <utility/imumaths.h>

Adafruit_BNO055 bno = Adafruit_BNO055(55);

void setup() {
  Serial.begin(9600);
  if (!bno.begin()) {
    Serial.println("Erreur : BNO055 non détecté !");
    while (1);
  }
  delay(1000);
  bno.setExtCrystalUse(true);
}

void loop() {
  // Récupération du quaternion brut du capteur
  imu::Quaternion quat = bno.getQuat();

  // Conversion en angles d’Euler dans le bon ordre
  float qw = quat.w();
  float qx = quat.x();
  float qy = quat.y();
  float qz = quat.z();

  // Formules standard de conversion quaternion → roll/pitch/yaw
  float roll  = atan2(2.0 * (qw * qx + qy * qz),
                      1.0 - 2.0 * (qx * qx + qy * qy));
  float pitch = asin(2.0 * (qw * qy - qz * qx));
  float yaw   = atan2(2.0 * (qw * qz + qx * qy),
                      1.0 - 2.0 * (qy * qy + qz * qz));

  // Conversion en degrés
  roll  *= 180.0 / PI;
  pitch *= 180.0 / PI;
  yaw   *= 180.0 / PI;

  // Affichage
  Serial.print("Rotation autour de X (Roll): ");
  Serial.print(roll);
  Serial.print(" | Y (Pitch): ");
  Serial.print(pitch);
  Serial.print(" | Z (Yaw): ");
  Serial.println(yaw);

  delay(100);
}