class Gear {
  // constants

  // threshold over which detected motion can cause an action trigger
  float TRIGGER_THRESHOLD = 2.5;

  // duration while which another trigger cannot be sent
  int TRIGGER_DURATION = 1000;


  // vars
  int type; // 1: small, 2: medium, 3: big
  int id = -1;
  int triggerEndTime = 0;

  Rectangle viewZone;
  PImage view;
  
  float[] flowValues = {0, 0};
  
  boolean isTriggered = false;
  
  Gear previous = null;
  Gear next = null;


  // constructor 
  Gear(int _id) {
    id = _id;
  }


  // methods definitions
  void init(float[] edges, int screenWidth, int screenHeight) {
    // init view zone
    viewZone = new Rectangle();
    viewZone.x = floor(edges[0] * screenWidth);
    viewZone.w = floor(screenWidth * (edges[1] - edges[0]));
    viewZone.h = screenHeight;
    
    // init view
    view = new PImage(viewZone.w, viewZone.h);
  }

  void analyzeIfTriggered() {
    // limit number of triggers
    if (isTriggered) {
      return;
    }
    
    if (abs(getAverageFlow()) > TRIGGER_THRESHOLD) {
      isTriggered = true;
      triggerEndTime = millis() + TRIGGER_DURATION;
    }
  }

  float getAverageFlow() {
    return (flowValues[0] + flowValues[1]) * 0.5;
  }
  
  void rotate(int direction, float impulse) {
    println("gear " + id + " triggered (" + getAverageFlow() + ")");
    
    // TODO: send to arduino (https://github.com/jansensan/kinetic-cabinet/issues/26)

    // TODO: trigger surrounding gears
    //if (previous != null) {
    //  previous.rotate();
    //}
    //if (next != null) {
    //  next.rotate();
    //}
  }

  void updateFlow(float newFlow) {
    flowValues[0] = flowValues[1];
    flowValues[1] = newFlow;
  }

  void update() {
    if (isTriggered && millis() >= triggerEndTime) {
      isTriggered = false;
    }
  }
}