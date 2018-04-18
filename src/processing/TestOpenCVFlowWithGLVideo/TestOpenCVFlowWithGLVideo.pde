import gab.opencv.*;
import gohai.glvideo.*;


OpenCV opencv;
GLCapture video;


void setup() {
  size(640, 480, P2D);
  frameRate(30);
  background(0);

  opencv = new OpenCV(this, 640, 480);

  video = new GLCapture(this);
  video.start();  
}

void draw() {
  background(0);

  if (video.width <= 0 || video.height <= 0) {
    return;
  }
  
  opencv.loadImage(video);
  opencv.calculateOpticalFlow();

  stroke(255, 255, 255);
  opencv.drawOpticalFlow();
}

void captureEvent(GLCapture video) {
  video.read();
}