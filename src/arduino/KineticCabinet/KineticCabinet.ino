#include <Stepper.h>
#include "Gear.h"


// constants
const int PORT_NUMBER = 9600;
const int MAX_STEPS = 200;
const int STEP_SIZE = 10;


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

Stepper motor01(MAX_STEPS, 2, 3, 4, 5);     // small
Stepper motor02(MAX_STEPS, 6, 7, 8, 9);     // medium
Stepper motor03(MAX_STEPS, 10, 11, 12, 13); // big
Stepper motor04(MAX_STEPS, 14, 15, 16, 17); // medium
Stepper motor05(MAX_STEPS, 18, 19, 20, 21); // big
Stepper motor06(MAX_STEPS, 22, 23, 24, 25); // small
Stepper motor07(MAX_STEPS, 26, 27, 28, 29); // medium
Stepper motor08(MAX_STEPS, 30, 31, 32, 33); // big
Stepper motor09(MAX_STEPS, 34, 35, 36, 37); // medium
Stepper motor10(MAX_STEPS, 38, 39, 40, 41); // small
Stepper motor11(MAX_STEPS, 42, 43, 44, 45); // medium
Stepper motor12(MAX_STEPS, 46, 47, 48, 49); // small


// arduino methods
void setup() {
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

  // FIXME: motor instances are not happy inside arrays. improve with loop somehow
  switch (gearId) {
    case 1:
      gear01.rotationRatio = rotationRatio;
      gear01.trigger();
      break;

    case 2:
      gear02.rotationRatio = rotationRatio;
      gear02.trigger();
      break;

    case 3:
      gear03.rotationRatio = rotationRatio;
      gear03.trigger();
      break;

    case 4:
      gear04.rotationRatio = rotationRatio;
      gear04.trigger();
      break;

    case 5:
      gear05.rotationRatio = rotationRatio;
      gear05.trigger();
      break;

    case 6:
      gear06.rotationRatio = rotationRatio;
      gear06.trigger();
      break;

    case 7:
      gear07.rotationRatio = rotationRatio;
      gear07.trigger();
      break;

    case 8:
      gear08.rotationRatio = rotationRatio;
      gear08.trigger();
      break;

    case 9:
      gear09.rotationRatio = rotationRatio;
      gear09.trigger();
      break;

    case 10:
      gear10.rotationRatio = rotationRatio;
      gear10.trigger();
      break;

    case 11:
      gear11.rotationRatio = rotationRatio;
      gear11.trigger();
      break;

    case 12:
      gear12.rotationRatio = rotationRatio;
      gear12.trigger();
      break;
  }
  
  // update gears
  gear01.update();
  gear02.update();
  gear03.update();
  gear04.update();
  gear05.update();
  gear06.update();
  gear07.update();
  gear08.update();
  gear09.update();
  gear10.update();
  gear11.update();
  gear12.update();

  // run motors accordingly
  runMotor01();
  runMotor02();
  runMotor03();
  runMotor04();
  runMotor05();
  runMotor06();
  runMotor07();
  runMotor08();
  runMotor09();
  runMotor10();
  runMotor11();
  runMotor12();

  delay(10);
}


// methods definitions
// FIXME: for some ridiculous and unknown reason,
// cannot use arrays to get motors and gears
void runMotor01() {
  if (gear01.isTriggered) {
    int stepSize = (gear01.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor01.step(stepSize);
  }
}

void runMotor02() {
  if (gear02.isTriggered) {
    int stepSize = (gear02.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor02.step(stepSize);
  }
}

void runMotor03() {
  if (gear03.isTriggered) {
    int stepSize = (gear03.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor03.step(stepSize);
  }
}

void runMotor04() {
  if (gear04.isTriggered) {
    int stepSize = (gear04.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor04.step(stepSize);
  }
}

void runMotor05() {
  if (gear05.isTriggered) {
    int stepSize = (gear05.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor05.step(stepSize);
  }
}

void runMotor06() {
  if (gear06.isTriggered) {
    int stepSize = (gear06.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor06.step(stepSize);
  }
}

void runMotor07() {
  if (gear07.isTriggered) {
    int stepSize = (gear07.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor07.step(stepSize);
  }
}

void runMotor08() {
  if (gear08.isTriggered) {
    int stepSize = (gear08.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor08.step(stepSize);
  }
}

void runMotor09() {
  if (gear09.isTriggered) {
    int stepSize = (gear09.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor09.step(stepSize);
  }
}

void runMotor10() {
  if (gear10.isTriggered) {
    int stepSize = (gear10.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor10.step(stepSize);
  }
}

void runMotor11() {
  if (gear11.isTriggered) {
    int stepSize = (gear11.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor11.step(stepSize);
  }
}

void runMotor12() {
  if (gear12.isTriggered) {
    int stepSize = (gear12.rotationRatio > 0) ? STEP_SIZE : -STEP_SIZE;
    motor12.step(stepSize);
  }
}

