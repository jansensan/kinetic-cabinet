#include <AccelStepper.h>


// vars
AccelStepper motor01; // Defaults to AccelStepper::FULL4WIRE (4 pins) on 2, 3, 4, 5
AccelStepper motor02(AccelStepper::FULL4WIRE, 6, 7, 8, 9);
AccelStepper motor03(AccelStepper::FULL4WIRE, 10, 11, 12, 13);
AccelStepper motor04(AccelStepper::FULL4WIRE, 14, 15, 16, 17);
AccelStepper motor05(AccelStepper::FULL4WIRE, 18, 19, 20, 21);
AccelStepper motor06(AccelStepper::FULL4WIRE, 22, 23, 24, 25);
AccelStepper motor07(AccelStepper::FULL4WIRE, 26, 27, 28, 29);
AccelStepper motor08(AccelStepper::FULL4WIRE, 30, 31, 32, 33);
AccelStepper motor09(AccelStepper::FULL4WIRE, 34, 35, 36, 37);
AccelStepper motor10(AccelStepper::FULL4WIRE, 38, 39, 40, 41);
AccelStepper motor11(AccelStepper::FULL4WIRE, 42, 43, 44, 45);
AccelStepper motor12(AccelStepper::FULL4WIRE, 46, 47, 48, 49);


// constants
const float MAX_MOTOR_SPEED = 500.0;


// arduino methods
void setup() {
  // set max speed for motors
  initMotorsSpeed();

  // set speed
  motor01.setSpeed(110.0);
  motor02.setSpeed(220.0);
  motor03.setSpeed(440.0);
}

void loop() {
  motor01.runSpeed();
  motor02.runSpeed();
  motor03.runSpeed();
}


// methods definitions
void initMotorsSpeed() {
  // set max speed for motors
  motor01.setMaxSpeed(MAX_MOTOR_SPEED);
  motor02.setMaxSpeed(MAX_MOTOR_SPEED);
  motor03.setMaxSpeed(MAX_MOTOR_SPEED);
  motor04.setMaxSpeed(MAX_MOTOR_SPEED);
  motor05.setMaxSpeed(MAX_MOTOR_SPEED);
  motor06.setMaxSpeed(MAX_MOTOR_SPEED);
  motor07.setMaxSpeed(MAX_MOTOR_SPEED);
  motor08.setMaxSpeed(MAX_MOTOR_SPEED);
  motor09.setMaxSpeed(MAX_MOTOR_SPEED);
  motor10.setMaxSpeed(MAX_MOTOR_SPEED);
  motor11.setMaxSpeed(MAX_MOTOR_SPEED);
  motor12.setMaxSpeed(MAX_MOTOR_SPEED);
}
