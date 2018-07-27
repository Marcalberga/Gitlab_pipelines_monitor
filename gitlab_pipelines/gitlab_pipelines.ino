
char receivedValue;
int successPin = 13;
int runningPin = 9;
int redPin = 8;
int buzzer = 3;
int rgb1 = 5;
int rgb2 = 9;
int rgb3 = 10;
bool runningMode, intermitentFlag = false;

void setup() {
  pinMode(successPin, OUTPUT);
  pinMode(runningPin, OUTPUT);
  pinMode(redPin, OUTPUT);
  pinMode(buzzer, OUTPUT);

  Serial.begin(9600);
}

void loop() {
  if (Serial.available()) {
    receivedValue = Serial.read();
    Serial.print(receivedValue);
  } 
  switch (receivedValue) {
    case '0':
      runningMode = false;
      digitalWrite(successPin, HIGH);
      digitalWrite(runningPin, LOW);
      digitalWrite(redPin, LOW);
      break;
    case '1':
      runningMode = true;
      digitalWrite(runningPin, HIGH);
      digitalWrite(successPin, LOW);
      digitalWrite(redPin, LOW);
      break;
    case '2':
      runningMode = false;
      digitalWrite(redPin, HIGH);
      analogWrite(successPin, LOW);
      digitalWrite(runningPin, LOW);
      tone(buzzer, 1000);
      delay(500);
      noTone(buzzer);
      break;
    default:
      if (runningMode) {
        if (intermitentFlag) {
          digitalWrite(runningPin, LOW);
          intermitentFlag = false;
        } else {
          digitalWrite(runningPin, HIGH);
          intermitentFlag = true;
        }
      }
  }

  delay(100);

}
