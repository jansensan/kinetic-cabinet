#include <AccelStepper.h>
#include "Gear.h"


// constants
const int PORT_NUMBER = 9600;
const float MAX_MOTOR_SPEED = 440.0;
const float MIN_MOTOR_SPEED = 220.0;
const float MOTOR_SPEED_DIFF = 220.0;


// vars
Gear gear01(1);

AccelStepper motor01; // Defaults to pins 2, 3, 4, 5           // small
AccelStepper motor02(AccelStepper::FULL4WIRE, 6, 7, 8, 9);     // medium
AccelStepper motor03(AccelStepper::FULL4WIRE, 10, 11, 12, 13); // big
AccelStepper motor04(AccelStepper::FULL4WIRE, 14, 15, 16, 17); // medium
AccelStepper motor05(AccelStepper::FULL4WIRE, 18, 19, 20, 21); // big
AccelStepper motor06(AccelStepper::FULL4WIRE, 22, 23, 24, 25); // small
AccelStepper motor07(AccelStepper::FULL4WIRE, 26, 27, 28, 29); // medium
AccelStepper motor08(AccelStepper::FULL4WIRE, 30, 31, 32, 33); // big
AccelStepper motor09(AccelStepper::FULL4WIRE, 34, 35, 36, 37); // medium
AccelStepper motor10(AccelStepper::FULL4WIRE, 38, 39, 40, 41); // small
AccelStepper motor11(AccelStepper::FULL4WIRE, 42, 43, 44, 45); // medium
AccelStepper motor12(AccelStepper::FULL4WIRE, 46, 47, 48, 49); // small


// arduino methods
void setup() {
  // set max speed for motors
  initMotorsSpeed();

  // demo debug
  gear01.trigger();

  // init serial communications
  Serial.begin(PORT_NUMBER);
}

void loop() {
  // read serial data
  String serialData;
  if (Serial.available()) {
    serialData = Serial.readString();
  }

  // split data
  int splitterIndex = serialData.indexOf(',');
  String gearIdStr = serialData.substring(0, splitterIndex);
  String rotationRatioStr = serialData.substring(1, splitterIndex);

  // cast data
  int gearId = gearIdStr.toInt();
  float rotationRatio = rotationRatioStr.toFloat();

  // TODO: improve with a loop?
  switch (gearId) {
    case 2:
      gear01.trigger();
      break;
  }
  
  // update gears
  gear01.update();

  // run motors accordingly
  if (gear01.isTriggered) {
    motor01.runSpeed();
  }
}


// methods definitions
void initMotorsSpeed() {
  // set max speed for motors
  motor01.setMaxSpeed(MIN_MOTOR_SPEED);
  motor02.setMaxSpeed(MIN_MOTOR_SPEED);
  motor03.setMaxSpeed(MIN_MOTOR_SPEED);
  motor04.setMaxSpeed(MIN_MOTOR_SPEED);
  motor05.setMaxSpeed(MIN_MOTOR_SPEED);
  motor06.setMaxSpeed(MIN_MOTOR_SPEED);
  motor07.setMaxSpeed(MIN_MOTOR_SPEED);
  motor08.setMaxSpeed(MIN_MOTOR_SPEED);
  motor09.setMaxSpeed(MIN_MOTOR_SPEED);
  motor10.setMaxSpeed(MIN_MOTOR_SPEED);
  motor11.setMaxSpeed(MIN_MOTOR_SPEED);
  motor12.setMaxSpeed(MIN_MOTOR_SPEED);
}
