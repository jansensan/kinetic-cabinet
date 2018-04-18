#include <AccelStepper.h>
#include "Gear.h"


// constants
const int PORT_NUMBER = 9600;
const float MAX_MOTOR_SPEED = 440.0;
const float MIN_MOTOR_SPEED = 220.0;
const float MOTOR_SPEED_DIFF = 220.0;


// vars
Gear gear01(1);
Gear gear02(2);
Gear gear03(3);
Gear gear04(4);
Gear gear05(5);
Gear gear06(6);
Gear gear07(7);
Gear gear08(8);
Gear gear09(9);
Gear gear10(10);
Gear gear11(11);
Gear gear12(12);

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
      triggerGear01(rotationRatio);
      break;
  }
  
  // update gears
  gear01.update();

  // run motors accordingly
  if (gear01.isTriggered) {
    motor01.runSpeed();
  }

  delay(10);
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

  // set speed for motors
  motor01.setSpeed(MIN_MOTOR_SPEED);
  motor02.setSpeed(MIN_MOTOR_SPEED);
  motor03.setSpeed(MIN_MOTOR_SPEED);
  motor04.setSpeed(MIN_MOTOR_SPEED);
  motor05.setSpeed(MIN_MOTOR_SPEED);
  motor06.setSpeed(MIN_MOTOR_SPEED);
  motor07.setSpeed(MIN_MOTOR_SPEED);
  motor08.setSpeed(MIN_MOTOR_SPEED);
  motor09.setSpeed(MIN_MOTOR_SPEED);
  motor10.setSpeed(MIN_MOTOR_SPEED);
  motor11.setSpeed(MIN_MOTOR_SPEED);
  motor12.setSpeed(MIN_MOTOR_SPEED);
}

// FIXME: for some ridiculous and unknown reason,
// cannot use arrays to get motors and gears
void triggerGear01(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor01.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor01.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear01.trigger();
}

void triggerGear02(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor02.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor02.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear02.trigger();
}

void triggerGear03(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor03.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor03.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear03.trigger();
}

void triggerGear04(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor04.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor04.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear04.trigger();
}

void triggerGear05(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor05.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor05.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear05.trigger();
}

void triggerGear06(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor06.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor06.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear06.trigger();
}

void triggerGear07(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor07.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor07.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear07.trigger();
}

void triggerGear08(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor08.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor08.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear08.trigger();
}

void triggerGear09(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor09.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor09.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear09.trigger();
}

void triggerGear10(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor10.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor10.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear10.trigger();
}

void triggerGear11(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor11.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor11.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear11.trigger();
}

void triggerGear12(float rotationRatio) {
  // set speed and direction
  if (rotationRatio > 0) {
    motor12.setSpeed(MIN_MOTOR_SPEED);
  } else {
    motor12.setSpeed(MIN_MOTOR_SPEED * -1);
  }

  gear12.trigger();
}
