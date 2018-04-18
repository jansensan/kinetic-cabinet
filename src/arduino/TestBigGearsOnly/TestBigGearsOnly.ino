#include <AccelStepper.h>


// vars
//AccelStepper motor01; // Defaults to pins 2, 3, 4, 5           // small
//AccelStepper motor02(AccelStepper::FULL4WIRE, 6, 7, 8, 9);     // medium
AccelStepper motor03(AccelStepper::FULL4WIRE, 10, 11, 12, 13); // big
//AccelStepper motor04(AccelStepper::FULL4WIRE, 14, 15, 16, 17); // medium
AccelStepper motor05(AccelStepper::FULL4WIRE, 18, 19, 20, 21); // big
//AccelStepper motor06(AccelStepper::FULL4WIRE, 22, 23, 24, 25); // small
//AccelStepper motor07(AccelStepper::FULL4WIRE, 26, 27, 28, 29); // medium
AccelStepper motor08(AccelStepper::FULL4WIRE, 30, 31, 32, 33); // big
//AccelStepper motor09(AccelStepper::FULL4WIRE, 34, 35, 36, 37); // medium
//AccelStepper motor10(AccelStepper::FULL4WIRE, 38, 39, 40, 41); // small
//AccelStepper motor11(AccelStepper::FULL4WIRE, 42, 43, 44, 45); // medium
//AccelStepper motor12(AccelStepper::FULL4WIRE, 46, 47, 48, 49); // small


void setup() {
  // set max speed
  motor03.setMaxSpeed(500.0);
  motor05.setMaxSpeed(500.0);
  motor08.setMaxSpeed(500.0);

  // set running speed
  motor03.setSpeed(220.0);
  motor05.setSpeed(220.0);
  motor08.setSpeed(220.0);
}

void loop() {
  motor03.runSpeed();
  motor05.runSpeed();
  motor08.runSpeed();
}
