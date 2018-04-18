#include <AccelStepper.h>


// vars
AccelStepper stepper1; // Defaults to AccelStepper::FULL4WIRE (4 pins) on 2, 3, 4, 5


void setup() {
  stepper1.setMaxSpeed(500.0);
  stepper1.setSpeed(220.0);
}

void loop() {
  stepper1.runSpeed();  
}
