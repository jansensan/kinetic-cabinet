#include <AccelStepper.h>


const int NUM_MOTORS = 12;
const float MAX_MOTOR_SPEED = 440.0;
const float MIN_MOTOR_SPEED = 220.0;

const int CYCLE_DURATION = 375;
const int MIN_PAUSE_DURATION = 1000;
const int MAX_PAUSE_DURATION = 10 * 1000;


// vars
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

int cycleEndTime = -1;
int pauseEndTime = -1;
int currentMotor = 1;
int rotationDirection = 1;

boolean isPaused = false;
boolean isCycling = true;


void setup() {
  // set max speed
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

  // set running speed
  setMotorSpeeds();

  startCycle();
}

void loop() {
  if (isCycling) {
    switch (currentMotor) {
      case 1:
        motor01.runSpeed();
        break;
      case 2:
        motor02.runSpeed();
        break;
      case 3:
        motor03.runSpeed();
        break;
      case 4:
        motor04.runSpeed();
        break;
      case 5:
        motor05.runSpeed();
        break;
      case 6:
        motor06.runSpeed();
        break;
      case 7:
        motor07.runSpeed();
        break;
      case 8:
        motor08.runSpeed();
        break;
      case 9:
        motor09.runSpeed();
        break;
      case 10:
        motor10.runSpeed();
        break;
      case 11:
        motor11.runSpeed();
        break;
      case 12:
        motor12.runSpeed();
        break;
    }

    endCycle();
  }

  if (isPaused) {
    endPause();
  }
}


// methods definitions
int getRandomSpeed() {
  rotationDirection *= -1;
  return rotationDirection * random(MIN_MOTOR_SPEED, MAX_MOTOR_SPEED);
}

void setMotorSpeeds() {
  motor01.setSpeed(getRandomSpeed());
  motor02.setSpeed(getRandomSpeed());
  motor03.setSpeed(getRandomSpeed());
  motor04.setSpeed(getRandomSpeed());
  motor05.setSpeed(getRandomSpeed());
  motor06.setSpeed(getRandomSpeed());
  motor07.setSpeed(getRandomSpeed());
  motor08.setSpeed(getRandomSpeed());
  motor09.setSpeed(getRandomSpeed());
  motor10.setSpeed(getRandomSpeed());
  motor11.setSpeed(getRandomSpeed());
  motor12.setSpeed(getRandomSpeed());
}

void startCycle() {
  cycleEndTime = millis() + CYCLE_DURATION;
  currentMotor = random(1, 12);
  setMotorSpeeds();
  isCycling = true;
}

void endCycle() {
  if (isCycling && millis() >= cycleEndTime) {
    isCycling = false;
    startPause();
  }
}

void startPause() {
  pauseEndTime = millis() + int(random(MIN_PAUSE_DURATION, MAX_PAUSE_DURATION));
  isPaused = true;
}

void endPause() {
  if (isPaused && millis() >= pauseEndTime) {
    isPaused = false;
    startCycle();
  }
}


