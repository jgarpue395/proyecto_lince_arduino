#include <stdio.h>
#include <string.h>
 
#define DEBUG true
#define MODE_1A
 
#define DTR_PIN 9
#define RI_PIN 8
 
#define LTE_PWRKEY_PIN 5
#define LTE_RESET_PIN 6
#define LTE_FLIGHT_PIN 7

#define HALLPin 19             //Sensor HALL conectado al Pin A5 (pin19)
#define longitudCircuito 1.600 //longitud media NOGARO 2022       //longitud del CIRCUITO en Kmetros
#define long_rueda 0.001534    //longitud de la rueda en KM
 
//parámetros calculados a partir del DIAMETRO
const float rueda = 3.6 * long_rueda * 1000000 * 1000;   

//VARIABLES GLOBALES
unsigned long n, t0, t; 
// n: número de vueltas de la rueda
// t0: tiempo en micros de encendido de arduino
// t: tiempo de la vuelta anterior

void setup()
{
  SerialUSB.begin(115200);
  Serial1.begin(115200);

  pinMode(LTE_RESET_PIN, OUTPUT);
  digitalWrite(LTE_RESET_PIN, LOW);

  pinMode(LTE_PWRKEY_PIN, OUTPUT);
  digitalWrite(LTE_RESET_PIN, LOW);
  digitalWrite(LTE_PWRKEY_PIN, HIGH);

  delay(2000);
  
  digitalWrite(LTE_PWRKEY_PIN, LOW);

  pinMode(LTE_FLIGHT_PIN, OUTPUT);
  digitalWrite(LTE_FLIGHT_PIN, LOW); //Normal Mode

  boolean inicio = HIGH;   //mientras INICIO=HIGH, nos mantenemos a la espera de que UN BOTON sea PULSADO

  pinMode(HALLPin, INPUT);   //declara entrada SENSOR HALL

  //No iman
  while (digitalRead(HALLPin) == LOW) {
    ;
  }
  
  //Iman
  while (digitalRead(HALLPin) == HIGH) {
    ;
  }

  //guardo el tiempo en microsegundos
  t0 = micros();
  t = t0;

  SerialUSB.println("Maduino Zero 4G Test Start!");
  
  // inicializo el modulo de gps de la placa
  sendData("AT+CGPS=1", 1000, DEBUG);

  // inicializo el servicio HTTP
  sendData("AT+HTTPINIT", 1000, DEBUG);
}
 
void loop()
{
  while (digitalRead(HALLPin) == LOW) {
    ;
  }
  while (digitalRead(HALLPin) == HIGH) {
    if ((micros() - t) > 1000000) {
      ;
    }
  }

  n++;                                        // Incrementamos número de vueltas de la rueda
  long nuevoTiempoVuelta = micros();          
  long tiempoVuelta = nuevoTiempoVuelta - t;  // Calculamos tiempo empleado en la última vuelta de la rueda (en microsegundos)
  t = nuevoTiempoVuelta;                      // Guardamos en t, el valor de microsegundos actual
  
  // Lanzamos el comando que nos devuelve las coordenadas
  String coordenadas = sendData("AT+CGPSINFO", 1000, DEBUG);
  // Variable utilizada para almacenar la parte que nos sirve del comando anterior
  String coordenadasUrl = "NoDisponible";

  if (coordenadas != NULL)
  {
    // Quito la cabezera del valor devuelo por el comando de las coordenadas
    coordenadas = coordenadas.substring((coordenadas.indexOf("+CGPSINFO: ") + 11));
    // Variable para trabajar con el String de las coordenadas
    String coordenadasString = "";

    int index = -1;
    int i = 0;
    
    // Cogemos las diferentes partes de la cadena y las vamos concatenando
    while (i < 4 && (index = coordenadas.indexOf(',')) != -1)
    {
      String substring = coordenadas.substring(0, index);
      
      if (i == 0)
      {
        coordenadasString = substring;  
      }
      else
      {
        coordenadasString = coordenadasString + "," + substring;
      }

      coordenadas = coordenadas.substring(index + 1);

      i++;
    }

    coordenadasUrl = coordenadasString;
  }

  String url = "https://script.google.com/macros/s/AKfycbwLapehMP7RG2rnQ7eBS8YNpqS6GY1twPGHlSlSUGDlLU65FEijP7sEKFIfYGLW61MaVA/exec?";

  if (coordenadasUrl.equals(",,,"))
  {
    coordenadasUrl = "NoDisponible";
  }
  
  String parametros = "vueltasRueda=" + String(n) + "&tiempoInicio=" + String(t0) + "&tiempoActual=" + String(t) + "&tiempoVuelta=" + String(tiempoVuelta) + "&coordenadas=" + coordenadasUrl;
  
  if (sendData("AT+HTTPPARA=\"URL\",\"" + url + parametros + "\"", 1000, DEBUG).indexOf("OK") != -1)
  {
    sendData("AT+HTTPACTION=1", 1000, DEBUG);
  }

  delay(1000);
}

String sendData(String command, const int timeout, boolean debug)
{
  String response = "";
  if (!command.equals("1A") && !command.equals("1a"))
  {
    Serial1.println(command);
  }

  //long time = micros();
  //while ((time + timeout) > micros())
  //{
    delay(timeout);
    SerialUSB.println(micros());
    while (Serial1.available())
    {
      char c = Serial1.read();
      response += c;
    }
    SerialUSB.println(micros());
  //}

  if (debug)
  {
    SerialUSB.println(response);
  }
  
  return response;
}
