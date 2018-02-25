import gab.opencv.*;
import processing.video.*;


int CAM_WIDTH = 640;
int CAM_HEIGHT = 480;

float MOTION_TRIGGER_THRESHOLD = 0.75;

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

int SMALL_GEAR_VIEW_WIDTH = floor(CAM_WIDTH * (VIEW_ZONES[0][1] - VIEW_ZONES[0][0]));
int MEDIUM_GEAR_VIEW_WIDTH = floor(CAM_WIDTH * (VIEW_ZONES[1][1] - VIEW_ZONES[1][0]));
int BIG_GEAR_VIEW_WIDTH = floor(CAM_WIDTH * (VIEW_ZONES[2][1] - VIEW_ZONES[2][0]));

OpenCV opencv;
Capture video;

Gear bigGear1;
Gear bigGear2;
Gear bigGear3;

PImage currentFrame;
PImage flippedFrame;

float maxLeftFlow = 0;
float maxRightFlow = 0;


// processing setup
void setup() {
  size(1280, 480);
  
  // declare gear data
  int viewWidth = floor(CAM_WIDTH * (VIEW_ZONES[2][1] - VIEW_ZONES[2][0]));
  
  bigGear1 = new Gear(2);
  bigGear1.type = 3;
  bigGear1.viewWidth = viewWidth;
  bigGear1.viewLeftEdge = floor(VIEW_ZONES[bigGear1.id][0] * CAM_WIDTH);
  bigGear1.initView(CAM_HEIGHT);
  
  bigGear2 = new Gear(4);
  bigGear2.type = 3;
  bigGear2.viewWidth = viewWidth;
  bigGear2.viewLeftEdge = floor(VIEW_ZONES[bigGear2.id][0] * CAM_WIDTH);
  bigGear2.initView(CAM_HEIGHT);
  
  bigGear3 = new Gear(7);
  bigGear3.type = 3;
  bigGear3.viewWidth = viewWidth;
  bigGear3.viewLeftEdge = floor(VIEW_ZONES[bigGear3.id][0] * CAM_WIDTH);
  bigGear3.initView(CAM_HEIGHT);

  // init video capture
  video = new Capture(this, CAM_WIDTH, CAM_HEIGHT, 30);
  video.start();

  // init open cv
  opencv = new OpenCV(this, CAM_WIDTH, CAM_HEIGHT);

  // frames
  currentFrame = new PImage(CAM_WIDTH, CAM_HEIGHT);
  flippedFrame = new PImage(CAM_WIDTH, CAM_HEIGHT);
}

void draw() {
  background(0);

  // copy video pixels
  currentFrame.copy(
    video, 
    0, 0, CAM_WIDTH, CAM_HEIGHT, 
    0, 0, CAM_WIDTH, CAM_HEIGHT
  );
  

  // copy from currentFrame
  copyViewZone(currentFrame, bigGear1);
  copyViewZone(currentFrame, bigGear2);
  copyViewZone(currentFrame, bigGear3);
  
  
  // draw camera views
  drawViewZone(bigGear1);
  drawViewZone(bigGear2);
  drawViewZone(bigGear3);
  
  
  // draw optical flow colors
  drawOpticalFlow(bigGear1);
  drawOpticalFlow(bigGear2);
  drawOpticalFlow(bigGear3);
}


// methods definitions
void copyViewZone(PImage src, Gear gear) {
  for (int i = 0; i < CAM_HEIGHT; i++) {
    for (int j = 0; j < BIG_GEAR_VIEW_WIDTH; j++) {
      gear.view.set(j, i, src.get(j + gear.viewLeftEdge, i));
    }
  }
}

void drawViewZone(Gear gear) {
  image(
    gear.view,
    gear.viewLeftEdge, 0,
    BIG_GEAR_VIEW_WIDTH, CAM_HEIGHT
   );
}

void drawOpticalFlow(Gear gear) {
    // TODO: add delay to reduce number of triggers

  
  PVector flow;
  
  opencv.loadImage(gear.view);
  opencv.calculateOpticalFlow();
  
  flow = opencv.getAverageFlow();
  maxLeftFlow = min(maxLeftFlow, flow.x);
  maxRightFlow = max(maxRightFlow, flow.x);

  float redRatio = abs(flow.x / maxLeftFlow);
  float blueRatio = abs(flow.x / maxRightFlow);
  int red = (flow.x < 0) ? floor(redRatio * 255): 0;
  int blue = (flow.x > 0) ? floor(blueRatio * 255): 0;

  if (abs(flow.x) > MOTION_TRIGGER_THRESHOLD) {
    // draw rect according to flow direction
    // intensity of color indicates speed of movement
    if (flow.x < 0) {
      fill(red, 0, 0);
      println("trigger counter clockwise, ratio of " + redRatio);

    } else if (flow.x > 0) {
      fill(0, 0, blue);
      println("trigger clockwise, ratio of " + blueRatio);
    }
    
    rect(
      CAM_WIDTH + gear.viewLeftEdge, 0,
      BIG_GEAR_VIEW_WIDTH, CAM_HEIGHT
    );
  }
}


// events
void captureEvent(Capture video) {
  video.read();
}