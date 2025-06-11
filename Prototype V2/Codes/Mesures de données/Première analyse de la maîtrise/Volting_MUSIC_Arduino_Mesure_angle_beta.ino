// --- Définition des broches pour le capteur ultrason ---
const int trigPin = 6;
const int echoPin = 7;

void setup() {
  // Initialisation de la communication série
  Serial.begin(115200);

  // Configuration des broches
  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT);
}

void loop() {
  // Envoi d'une impulsion de 10 µs sur le pin trig
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);

  // Lecture de la durée de l'écho (en microsecondes)
  long duration = pulseIn(echoPin, HIGH);

  // Conversion de la durée en distance (cm)
  float distance = (duration / 2.0) / 29.1;

  // Affichage pour le Serial Plotter
  Serial.print("Distance:");
  Serial.println(distance);

  delay(50); // Délai entre deux mesures
}