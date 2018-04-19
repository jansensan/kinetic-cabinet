import gab.opencv.*;

import processing.core.*;
import processing.opengl.PGraphics2D;

import processing.serial.*;

// import processing.video.Capture;
import gohai.glvideo.*;


// constants
boolean IS_PROD = false;
boolean IS_VERBOSE = false;
boolean IS_ARDUINO_CONNECTED = true;
boolean IS_PI = true;

int ARDUINO_PORT_INDEX = 0;
int ARDUINO_PORT_NUMBER = 9600;

int CAM_WIDTH = 320;
int CAM_HEIGHT = 240;

int LABEL_SIZE = 24;

// as viewed from the front of the cabinet
float[][] VIEW_ZONES = {
  {0.000, 0.060}, // small
  {0.061, 0.146}, // medium
  {0.147, 0.256}, // big
  {0.257, 0.342}, // medium
  {0.343, 0.452}, // big
  {0.453, 0.512}, // small
  {0.513, 0.598}, // medium
  {0.599, 0.708}, // big
  {0.709, 0.794}, // medium
  {0.795, 0.854}, // small
  {0.855, 0.940}, // medium
  {0.941, 1.000}  // small
};


// vars
OpenCV cv;
//Capture video;
GLCapture video;

Gear smallGear1;
Gear smallGear2;
Gear smallGear3;
Gear smallGear4;

Gear mediumGear1;
Gear mediumGear2;
Gear mediumGear3;
Gear mediumGear4;
Gear mediumGear5;

Gear bigGear1;
Gear bigGear2;
Gear bigGear3;

float maxLeftFlow = 0;
float maxRightFlow = 0;

Serial arduinoPort;
String arduinoPortName;


// processing setup
void settings() {
  int sketchWidth;
  
  if (IS_PROD) {
    sketchWidth = CAM_WIDTH;
  } else {
    sketchWidth = CAM_WIDTH * 2;
  }
  
  size(sketchWidth, CAM_HEIGHT, P2D);
}

void setup() {
  createAllGears();
  
  // open cv
  cv = new OpenCV(this, CAM_WIDTH, CAM_HEIGHT);

  // init video capture
  //video = new Capture(this, CAM_WIDTH, CAM_HEIGHT, 30);
  video = new GLCapture(this);
  video.start();

  background(0);
  frameRate(30);
  
  initArduinoSerial();
}

void draw() {
  // clear previous frame
  background(0);

  // read video
  if (video.available()) {
    video.read();
  }

  // display on screen
  image(video, 0, 0, width, height);

  // capture snapshot
  PImage screenshot = new PImage(width, height);
  loadPixels();
  int pixelIndex = -1;
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      pixelIndex++;
      screenshot.set(j, i, pixels[pixelIndex]);
    }
  }

  if (screenshot.width <= 0 || screenshot.height <= 0) {
    println("Screenshot dimensions are empty. (" + millis() + ")");
    return;
  }

  // update Optical Flow
  cv.loadImage(screenshot);
  cv.calculateOpticalFlow();
 
  // calculate flow per gear view zone
  updateBigGearFlow(bigGear1);
  updateBigGearFlow(bigGear2);
  updateBigGearFlow(bigGear3);

  // display result
  background(0);

  // debugging drawings
  if (!IS_PROD) {
    // draw optical flow
    stroke(255);
    cv.drawOpticalFlow();

    // copy from currentFrame
    copyViewZone(screenshot, bigGear1);
    copyViewZone(screenshot, bigGear2);
    copyViewZone(screenshot, bigGear3);

    // draw camera views
    drawViewZone(bigGear1);
    drawViewZone(bigGear2);
    drawViewZone(bigGear3);

    // draw directions labels and blocks
    if (bigGear1.isRotating) {
      drawDirectionBlock(bigGear1);
      drawDirectionLabel(bigGear1);
    }
    if (bigGear2.isRotating) {
      drawDirectionBlock(bigGear2);
      drawDirectionLabel(bigGear2);
    }
    if (bigGear3.isRotating) {
      drawDirectionBlock(bigGear3);
      drawDirectionLabel(bigGear3);
    }
  }
  
  bigGear1.update();
  bigGear2.update();
  bigGear3.update();
}


// methods definitions
void initArduinoSerial() {
  if (!IS_ARDUINO_CONNECTED) {
    return;
  }
  
  printArray(Serial.list());

  arduinoPortName = Serial.list()[ARDUINO_PORT_INDEX];
  println("port name: " + arduinoPortName + ", index: " + ARDUINO_PORT_INDEX);

  arduinoPort = new Serial(this, arduinoPortName, ARDUINO_PORT_NUMBER);
}

Gear createGearData(int id, int type) {
  Gear gear = new Gear(this, id);
  gear.type = type;
  gear.init(VIEW_ZONES[gear.id], CAM_WIDTH, CAM_HEIGHT);
  return gear;
}

void createAllGears() {
  // declare gear data
  smallGear1 = createGearData(1, 1);
  mediumGear1 = createGearData(2, 2);
  bigGear1 = createGearData(3, 3);
  mediumGear2 = createGearData(4, 2);

  bigGear2 = createGearData(5, 3);
  smallGear2 = createGearData(6, 1);
  mediumGear3 = createGearData(7, 2);
  bigGear3 = createGearData(8, 3);
  
  mediumGear4 = createGearData(9, 2);
  smallGear3 = createGearData(10, 1);
  mediumGear5 = createGearData(11, 2);
  smallGear4 = createGearData(12, 1);
  
  
  // assign surrounding gears (linked list)
  smallGear1.next = mediumGear1;
  
  mediumGear1.previous = smallGear1;
  mediumGear1.next = bigGear1;
  
  bigGear1.previous = mediumGear1;
  bigGear1.next = mediumGear2;
  
  mediumGear2.previous = bigGear1;
  mediumGear2.next = bigGear2;
  
  bigGear2.previous = mediumGear2;
  bigGear2.next = smallGear2;
  
  smallGear2.previous = bigGear2;
  smallGear2.next = mediumGear3;
  
  mediumGear3.previous = smallGear2;
  mediumGear3.next = bigGear3;
  
  bigGear3.previous = mediumGear3;
  bigGear3.next = mediumGear4;
  
  mediumGear4.previous = bigGear3;
  mediumGear4.next = smallGear3;
  
  smallGear3.previous = mediumGear4;
  smallGear3.next = mediumGear5;
  
  mediumGear5.previous = smallGear3;
  mediumGear5.next = smallGear4;
  
  smallGear4.previous = mediumGear5;
}

void copyViewZone(PImage src, Gear gear) {
  // error handling
  if (gear.viewZone == null) {
    printWarning(
      "copyViewZone",
      "viewZone null for gear with id " + gear.id
    );
    return;
  }
  
  for (int i = 0; i < CAM_HEIGHT; i++) {
    for (int j = 0; j < gear.viewZone.w; j++) {
      gear.view.set(j, i, src.get(j + gear.viewZone.x, i));
    }
  }
}

void drawDirectionBlock(Gear gear) {
  // set color according to direction
  color c = color(0, 0, 0, 0);
  float flow = gear.getAverageFlow();
  if (flow > 0) {
    c = color(200, 0, 0, 200);
  } else if (flow < 0) {
    c = color(0, 0, 200, 200);
  }

  // draw rect to sketch
  int labelLeftPadding = (IS_PROD) ? 0 : CAM_WIDTH;
  fill(c);
  noStroke();
  rect(
    labelLeftPadding + gear.viewZone.x, 0,
    gear.viewZone.w, gear.viewZone.w
  );
}

void drawDirectionLabel(Gear gear) {
  // set label according to direction
  String label = "";
  float flow = gear.getAverageFlow();
  if (flow > 0) {
    label = "right";
  } else if (flow < 0) {
    label = "left";
  }

  // draw label to sketch
  int labelLeftPadding = (IS_PROD) ? 0 : CAM_WIDTH;
  fill(255);
  textSize(LABEL_SIZE);
  text(label, labelLeftPadding + gear.viewZone.x, 24);
}

void drawViewZone(Gear gear) {
  // error handling
  if (gear.viewZone == null) {
    printWarning(
      "drawViewZone",
      "viewZone null for gear with id " + gear.id
    );
    return;
  }
  
  int imageX = (IS_PROD) ? gear.viewZone.x : CAM_WIDTH + gear.viewZone.x;
  image(
    gear.view,
    imageX, 0,
    gear.viewZone.w, CAM_HEIGHT
  );
}

String getPayloadString(Gear gear) {
  // creates a string "[id],[impulseRatio]"
  String payload = gear.id + "," + gear.getImpulseRatio();
  println("payload:");
  println(payload);
  return payload;
}

void triggerMotor(Gear gear) {
  printMethodName("triggerMotor");

  if (arduinoPort == null) {
    printWarning(
      "triggerMotorRotation",
      "port for Arduino is not defined."
    );
    return;
  }
  
  String payload = getPayloadString(gear);
  arduinoPort.write(payload);
}

void updateBigGearFlow(Gear gear) {
  PVector flowInRegion = cv.getAverageFlowInRegion(
    gear.viewZone.x, gear.viewZone.y, 
    gear.viewZone.w, gear.viewZone.h
  );
  gear.updateFlow(flowInRegion.x);
  gear.trigger();
}


// utils
void printMethodName(String methodName) {
  if (IS_VERBOSE) {
    println("\n--- KineticCabinet." + methodName + "()");
  }
}

void printWarning(String methodName, String message) {
  if (IS_VERBOSE) {
    println("\nWarning at KineticCabinet#" + methodName + "():" + message);
  }
}

String toString() {
  return "KineticCabinet []";
}