// change this to 1 to output messages to LCD instead of serial
#define USE_LCD 0

#if USE_LCD
#include "C12832.h"

// the actual pins are defined in mbed_app.json and can be overridden per target
C12832 lcd(LCD_MOSI, LCD_SCK, LCD_MISO, LCD_A0, LCD_NCS);

#define logMessage lcd.cls();lcd.printf

#else

#define logMessage printf

#endif

#define MQTTCLIENT_QOS2 1

#include "easy-connect.h"
#include "MQTTNetwork.h"
#include "MQTTmbed.h"
#include "MQTTClient.h"
#include "LM75B.h"

LM75B sensor(p28,p27);

int arrivedcount = 0;

void messageArrived(MQTT::MessageData& md)
{
    MQTT::Message &message = md.message;
    logMessage("Message arrived: qos %d, retained %d, dup %d, packetid %d\r\n", message.qos, message.retained, message.dup, message.id);
    logMessage("Payload %.*s\r\n", message.payloadlen, (char*)message.payload);
    ++arrivedcount;
}

int main(int argc, char* argv[])
{
    float version = 0.6;
    char* topic = "iot/thijs/temp";

    logMessage("HelloMQTT: version is %.2f\r\n", version);

    NetworkInterface* network = easy_connect(true);
    if (!network) {
        return -1;
    }

    MQTTNetwork mqttNetwork(network);

    MQTT::Client<MQTTNetwork, Countdown> client(mqttNetwork);

    const char* hostname = "labict.be";
    int port = 1883;
    logMessage("Connecting to %s:%d\r\n", hostname, port);
    int rc = mqttNetwork.connect(hostname, port);
    if (rc != 0)
        logMessage("rc from TCP connect is %d\r\n", rc);

    MQTTPacket_connectData data = MQTTPacket_connectData_initializer;
    data.MQTTVersion = 3;
    data.clientID.cstring = "thijsid";
    if ((rc = client.connect(data)) != 0)
        logMessage("rc from MQTT connect is %d\r\n", rc);

    if ((rc = client.subscribe(topic, MQTT::QOS2, messageArrived)) != 0)
        logMessage("rc from MQTT subscribe is %d\r\n", rc);

    MQTT::Message message;
    
    if (sensor.open()) {
        while(true){
            char buf[100];
            sprintf(buf, "%.3f\n", (float)sensor.temp());
            message.qos = MQTT::QOS0;
            message.retained = false;
            message.dup = false;
            message.payload = (void*)buf;
            message.payloadlen = strlen(buf)+1;
            rc = client.publish(topic, message);
            client.yield(20);
            wait_ms(3000);
        }
    }

    return 0;
    
}
