//==============================================================================
// Program:      DLP Communicator
// Reference:    
//
// DLP Communicator
// Launchpad v1.5 MSP430G2553
// P2.2 : Trigger
// P1.7 : SDA
// P1.6 : SCL
// Hardware Serial Pins @9600 N81
//
//
// Launchpad v1.5 MSP430F5529
// P3.7 : Trigger
// P3.0 : SDA
// P3.1 : SCL
// Hardware Serial Pins @9600 N81
//
//==============================================================================
// Serial parser by Pete Willard, modified by Gerard Sequeira 
// with minor edits by Kipp Bradford for use with Processing Image Capture program

#include <Wire.h>
 
//=====[ CONSTANTS ]============================================================
const int bSize = 20; 
 
//=====[ PINS ]=================================================================
int Led        = GREEN_LED;  // LED pin for debugging.   
int TriggerPin = 32;        // Pin 3.7 connects to Trigger 1/J11 on the DLP.
 
//=====[ VARIABLES ]============================================================
 
char Buffer[bSize];  // Serial buffer
char Command[10];    // Command size
char Data[15];       // Data size
int ByteCount;
 
//=====[ SUBROUTINES ]==========================================================
 
void SerialParser(void) {
//  One command per line.  Eventually, Data may have multiple 
//   fields separated by ":"
//  Command Format: "up to 5 Letter command, up to 10 letter data<\n>"
//                  No checking.
//
//  count will  be below Zero on a timeout.
//  read up to X chars or until EOT - in this case "\n" 
ByteCount = -1;
ByteCount =  Serial.readBytesUntil('\n',Buffer,bSize);  
 
if (ByteCount  > 0) {
        strcpy(Command,strtok(Buffer,":"));
                  
        strcpy(Data,strtok(NULL,":"));             
   }
memset(Buffer, 0, sizeof(Buffer));   // Clear contents of Buffer
Serial.flush();
}
 
 
//=====[ SETUP ]================================================================
void setup() 
{
    Serial.begin(9600);
    
    // Init the I2C bus. Pin 3.0 SDA and pin 3.1 SCL.
    Wire.begin(); // join i2c bus (address optional for master)

    // Initialize the LED pin as an output:
    pinMode(Led,OUTPUT);
    
    // Initialize the Trigger pin as an output:    
    pinMode(TriggerPin, OUTPUT);     
    
    // Set it low.
    digitalWrite(TriggerPin, LOW);
        
    Serial.println("MSP430 Lightcrafter Driver Setup Complete");
}
//==============================================================================
 
//=====[ LOOP ]=================================================================
void loop() {
 
    SerialParser();
   if (ByteCount  > 0) {
     if ( strcmp( Command,"run") == 0 )
     {
        Serial.println("Running patterns...");
        
        // Start running the pattern
        digitalWrite(TriggerPin, LOW);
        //delay(1);
        digitalWrite(TriggerPin, HIGH); 
        delay(250);
        digitalWrite(TriggerPin, LOW);
        digitalWrite(TriggerPin, HIGH);
        delay(250);
        digitalWrite(TriggerPin, LOW);
        digitalWrite(TriggerPin, HIGH);
        delay(250);
        digitalWrite(TriggerPin, LOW);
     }
     else if ( strcmp( Command,"next") == 0 )
     {
        Serial.println("next pattern...");
        // trigger the next pattern
        digitalWrite(Led, LOW);
        digitalWrite(TriggerPin, LOW);
        //delay(1);
        digitalWrite(TriggerPin, HIGH); 
        digitalWrite(Led, HIGH);
     }
     // Note: Whe talking to the DLP, bit 7 of the first byte needs
     // to be 1. Eg: 0x13 for reset, becomes 0x93. This is not documented in the datasheet.
     else if ( strcmp( Command,"reset") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            Wire.write(0x93);
            Wire.write(0x01);
            Wire.endTransmission();     // stop transmitting
      }
      else if ( strcmp( Command,"video") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            Wire.write(0xE9);
            Wire.write(0x01);
            Wire.endTransmission();     // stop transmitting
      }
      else if ( strcmp( Command,"pattern") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            Wire.write(0xE9);
            Wire.write(0x00);
            Wire.endTransmission();     // stop transmitting
      }
      else if ( strcmp( Command,"FlipHorizontal") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            Wire.write(0x99);
            Wire.write(0x01);
            Wire.endTransmission();     // stop transmitting
      }else if ( strcmp( Command,"FlipNormal") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            Wire.write(0x99);
            Wire.write(0x0A);
            Wire.endTransmission();     // stop transmitting
      }
     else if ( strcmp( Command,"red") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            // Red LEDs ON
            Wire.write(0x90);
            Wire.write(0x01);
            Wire.endTransmission();     // stop transmitting
      }else if ( strcmp( Command,"green") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            // Red LEDs ON
            Wire.write(0x90);
            Wire.write(0x02);
            Wire.endTransmission();     // stop transmitting
      }else if ( strcmp( Command,"blue") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            // Red LEDs ON
            Wire.write(0x90);
            Wire.write(0x04);
            Wire.endTransmission();     // stop transmitting
      }else if ( strcmp( Command,"all") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            // Red LEDs ON
            Wire.write(0x90);
            Wire.write(0x07);
            Wire.endTransmission();     // stop transmitting
      }else if ( strcmp( Command,"off") == 0 )
      {
            Wire.beginTransmission(0x1A); 
            // Red LEDs ON
            Wire.write(0x90);
            Wire.write(0x00);
            Wire.endTransmission();     // stop transmitting
      }else
  
     {
        Serial.println("Invalid command");
        Serial.print("Command     : ");
        Serial.println(Command);
        Serial.print("Data        : ");
        Serial.println(Data);
     }
     } 
}
