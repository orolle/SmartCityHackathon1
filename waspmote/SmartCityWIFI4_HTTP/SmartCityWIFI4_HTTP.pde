/*
 *  -------- Waspmote - Plug & Sense! - Code Generator ------------ 
 *
 *  Code generated with Waspmote Plug & Sense! Code Generator. 
 *  This code is intended to be used only with Waspmote Plug & Sense!
 *  series (encapsulated line) and is not valid for Waspmote. Use only
 *  with Waspmote Plug & Sense! IDE (do not confuse with Waspmote IDE).
 *
 *  Copyright (C) 2012 Libelium Comunicaciones Distribuidas S.L.
 *  http://www.libelium.com
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 * 
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 * 
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 *  Version:		0.1
 *  Generated:		18/01/2014
 *
 */

// Step 1. Includes of the Sensor Board and Communications modules used
#define DEBUG_WIFI
//#define DEBUG


#include <WaspSensorCities.h>

#include <WaspGPS.h>

#include <WaspWIFI.h>

// #include <HMAC_SHA256.h>

// Step 2. Variables declaration

long sequenceNumber = 0;

char data[256];
char cLength[32];

float connectorAFloatValue;       
float connectorBFloatValue;      
float connectorCFloatValue;          
float connectorDFloatValue;      
float connectorEFloatValue;
float connectorFFloatValue;

int connectorAIntValue;
int connectorBIntValue;
int connectorCIntValue;
int connectorDIntValue;
int connectorEIntValue;
int connectorFIntValue;

char  connectorAString[10];       
char  connectorBString[10];      
char  connectorCString[10];
char  connectorDString[10];
char  connectorEString[10];
char  connectorFString[10];

int accelerometerX;
int accelerometerY;
int accelerometerZ;

char accelerometerXString[10];
char accelerometerYString[10];
char accelerometerZString[10];

bool  gpsStatus;
char lon[12];
char lat[12];
char alt[21];

int   batteryLevel;
char  batteryLevelString[10];
char sleepTime[12]; //TEST!!!!!!!!!!!

//#define gateway "192.168.30.254"
#define mask "255.255.255.0"
#define ESSID "SmartCityHackathon"

#define key "20326494"
#define ip "192.168.0.201"

//00:06:66:55:58:26

#define HTTP_IP "192.168.0.101"
#define HTTP_PORT 8080

#define UPDATE_CYCLE 6*60 // Minuten Anzahl = alle 6h

unsigned long nodeID;
#define SENSOR_TYPE "SMARTCITY:WIFI"

#define GPS_UPDATE_CYCLE 200 //TODO: Anzahl pro Tag!!!!

#define CONNECTOR_A "distance" // ultrasound distance
#define CONNECTOR_B "humidity"       
#define CONNECTOR_C "luminosity"
#define CONNECTOR_D "noise"
#define CONNECTOR_E "CE"
#define CONNECTOR_F "CF"

#define  ACC_X "AX"
#define  ACC_Y "AY"
#define  ACC_Z "AZ"

#define gpsLatitude "GLA"
#define gpsLongitude "GLO"
#define gpsAltitude "GAL"

#define BATTERY "BAT"
#define TIME_STAMP "TS"

#define KEY_LEN 20

void setup() 
{ 
  // 1. Check if the program has been programmed successfully
  Utils.checkNewProgram();

  nodeID = Utils.readSerialID();
  // Step 3. Communication module initialization

  // Step 4. Communication module to ON

  // Switches on the module
  WIFI.ON(SOCKET0);
  WIFI.resetValues();

  // Step 5. Initial message composition
#ifdef DEBUG
  Utils.setExternalLED(LED_ON);
  USB.ON();
  USB.println("Init!");
#endif

  sprintf(sleepTime,"00:00:00:10");      
}

void sendHTTP(char *post) {
  // Step 13. Communication module to ON
  // Switches on the module
  WIFI.ON(SOCKET0);

  // 1. Configure the transport protocol (UDP, TCP, FTP, HTTP...)
  WIFI.setConnectionOptions(CLIENT);
  // 2. Configure the way the modules will resolve the IP address.
  //WIFI.setDHCPoptions(DHCP_ON);
  WIFI.setDHCPoptions(DHCP_ON);

  //WIFI.setGW(gateway);
  //WIFI.setNetmask(mask);
  //WIFI.setIp(ip);;

  // 3. Configure how to connect the AP.
  WIFI.setJoinMode(MANUAL);
  // 3.1 Sets Mixed WPA1 & WPA2-PSK encryptation // 1-64 Character 
  //WIFI.setAuthKey(WPAMIX, key);

  WIFI.setAuthKey(WPAMIX, key); 
  WIFI.setJoinTime(10000);

  WIFI.storeData();

  if (WIFI.join(ESSID))
  {
    USB.println("WLAN Connected!");

    if (WIFI.setTCPclient(HTTP_IP,HTTP_PORT,2000))
    { 
      snprintf(cLength, sizeof(cLength), "Content-Length: %d\r\n\r\n", strlen(data));
      // 5. Send TCP data.
      //WIFI.send("\r\n");
      WIFI.send("POST /index.html HTTP/1.1\r\n");
      WIFI.send("Content-Type: application/json\r\n");
      WIFI.send(cLength);
      WIFI.send(post);
      WIFI.close();
    } 
    else {
      USB.println("HTTP fail");
    }
  } 
  else {
#ifdef DEBUG
    USB.println("Not connected!");
#endif
  }

  // Step 15. Communication module to OFF
  // Closes the UDP and enters in command mode.
  //WIFI.close();
  // Switches off the module
  WIFI.OFF();
  delay(100);
}
 

void loop() {    

  // First dummy reading for analog-to-digital converter channel selection
  PWR.getBatteryLevel();
  // Getting Battery Level
  batteryLevel = PWR.getBatteryLevel();
  // Conversion into a string
  itoa(batteryLevel, batteryLevelString, 10);

  if(batteryLevel>90) {
    sprintf(sleepTime,"00:00:00:10");      
  } 
  else if (batteryLevel>70) {
    sprintf(sleepTime,"00:00:00:10");      
  } 
  else if (batteryLevel>50) {
    sprintf(sleepTime,"00:00:00:10");      
  }  
  else if (batteryLevel>30) {
    sprintf(sleepTime,"00:00:00:10");      
  }  
  else if (batteryLevel<30) {
    sprintf(sleepTime,"00:00:00:10");      
  } 

#ifdef DEBUG
  //Utils.blinkLEDs(1000);
  USB.print("Battery level: ");
  USB.println(batteryLevel);
  USB.print("Timer set: ");
  USB.println(sleepTime);
#endif

  // Step 8. Turn on the Sensor Board
  //Turn on the sensor board
  SensorCities.ON();
  //Turn on the RTC
  RTC.ON();

  //Turn on the GPS
  if(sequenceNumber % GPS_UPDATE_CYCLE == 0) {
    //GPS.ON();
    // waiting for GPS is connected to satellites (240 seconds)
    //gpsStatus = GPS.waitForSignal(240);
    //supply stabilization delay
    //delay(100);
  }

  //Turn on the accelerometer
  ACC.ON();

  // Step 9. Turn on the sensors

  SensorCities.setSensorMode(SENS_ON, SENS_CITIES_ULTRASOUND_3V3);
  delay(2000);

  SensorCities.setSensorMode(SENS_ON, SENS_CITIES_HUMIDITY);
  delay(100);

  SensorCities.setSensorMode(SENS_ON, SENS_CITIES_LDR);
  delay(100);

  SensorCities.setSensorMode(SENS_ON, SENS_CITIES_AUDIO);
  delay(2000);

  // Step 10. Read the sensors

  //Reading acceleration in X axis
  accelerometerX = ACC.getX();
  //Conversion into a string
  itoa(accelerometerX, accelerometerXString, 10);

  //Reading acceleration in Y axis
  accelerometerY = ACC.getY();
  //Conversion into a string
  itoa(accelerometerY, accelerometerYString, 10);

  //Reading acceleration in Z axis
  accelerometerZ = ACC.getZ();
  //Conversion into a string
  itoa(accelerometerZ, accelerometerZString, 10);


  if(sequenceNumber % GPS_UPDATE_CYCLE == 0) {    
    GPS.getPosition();
    GPS.setTimeFromGPS();
    Utils.float2String(GPS.convert2Degrees(GPS.longitude, GPS.EW_indicator), lon, 7);
    Utils.float2String(GPS.convert2Degrees(GPS.latitude,GPS.NS_indicator), lat, 7);
    Utils.float2String(GPS.convert2Degrees(GPS.latitude,GPS.NS_indicator), lat, 7);

    sprintf(alt,"%s",(strlen(GPS.altitude)>0 ? GPS.altitude : "0.0"));
  }


  //First dummy reading for analog-to-digital converter channel selection
  SensorCities.readValue(SENS_CITIES_ULTRASOUND_3V3, SENS_US_WRA1);
  //Sensor temperature reading
  connectorAFloatValue = SensorCities.readValue(SENS_CITIES_ULTRASOUND_3V3, SENS_US_WRA1);
  //Conversion into a string
  Utils.float2String(connectorAFloatValue, connectorAString, 2);

  //First dummy reading for analog-to-digital converter channel selection
  SensorCities.readValue(SENS_CITIES_HUMIDITY);
  //Sensor temperature reading
  connectorBFloatValue = SensorCities.readValue(SENS_CITIES_HUMIDITY);
  //Conversion into a string
  Utils.float2String(connectorBFloatValue, connectorBString, 2);

  //First dummy reading for analog-to-digital converter channel selection
  SensorCities.readValue(SENS_CITIES_LDR);
  //Sensor temperature reading
  connectorCFloatValue = SensorCities.readValue(SENS_CITIES_LDR);
  //Conversion into a string
  Utils.float2String(connectorCFloatValue, connectorCString, 2);

  //First dummy reading for analog-to-digital converter channel selection
  SensorCities.readValue(SENS_CITIES_AUDIO);
  //Sensor temperature reading
  connectorDFloatValue = SensorCities.readValue(SENS_CITIES_AUDIO);
  //Conversion into a string
  Utils.float2String(connectorDFloatValue, connectorDString, 2);

  // Step 11. Turn off the sensors

  SensorCities.setSensorMode(SENS_OFF, SENS_CITIES_ULTRASOUND_3V3);

  SensorCities.setSensorMode(SENS_OFF, SENS_CITIES_HUMIDITY);

  SensorCities.setSensorMode(SENS_OFF, SENS_CITIES_LDR);

  SensorCities.setSensorMode(SENS_OFF, SENS_CITIES_AUDIO);

  SensorCities.setSensorMode(SENS_OFF, SENS_CITIES_DUST);

  // Step 12. Message composition

  //Data payload composition
  sprintf(data,"{\"I\":\"%0lX\",\"T\":\"%s\",\"N\":%li,\"%s\":%s,\"%s\":%s,\"%s\":%s,\"%s\":%s,\"%s\":%s,\"%s\":%s,\"%s\":%s,\"%s\":\"%s\",\"%s\":%s,\"%s\":%s,\"%s\":%s,\"%s\":%s}",
  nodeID, SENSOR_TYPE,
  sequenceNumber,
  ACC_X, accelerometerXString,
  ACC_Y, accelerometerYString,
  ACC_Z , accelerometerZString,
  gpsLatitude, lat,
  gpsLongitude, lon,
  gpsAltitude, alt,
  BATTERY, batteryLevelString,
  TIME_STAMP, RTC.getTimestamp(),
  CONNECTOR_A , connectorAString,
  CONNECTOR_B , connectorBString,
  CONNECTOR_C , connectorCString,
  CONNECTOR_D , connectorDString);

  //sprintf(data,"GET$/index.html?json={}");
#ifdef DEBUG
  Utils.setExternalLED(LED_ON);
  USB.ON();
  USB.println(data);
#endif

  sendHTTP(data);

  // Step 16. Entering Sleep Mode
  USB.print("Timer set: ");
  USB.println(sleepTime);
  PWR.deepSleep(sleepTime,RTC_OFFSET,RTC_ALM1_MODE1,ALL_OFF);
  //Increase the sequence number after wake up

  sequenceNumber++;
}

