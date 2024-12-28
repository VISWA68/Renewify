#include <WiFi.h>
#include <FirebaseESP32.h>

// WiFi credentials
#define FIREBASE_HOST "https://solar-panel-211c6-default-rtdb.asia-southeast1.firebasedatabase.app/"
#define FIREBASE_AUTH "AIzaSyAg-sw9I-0YEN4rZmiXeWv5jbFar28MLPo"

// WiFi credentials
#define WIFI_SSID "Karthi's Galaxy A23 5G"
#define WIFI_PASSWORD "Karthi800@"

// Firebase objects
FirebaseData firebaseData;
FirebaseAuth auth;
FirebaseConfig config;

const int RelayPin = 13; // Use GPIO 13 for ESP32 relay pin

void setup() {
  // Initialize serial communication
  Serial.begin(115200);

  // Set relay pin as output
  pinMode(RelayPin, OUTPUT);

  // Connect to WiFi
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to WiFi");
  while (WiFi.status() != WL_CONNECTED) {
    delay(1000);
    Serial.print(".");
  }
  Serial.println("\nConnected to WiFi");

  // Set up Firebase configuration
  config.host = FIREBASE_HOST;
  config.signer.tokens.legacy_token = FIREBASE_AUTH;

  // Start Firebase
  Firebase.begin(&config, &auth);
  Firebase.reconnectWiFi(true);
  Serial.println("Connected to Firebase");
}

void loop() {
  // Read analog values
  int solarPanel1Voltage = analogRead(34); // GPIO 34 for analog input
  int solarPanel1Current = analogRead(35); // GPIO 35 for analog input
  int solarPanel2Voltage = analogRead(32); // GPIO 32 for analog input
  int solarPanel2Current = analogRead(33); // GPIO 33 for analog input
  int batteryVoltage = analogRead(39);    // GPIO 36 for analog input
  int batteryCurrent = analogRead(36);    // GPIO 39 for analog input

  // Convert analog readings to actual values
  float solarPanel1VoltageVal = (solarPanel1Voltage / 4095.0) * 25.0;
  float solarPanel1CurrentVal = ((solarPanel1Current / 4095.0) * 5.0) - 2.5;
  solarPanel1CurrentVal = abs(solarPanel1CurrentVal);
  float solarPanel2VoltageVal = (solarPanel2Voltage / 4095.0) * 25.0;
  float solarPanel2CurrentVal = ((solarPanel2Current / 4095.0) * 5.0) - 2.5;
  solarPanel2CurrentVal = abs(solarPanel2CurrentVal);
  float batteryVoltageVal = ((batteryVoltage / 4095.0) * 10.0)+3;
  float batteryCurrentVal = ((batteryCurrent / 4095.0) * 5.0) - 2.5;
  batteryCurrentVal = abs(batteryCurrentVal);

  // Calculate battery percentage
  float batteryPercentage = ((batteryVoltageVal - 3.3) / (4.2 - 3.3)) * 100;
  if (batteryPercentage > 100) batteryPercentage = 100;
  if (batteryPercentage < 0) batteryPercentage = 0;

  // Relay control based on battery percentage
  if (batteryPercentage <= 80) {
    digitalWrite(RelayPin, HIGH);
  }
  if (batteryPercentage >= 100) {
    digitalWrite(RelayPin, LOW);
  }

  // Send data to Firebase
  bool success = true;

  success &= Firebase.setFloat(firebaseData, "solar_battery_data/solar_panel_1/voltage", solarPanel1VoltageVal);
  success &= Firebase.setFloat(firebaseData, "solar_battery_data/solar_panel_1/current", solarPanel1CurrentVal);
  success &= Firebase.setFloat(firebaseData, "solar_battery_data/solar_panel_2/voltage", solarPanel2VoltageVal);
  success &= Firebase.setFloat(firebaseData, "solar_battery_data/solar_panel_2/current", solarPanel2CurrentVal);
  success &= Firebase.setFloat(firebaseData, "solar_battery_data/battery/voltage", batteryVoltageVal);
  success &= Firebase.setFloat(firebaseData, "solar_battery_data/battery/current", batteryCurrentVal);
  success &= Firebase.setFloat(firebaseData, "solar_battery_data/battery/percentage", batteryPercentage);

  if (success) {
    Serial.println("Data sent successfully");
  } else {
    Serial.print("Error sending data: ");
    Serial.println(firebaseData.errorReason());
  }

  delay(1000); // Wait for a second before sending the next set of values
}
