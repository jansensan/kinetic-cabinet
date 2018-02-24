import gab.opencv.*;
import processing.video.*;


int CAM_WIDTH = 640;
int CAM_HEIGHT = 480;

float[][] VIEW_ZONES = {
  {0.000, 0.060},
  {0.061, 0.146},
  {0.147, 0.256},
  {0.257, 0.342},
  {0.343, 0.452},
  {0.453, 0.512},
  {0.513, 0.598},
  {0.599, 0.708},
  {0.709, 0.794},
  {0.795, 0.854},
  {0.855, 0.940},
  {0.941, 1.000}
};

// gear IDs
int BIG_GEAR_1 = 2;
int BIG_GEAR_2 = 4;
int BIG_GEAR_3 = 7;

int BIG_GEAR_VIEW_WIDTH = floor(CAM_WIDTH * (VIEW_ZONES[BIG_GEAR_1][1] - VIEW_ZONES[BIG_GEAR_1][0]));
int BIG_GEAR_1_X = floor(VIEW_ZONES[BIG_GEAR_1][0] * CAM_WIDTH);
int BIG_GEAR_2_X = floor(VIEW_ZONES[BIG_GEAR_2][0] * CAM_WIDTH);
int BIG_GEAR_3_X = floor(VIEW_ZONES[BIG_GEAR_3][0] * CAM_WIDTH);


OpenCV opencv;
Capture video;

PImage currentFrame;
PImage flippedFrame;
PImage bigGear1View;
PImage bigGear1PrevFrame;
PImage bigGear2View;
PImage bigGear3View;

float maxLeftFlow = 0;
float maxRightFlow = 0;


// processing setup
void setup() {
  size(1280, 480);

  video = new Capture(this, CAM_WIDTH, CAM_HEIGHT, 30);
  video.start();

  opencv = new OpenCV(this, CAM_WIDTH, CAM_HEIGHT);

  currentFrame = new PImage(CAM_WIDTH, CAM_HEIGHT);
  flippedFrame = new PImage(CAM_WIDTH, CAM_HEIGHT);

  bigGear1View = new PImage(BIG_GEAR_VIEW_WIDTH, CAM_HEIGHT);
  bigGear2View = new PImage(BIG_GEAR_VIEW_WIDTH, CAM_HEIGHT);
  bigGear3View = new PImage(BIG_GEAR_VIEW_WIDTH, CAM_HEIGHT);
}

void draw() {
  background(0);


  // copy video pixels
  currentFrame.copy(
    video, 
    0, 0, CAM_WIDTH, CAM_HEIGHT, 
    0, 0, CAM_WIDTH, CAM_HEIGHT
  );


  // flip horizontally (mirror)
  pushMatrix();
  scale(-1.0, 1.0);

  // copy from currentFrame
  for (int i = 0; i < CAM_HEIGHT; i++) {
    for (int j = 0; j < CAM_WIDTH; j++) {
      int newX = (CAM_WIDTH - 1) - j;
      flippedFrame.set(newX, i, currentFrame.get(j, i));
    }
  }

  // reset matrix
  popMatrix();
  

  // copy from flippedFrame
  copyViewZone(flippedFrame, bigGear1View, BIG_GEAR_1_X);
  copyViewZone(flippedFrame, bigGear2View, BIG_GEAR_2_X);
  copyViewZone(flippedFrame, bigGear3View, BIG_GEAR_3_X);
  
  
  // draw
  //image(currentFrame, 0, 0, CAM_WIDTH, CAM_HEIGHT);
  //image(flippedFrame, CAM_WIDTH, 0, CAM_WIDTH, CAM_HEIGHT);
  drawViewZone(bigGear1View, BIG_GEAR_1_X);
  drawViewZone(bigGear2View, BIG_GEAR_2_X);
  drawViewZone(bigGear3View, BIG_GEAR_3_X);
  
  
  calculateOpticalFlow(bigGear1View, BIG_GEAR_1_X);
}


// methods definitions
void copyViewZone(PImage src, PImage target, int leftEdge) {
  for (int i = 0; i < CAM_HEIGHT; i++) {
    for (int j = 0; j < BIG_GEAR_VIEW_WIDTH; j++) {
      target.set(j, i, src.get(j + leftEdge, i));
    }
  }
}

void drawViewZone(PImage src, int leftEdge) {
  image(
    src,
    leftEdge, 0,
    BIG_GEAR_VIEW_WIDTH, CAM_HEIGHT
   );
}

void calculateOpticalFlow(PImage src, int leftEdge) {
  PVector flow;
  float triggerThreshold = 0.5;
  // TODO: add delay to reduce number of triggers
  
  // big gear 1
  opencv.loadImage(src);
  opencv.calculateOpticalFlow();
  
  flow = opencv.getAverageFlow();
  maxLeftFlow = min(maxLeftFlow, flow.x);
  maxRightFlow = max(maxRightFlow, flow.x);

  float redRatio = abs(flow.x / maxLeftFlow);
  float blueRatio = abs(flow.x / maxRightFlow);
  int red = (flow.x < 0) ? floor(redRatio * 255): 0;
  int blue = (flow.x > 0) ? floor(blueRatio * 255): 0;

  if (abs(flow.x) > triggerThreshold) {
    println("bg1 flow x: " + flow.x);
    println("redRatio: " + redRatio + ", blueRatio: " + blueRatio);
    
    // draw rect according to flow direction
    // intensity of color indicates speed of movement
    if (flow.x < 0) {
      fill(red, 0, 0);
    } else  {
      fill(0, 0, blue);
    }
    
    rect(
      CAM_WIDTH + leftEdge, 0,
      BIG_GEAR_VIEW_WIDTH, CAM_HEIGHT
    );
  }
}


// events
void captureEvent(Capture video) {
  video.read();
}