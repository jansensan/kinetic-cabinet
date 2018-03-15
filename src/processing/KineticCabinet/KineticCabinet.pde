import gab.opencv.*;

import processing.core.*;
import processing.opengl.PGraphics2D;
import processing.video.Capture;


// constants
boolean IS_PROD = false;
boolean IS_VERBOSE = false;

int CAM_WIDTH = 320;
int CAM_HEIGHT = 240;

int LABEL_SIZE = 12;

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
PImage screenshot;

OpenCV cv;
Capture video;

Gear bigGear1;
Gear bigGear2;
Gear bigGear3;

float maxLeftFlow = 0;
float maxRightFlow = 0;


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
  // declare gear data
  bigGear1 = new Gear(2);
  bigGear1.type = 3;
  bigGear1.init(VIEW_ZONES[bigGear1.id], CAM_WIDTH, CAM_HEIGHT);

  bigGear2 = new Gear(4);
  bigGear2.type = 3;
  bigGear2.init(VIEW_ZONES[bigGear2.id], CAM_WIDTH, CAM_HEIGHT);

  bigGear3 = new Gear(7);
  bigGear3.type = 3;
  bigGear3.init(VIEW_ZONES[bigGear3.id], CAM_WIDTH, CAM_HEIGHT);

  // open cv
  cv = new OpenCV(this, CAM_WIDTH, CAM_HEIGHT);

  // init video capture
  video = new Capture(this, CAM_WIDTH, CAM_HEIGHT, 30);
  video.start();
  
  screenshot = new PImage(CAM_WIDTH, CAM_HEIGHT);

  background(0);
  frameRate(30);
}

void draw() {
  background(0);

  // update Optical Flow
  cv.loadImage(video);
  cv.calculateOpticalFlow();
 
  // calculate flow per gear view zone
  updateBigGearFlow(bigGear1);
  updateBigGearFlow(bigGear2);
  updateBigGearFlow(bigGear3);
  
  // display result
  background(0);
  if (!IS_PROD) {
    // draw optical flow
    stroke(255, 160, 160);
    cv.drawOpticalFlow();

    // save screenshot to image
    captureScreenshot(); 

    // copy from currentFrame
    copyViewZone(screenshot, bigGear1);
    copyViewZone(screenshot, bigGear2);
    copyViewZone(screenshot, bigGear3);
  
    // draw camera views
    drawViewZone(bigGear1);
    drawViewZone(bigGear2);
    drawViewZone(bigGear3);
    
    // draw directions labels
    if (bigGear1.isTriggered) {
      drawDirectionLabel(bigGear1);
    }
    if (bigGear2.isTriggered) {
      drawDirectionLabel(bigGear2);
    }
    if (bigGear3.isTriggered) {
      drawDirectionLabel(bigGear3);
    }
  }
  
  bigGear1.update();
  bigGear2.update();
  bigGear3.update();
}


// methods definitions
void captureScreenshot() {
  loadPixels();
  int pixelIndex = -1;
  for (int i = 0; i < CAM_HEIGHT; i++) {
    for (int j = 0; j < CAM_WIDTH; j++) {
      pixelIndex++;
      screenshot.set(j, i, pixels[pixelIndex]);
    }
    if (!IS_PROD) pixelIndex += CAM_WIDTH;
  }
}

void copyViewZone(PImage src, Gear gear) {
  // error handling
  if (gear.viewZone == null) {
    if (IS_VERBOSE) println("Warning at KineticCabinet#copyViewZone: viewZone null for gear with id " + gear.id); 
    return;
  }
  
  for (int i = 0; i < CAM_HEIGHT; i++) {
    for (int j = 0; j < gear.viewZone.w; j++) {
      gear.view.set(j, i, src.get(j + gear.viewZone.x, i));
    }
  }
}

void drawDirectionLabel(Gear gear) {
  String label = "";
  float flow = gear.getAverageFlow();
  if (flow > 0) {
    label = "right";
  } else if (flow < 0) {
    label = "left";
  }
  
  int labelLeftPadding = (IS_PROD) ? 0 : CAM_WIDTH;
  textSize(LABEL_SIZE);
  text(label, labelLeftPadding + gear.viewZone.x, 24);
}

void drawViewZone(Gear gear) {
  // error handling
  if (gear.viewZone == null) {
    if (IS_VERBOSE) println("Warning at KineticCabinet#drawViewZone: viewZone null for gear with id " + gear.id); 
    return;
  }
  
  int imageX = (IS_PROD) ? gear.viewZone.x : CAM_WIDTH + gear.viewZone.x;
  image(
    gear.view,
    imageX, 0,
    gear.viewZone.w, CAM_HEIGHT
  );
}

void updateBigGearFlow(Gear gear) {
  PVector flowInRegion = cv.getAverageFlowInRegion(
    gear.viewZone.x, gear.viewZone.y, 
    gear.viewZone.w, gear.viewZone.h
  );
  gear.updateFlow(flowInRegion.x);
  gear.analyzeIfTriggered();
}


// events
void captureEvent(Capture video) {
  video.read();
}