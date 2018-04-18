import gab.opencv.*;
import processing.video.*;


OpenCV opencv;
Capture video;


void setup() {
  size(640, 480);
  frameRate(30);
  background(0);

  opencv = new OpenCV(this, 640, 480);

  video = new Capture(this, width, height);
  video.start();  
}

void draw() {
  background(0);

  opencv.loadImage(video);
  opencv.calculateOpticalFlow();

  stroke(255, 255, 255);
  opencv.drawOpticalFlow();
  
}

void captureEvent(Capture video) {
  video.read();
}