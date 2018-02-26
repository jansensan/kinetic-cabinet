import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.DwOpticalFlow;
import com.thomasdiewald.pixelflow.java.imageprocessing.filter.DwFilter;

import processing.core.*;
import processing.opengl.PGraphics2D;
import processing.video.Capture;


int CAM_WIDTH = 640;
int CAM_HEIGHT = 480;

float MOTION_TRIGGER_THRESHOLD = 8000;

color BLACK = #000000;
color RED = #ff0000;
color BLUE = #0000ff;

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

DwPixelFlow context;
DwOpticalFlow opticalflow;

PGraphics2D captureFrame;
PGraphics2D flowFrame;
PImage screenshot;

Capture video;

Gear bigGear1;
Gear bigGear2;
Gear bigGear3;


float maxLeftFlow = 0;
float maxRightFlow = 0;


// processing setup
void setup() {
  size(1280, 480, P2D);

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

  // main library context
  context = new DwPixelFlow(this);
  context.print();
  context.printGL();

  // optical flow
  opticalflow = new DwOpticalFlow(context, CAM_WIDTH, CAM_HEIGHT);

  // init video capture
  video = new Capture(this, CAM_WIDTH, CAM_HEIGHT, 30);
  video.start();

  // frames
  captureFrame = (PGraphics2D) createGraphics(CAM_WIDTH, CAM_HEIGHT, P2D);
  captureFrame.noSmooth();

  flowFrame = (PGraphics2D) createGraphics(CAM_WIDTH, CAM_HEIGHT, P2D);
  flowFrame.smooth(4);
  
  screenshot = new PImage(CAM_WIDTH, CAM_HEIGHT);

  background(0);
  frameRate(60);
}

void draw() {
  background(0);

  // render to offscreenbuffer
  captureFrame.beginDraw();
  captureFrame.image(video, 0, 0);
  captureFrame.endDraw();

  // update Optical Flow
  opticalflow.update(captureFrame);

  // rgba -> luminance (just for display)
  DwFilter.get(context).luminance.apply(captureFrame, captureFrame);


  // render Optical Flow
  flowFrame.beginDraw();
  flowFrame.clear();

  // uncomment to render camera
  // flowFrame.image(captureFrame, 0, 0, CAM_WIDTH, CAM_HEIGHT);

  flowFrame.endDraw();


  // flow visualizations
  opticalflow.param.display_mode = 0;
  opticalflow.renderVelocityShading(flowFrame);
  opticalflow.renderVelocityStreams(flowFrame, 5);

  // display result
  background(0);
  image(flowFrame, 0, 0);

  // get screenshot
  loadPixels();
  int pixelIndex = -1;
  for (int i = 0; i < CAM_HEIGHT; i++) {
    for (int j = 0; j < CAM_WIDTH; j++) {
      pixelIndex++;
      screenshot.set(j, i, pixels[pixelIndex]);
    }
    pixelIndex += CAM_WIDTH;
  }
  //image(screenshot, CAM_WIDTH, 0);
  

  // copy from currentFrame
  copyViewZone(screenshot, bigGear1);
  copyViewZone(screenshot, bigGear2);
  copyViewZone(screenshot, bigGear3);


  // draw camera views
  drawViewZone(bigGear1);
  drawViewZone(bigGear2);
  drawViewZone(bigGear3);
  
  // label directions
  String bg1Direction = getDirectionLabel(getFlowDirection(bigGear1.view));
  String bg2Direction = getDirectionLabel(getFlowDirection(bigGear2.view));
  String bg3Direction = getDirectionLabel(getFlowDirection(bigGear3.view));

  textSize(16);
  text(bg1Direction, CAM_WIDTH + bigGear1.viewLeftEdge, 24);
  text(bg2Direction, CAM_WIDTH + bigGear2.viewLeftEdge, 24);
  text(bg3Direction, CAM_WIDTH + bigGear3.viewLeftEdge, 24);
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
    CAM_WIDTH + gear.viewLeftEdge, 0,
    BIG_GEAR_VIEW_WIDTH, CAM_HEIGHT
   );
}

int getFlowDirection(PImage src) {
  int direction = 0;

  for (int i = 0; i < src.height; i++) {
    for (int j = 0; j < src.width; j++) {

      color pixelColor = src.get(j, i);
      int pixelRed = -1;
      int pixelBlue = -1;
      
      if (pixelColor != BLACK) {
        pixelRed = pixelColor & 255;
        pixelBlue = (pixelColor >> 16) & 255;
    
        int diffToRed = 255 - pixelRed;
        int diffToBlue = 255 - pixelBlue;
        
        // color is closer to red
        if (diffToRed < diffToBlue) {
          // moving right
          direction--;

        // color closer to blue
        } else if (diffToRed > diffToBlue) {
          // moving left
          direction++;
        }
      }

    }
  }
  
  return direction;
}

String getDirectionLabel(int direction) {
  String label = "";

  if (abs(direction) > MOTION_TRIGGER_THRESHOLD) {
    if (direction > 0) {
      label = "right";
    } else if (direction < 0) {
      label = "left";
    }
  }

  return label;
}


// events
void captureEvent(Capture video) {
  video.read();
}