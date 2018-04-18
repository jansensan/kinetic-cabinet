import gab.opencv.*;
import gohai.glvideo.*;


OpenCV opencv;
GLCapture video;


void setup() {
  size(640, 480, P2D);
  background(0);

  opencv = new OpenCV(this, 640, 480);

  video = new GLCapture(this);
  video.start();  
}

void draw() {
  background(0);

  if (video.available()) {
    video.read();
  }
  
  // display on screen
  image(video, 0, 0, width, height);
  
  // take snapshot
  PImage screenshot = new PImage(width, height);
  loadPixels();
  int pixelIndex = -1;
  for (int i = 0; i < height; i++) {
    for (int j = 0; j < width; j++) {
      pixelIndex++;
      screenshot.set(j, i, pixels[pixelIndex]);
    }
  }

  // test output
  //image(screenshot, 0, 0, width, height);

  if (screenshot.width <= 0 || screenshot.height <= 0) {
    println("Screenshot dimensions are empty. (" + millis() + ")");
    return;
  }
  
  opencv.loadImage(screenshot);
  opencv.calculateOpticalFlow();

  background(0);
  stroke(255, 255, 255);
  opencv.drawOpticalFlow();
}