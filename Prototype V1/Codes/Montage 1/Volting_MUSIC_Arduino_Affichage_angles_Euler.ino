#include <Wire.h>  // Bibliothèque pour la communication I2C
#include <Adafruit_Sensor.h>  // Bibliothèque de base pour les capteurs Adafruit
#include <Adafruit_BNO055.h>  // Bibliothèque spécifique pour le capteur BNO055
#include <utility/imumaths.h>  // Bibliothèque pour les calculs mathématiques liés à l'IMU

// Création d'un objet 'bno' pour interagir avec le capteur BNO055
Adafruit_BNO055 bno = Adafruit_BNO055(55);

void setup(void)
{
  Serial.begin(9600);  // Démarrage de la communication série à 9600 bauds
  Serial.println("Test du capteur d'orientation");

  /* Initialise le capteur BNO055 */
  if(!bno.begin())
  {
    /* S'il y a un problème pour détecter le BNO055 (mauvais câblage ou adresse I2C), afficher un message d'erreur */
    Serial.print("Oups, pas de BNO055 détecté ... Vérifiez votre câblage ou l'ADDR I2C !");
    while(1);  // Boucle infinie pour bloquer l'exécution en cas d'erreur
  }

  delay(1000);  // Pause d'une seconde pour laisser le capteur se stabiliser

  bno.setExtCrystalUse(true);  // Utiliser un cristal externe pour améliorer la précision du capteur (si disponible)
}

void loop(void)
{
  /* Récupère un nouvel événement de mesure du capteur */
  sensors_event_t event;
  bno.getEvent(&event);

  /* Affiche les données d'orientation (X, Y, Z) en virgule flottante */
  Serial.print("X: ");
  Serial.print(event.orientation.x, 4);  // Affiche l'angle autour de l'axe X avec 4 décimales
  Serial.print("\tY: ");
  Serial.print(event.orientation.y, 4);  // Affiche l'angle autour de l'axe Y avec 4 décimales
  Serial.print("\tZ: ");
  Serial.print(event.orientation.z, 4);  // Affiche l'angle autour de l'axe Z avec 4 décimales
  Serial.println("");

  delay(100);  // Attend 100 millisecondes avant de recommencer (10 mesures par seconde)
}