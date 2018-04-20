class Gear {
  // constants

  // threshold over which detected motion can cause an action trigger
  float TRIGGER_THRESHOLD = 0.25;
  
  // duration while which another trigger cannot be sent
  int TRIGGER_COOLDOWN = 4000;

  // max duration of gear rotation
  int ROTATION_DURATION = 1000;


  // vars
  int type; // 1: small, 2: medium, 3: big
  int id = -1;
  int nextAvailableTime = 0;
  int triggerEndTime = 0;
  int rotationEndTime = 0;

  float maxRightFlow = 0;
  float maxLeftFlow = 0;
  float impulse = 0;

  KineticCabinet main;

  Rectangle viewZone;
  PImage view;

  float[] flowValues = {0, 0};

  boolean isTriggered = false;
  boolean isRotating = false;

  Gear previous = null;
  Gear next = null;


  // constructor 
  Gear(KineticCabinet _main, int _id) {
    // FIXME: antipattern: child should not control parent
    main = _main;
    
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

  void clearTrigerredState() {
    if (isTriggered && millis() >= triggerEndTime) {
      printMethodName("clearTrigerredState");
      isTriggered = false;
    }
  }

  void endRotatingState() {
    if (isRotating && millis() >= rotationEndTime) {
      printMethodName("endRotatingState");
      isRotating = false;
      rotateSurroundingGears();
    }
  }

  float getAverageFlow() {
    return (flowValues[0] + flowValues[1]) * 0.5;
  }
  
  float getImpulseRatio() {
    printMethodName("rotate");
    
    float flow = getAverageFlow();
    float ratio = 0;

    if (flow > 0) {
      ratio = flow / maxRightFlow;
    } else if (flow < 0) {
      ratio = (flow / maxLeftFlow) * -1;
    }

    return ratio;
  }

  boolean isBig() {
    return (type == 3);
  }

  boolean isMedium() {
    return (type == 2);
  }

  boolean isSmall() {
    return (type == 1);
  }

  boolean isGearBigger(Gear gear) {
    return gear.type > type;
  }

  boolean isTriggerAvailable() {
    return (millis() >= nextAvailableTime) && !isTriggered;
  }

  void rotate(Gear source) {
    printMethodName("rotate");

    // TODO: see if should be ratio of some sort?
    impulse = getAverageFlow();

    // reverse direction
    if (source != this) {
      impulse *= -1;
    }

    rotationEndTime = millis() + ROTATION_DURATION;
    isRotating = true;

    // send to arduino (via parent)
    main.triggerMotor(this);
  }

  void rotateSurroundingGears() {
    if (!previous.isGearBigger(this)) {
      previous.rotate(this);
    }
    if (!next.isGearBigger(this)) {
      next.rotate(this);
    }
  }

  void trigger() {
    // limit number of triggers
    if (!isTriggerAvailable()) {
      return;
    }

    // save max values
    float flow = getAverageFlow();
    if (flow > 0) {
      maxRightFlow = max(maxRightFlow, flow);
    } else if (flow < 0) {
      maxLeftFlow = min(maxLeftFlow, flow);
    }

    // if flow above threshold, trigger
    if (main.IS_VERBOSE) {
      println("flow: " + flow);
    }
    if (abs(flow) > TRIGGER_THRESHOLD) {
      printMethodName("trigger");
      nextAvailableTime = millis() + TRIGGER_COOLDOWN;
      isTriggered = true;
      rotate(this);
    }
  }

  void updateFlow(float newFlow) {
    flowValues[0] = flowValues[1];
    flowValues[1] = newFlow;
  }

  void update() {
    endRotatingState();
    clearTrigerredState();
  }


  // utils
  void printMethodName(String methodName) {
    if (main.IS_VERBOSE) {
      println("\n--- Gear[id: " + id + "]." + methodName + "()");
    }
  }
}