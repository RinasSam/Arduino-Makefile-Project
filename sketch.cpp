#include <Arduino.h>

void setup() {
  pinMode(8, OUTPUT);
  pinMode(13, OUTPUT);
  digitalWrite(13, LOW);
}
void loop() {
  digitalWrite(8, HIGH);
  delay(500);
  digitalWrite(8, LOW);
  delay(500);
}
