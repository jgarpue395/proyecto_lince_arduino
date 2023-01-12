#include <stdio.h>
#include <string.h>
 
#define DEBUG true
#define MODE_1A
 
#define DTR_PIN 9
#define RI_PIN 8
 
#define LTE_PWRKEY_PIN 5
#define LTE_RESET_PIN 6
#define LTE_FLIGHT_PIN 7
 
void setup()
{
  SerialUSB.begin(115200);
  //while (!SerialUSB)
  {
      ; // wait for Arduino serial Monitor port to connect
  }

  delay(100);

  Serial1.begin(115200);

  //Serial1.begin(UART_BAUD, SERIAL_8N1, MODEM_RXD, MODEM_TXD);

  pinMode(LTE_RESET_PIN, OUTPUT);
  digitalWrite(LTE_RESET_PIN, LOW);

  pinMode(LTE_PWRKEY_PIN, OUTPUT);
  digitalWrite(LTE_RESET_PIN, LOW);
  delay(100);
  digitalWrite(LTE_PWRKEY_PIN, HIGH);
  delay(2000);
  digitalWrite(LTE_PWRKEY_PIN, LOW);

  pinMode(LTE_FLIGHT_PIN, OUTPUT);
  digitalWrite(LTE_FLIGHT_PIN, LOW); //Normal Mode
  // digitalWrite(LTE_FLIGHT_PIN, HIGH);//Flight Mode

  SerialUSB.println("Maduino Zero 4G Test Start!");

  sendData("AT+CGMM", 3000, DEBUG);

  sendData("AT+CGPS=1", 1000, false);

  sendData("AT+HTTPINIT", 1000, DEBUG);
}
 
void loop()
{
  String velocidadIntantanea = (String) random(1,100);
  String velocidadMedia = (String) random(1,100);
  String tiempoCarrera = (String) random(1,100);
  String numVueltas = (String) random(1,100);
  String coordenadas = sendData("AT+CGPSINFO",1000, DEBUG);
  String coordenadasUrl = "No disponible";

  if (coordenadas != NULL)
  {
    coordenadas = coordenadas.substring((coordenadas.indexOf("+CGPSINFO: ") + 11));
    String coordenadasString = "";

    int index = -1;
    int i = 0;

    while (i < 4 && (index = coordenadas.indexOf(',')) != -1) {
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

  String url = "https://script.google.com/macros/s/AKfycbyJ32Qpile501OtKuFFEvrvTIcDUM-y2S7a3MxSwUgpisN0zzsU5ymMcVUOJbbJInzBFQ/exec?";

  if (coordenadasUrl.equals(",,,"))
  {
    coordenadasUrl = "NoDisponible";
  }

  String parametros = "velocidadInstantanea=" + velocidadIntantanea + "&velocidadMedia=" + velocidadMedia + "&tiempoCarrera=" + tiempoCarrera + "&numVueltas=" + numVueltas + "&coordenadas=" + coordenadasUrl;
  
  if (sendData("AT+HTTPPARA=\"URL\",\"" + url + parametros + "\"", 1000, DEBUG).indexOf("OK") != -1)
  {
    sendData("AT+HTTPACTION=1", 1000, DEBUG);
  }

  delay(1000);
}

String sendData(String command, const int timeout, boolean debug)
{
    String response = "";
    if (command.equals("1A") || command.equals("1a"))
    {
        SerialUSB.println();
        SerialUSB.println("Get a 1A, input a 0x1A");
 
        //Serial1.write(0x1A);
        Serial1.write(26);
        Serial1.println();
        return "";
    }
    else
    {
        Serial1.println(command);
    }
 
    long int time = millis();
    while ((time + timeout) > millis())
    {
        while (Serial1.available())
        {
            char c = Serial1.read();
            response += c;
        }
    }
    if (debug)
    {
        SerialUSB.print(response);
    }
    return response;
}