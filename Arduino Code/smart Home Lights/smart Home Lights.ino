#include <DHT.h>
#include <SPI.h>
#include <MFRC522.h>
#include <ESP8266WiFi.h>
#include <ESP8266HTTPClient.h>
#include <ArduinoJson.h>
#include <Servo.h>
#include <UniversalTelegramBot.h>
#include <WiFiClientSecure.h>
#include <String.h>

#define BOT_TOKEN ""
#define CHAT_ID ""

#define DHTPIN D4     // Pin where the DHT11 sensor is connected
#define DHTTYPE DHT11 // DHT11 sensor type
#define ServoMotorPin D3
const char *ssid = "";     // Enter your Wi-Fi network SSID
const char *password = ""; // Enter your Wi-Fi network password

const char *server = "192.168.252.32"; // Enter the IP address or domain name of the server
const int port = 8000;                 // Enter the port number of the server

const int lightPin = D0;

const int fanPin = D8;
Servo doorServo;
int pos = 0;
const int HomeNumber = 1; // Enter HomeNumber
bool firstTime = true;
float preferdTemp = 0;
DHT dht(DHTPIN, DHTTYPE);
#define RST_PIN D1
#define SS_PIN D2
MFRC522 rfid(SS_PIN, RST_PIN);
float previousTemperature = 0.0;
float previousHumidity = 0.0;

X509List cert(TELEGRAM_CERTIFICATE_ROOT);
WiFiClientSecure secured_client;
UniversalTelegramBot bot(BOT_TOKEN, secured_client);

// Use @myidbot (IDBot) to find out the chat ID of an individual or a group
// Also note that you need to click "start" on a bot before it can
// message you
int wrongAttemptCounter = 0;
void OpenDoor()
{
  for (pos = 0; pos <= 90; pos += 1)
  { // goes from 0 degrees to 90 degrees
    // in steps of 1 degree
    doorServo.write(pos); // tell servo to go to position in variable 'pos'
    delay(15);            // waits 15ms for the servo to reach the position
  }
  for (pos = 90; pos >= 0; pos -= 1)
  {                       // goes from 90 degrees to 0 degrees
    doorServo.write(pos); // tell servo to go to position in variable 'pos'
    delay(15);            // waits 15ms for the servo to reach the position
  }
  pos = 0;
}

void UpdateServer(WiFiClient client, String temp, String himidity, bool fan_status)
{

  HTTPClient http;
  String payload = "";
  String api = "http://" + String(server) + ":" + String(port) + "/smarthome/updatefromArduino/" + String(HomeNumber) + "?timestamp=" + String(millis());
  ;

  DynamicJsonDocument doc(1024);
  doc["temp"] = temp;
  doc["humudity"] = himidity;
  doc["fan_status"] = fan_status;

  // Serialize the JSON payload

  serializeJson(doc, payload);

  http.begin(client, api);
  http.addHeader("Content-Type", "application/json");

  int httpCode = http.PUT(payload);
  String response = http.getString();
  Serial.println(response);
  DynamicJsonDocument json(1024);
  DeserializationError error = deserializeJson(json, response);
  if (error)
  {
    Serial.print("deserializeJson() failed: ");
    Serial.println(error.c_str());
  }

  http.end();
}

bool getRequest(WiFiClient client, String api, String cardNumber, String homeId)
{
  HTTPClient http;
  String payload = "";
  api = "http://" + String(server) + ":" + String(port) + "/smarthome/openDoor/?timestamp=" + String(millis());
  ;

  DynamicJsonDocument doc(1024);
  doc["cardNumber"] = cardNumber;
  doc["homeId"] = homeId;

  // Serialize the JSON payload

  serializeJson(doc, payload);

  http.begin(client, api);
  http.addHeader("Content-Type", "application/json");

  int httpCode = http.POST(payload);
  String response = http.getString();
  Serial.println(response);
  DynamicJsonDocument json(1024);
  DeserializationError error = deserializeJson(json, response);
  if (error)
  {
    Serial.print("deserializeJson() failed: ");
    Serial.println(error.c_str());
    return false;
  }
  bool status = json["open"];
  Serial.println("Status of " + status);

  http.end();
  return status;
}

String ReadCode()
{
  String code = "";
  if (!rfid.PICC_IsNewCardPresent())
    return "-1";
  if (!rfid.PICC_ReadCardSerial())
    return "-1";
  for (byte i = 0; i < rfid.uid.size; i++)
  {
    code += String(rfid.uid.uidByte[i], HEX);
  }
  return code;
}
void setup()
{
  // Set the pin as an output
  Serial.begin(9600); // Start serial communication

  WiFi.begin(ssid, password);
  secured_client.setTrustAnchors(&cert); // Connect to Wi-Fi network
  Serial.print("Connecting to ");
  Serial.println(ssid);

  while (WiFi.status() != WL_CONNECTED)
  {
    delay(1000);
    Serial.print(".");
  }
  pinMode(lightPin, OUTPUT);
  pinMode(fanPin, OUTPUT); // Set the pin as an output

  dht.begin();
  SPI.begin();
  rfid.PCD_Init();
  doorServo.attach(ServoMotorPin);
  Serial.println("");
  Serial.println("Wi-Fi connected");

  Serial.print("Retrieving time: ");
  configTime(0, 0, "pool.ntp.org"); // get UTC time via NTP
  time_t now = time(nullptr);
  while (now < 24 * 3600)
  {
    Serial.print(".");
    delay(100);
    now = time(nullptr);
  }
  Serial.println(now);
  bool sendMessage = bot.sendSimpleMessage(CHAT_ID, "You will recive Notification about your home on this channel", "");
}

void loop()
{
  WiFiClient client;
  HTTPClient http;
  bool light_status;
  bool fan_status;
  float temperature;
  float humidity;
  float Temp_temperature;
  float Temp_humidity;

  bool doorStatus;
  // Send an HTTP GET request to the server
  String url = "http://" + String(server) + ":" + String(port) + "/smarthome/homeinfo/" + String(HomeNumber) + "?timestamp=" + String(millis());
  ;
  Serial.println(url);

  http.begin(client, url);
  int httpCode = http.GET();

  if (httpCode == HTTP_CODE_OK)
  {
    String response = http.getString();
    // Serial.println(response);
    //  Parse the JSON response
    DynamicJsonDocument doc(512);
    deserializeJson(doc, response);

    light_status = doc["light_status"];
    fan_status = doc["fan_status"];
    String desiredTemp = doc["desiredTemp"];
    preferdTemp = atof(desiredTemp.c_str());
    Serial.print("Led --");
    Serial.println(light_status);

    Serial.print("Fan --");
    Serial.println(fan_status);

    // Switch the light on or off based on the light value
    if (light_status)
    {
      digitalWrite(lightPin, HIGH);
    }
    else
    {
      digitalWrite(lightPin, LOW);
    }

    if (fan_status)
    {
      digitalWrite(fanPin, HIGH);
    }
    else
    {
      digitalWrite(fanPin, LOW);
    }
  }
  else
  {
    Serial.print("HTTP error code: ");
    Serial.println(httpCode);
  }

  http.end();

  // This one is about the temp and humidity sensor

  temperature = dht.readTemperature();
  humidity = dht.readHumidity();

  if (isnan(temperature) || isnan(humidity))
  {
    Serial.println("Failed to read from DHT sensor");
    return;
  }

  char temp[10];
  char himidity[10];
  dtostrf(temperature, 6, 2, temp);
  dtostrf(humidity, 6, 2, himidity);

  if (previousHumidity != humidity || previousTemperature != temperature)
  {

    // Update the previous values
    previousTemperature = temperature;
    previousHumidity = humidity;
    UpdateServer(client, temp, himidity, fan_status);

    delay(1000);
  }

  String code = ReadCode();
  // Serial.println(" code for card" + code);
  if (code != "-1")
  {
    // If the tag is detected
    Serial.println(code);
    // Serial.println();
    // send a get request
    doorStatus = getRequest(client, server, code, "2");
    Serial.println(doorStatus);

    if (doorStatus)
    {
      OpenDoor();
      wrongAttemptCounter = 0;
      Serial.println("auto ");
      Serial.println(preferdTemp);
      Serial.println(temperature);
      if (preferdTemp < temperature)
      {

        digitalWrite(fanPin, HIGH);
        fan_status = true;
        UpdateServer(client, temp, himidity, fan_status);

        delay(1000);
      }
    }
    else
    {

      wrongAttemptCounter = wrongAttemptCounter + 1;
      if (wrongAttemptCounter >= 2)
      {
        bool sendMessage = bot.sendSimpleMessage(CHAT_ID, "Alert! some one is trying to enter your home with invalid card", "");
        wrongAttemptCounter = 0;
      }

      Serial.println("Use valid Keys - number of ");
      Serial.println(CHAT_ID);
      Serial.println(wrongAttemptCounter);
      delay(1000);
    }
  }

  delay(1000);
}
