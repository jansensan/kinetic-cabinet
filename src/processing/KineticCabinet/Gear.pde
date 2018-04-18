class Gear {
  // constants

  // threshold over which detected motion can cause an action trigger
  float TRIGGER_THRESHOLD = 2.5;
  
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

  void clearRotatingState() {
    if (isRotating && millis() >= rotationEndTime) {
      printMethodName("clearRotatingState");
      isRotating = false;
    }
  }

  void clearTrigerredState() {
    if (isTriggered && millis() >= triggerEndTime) {
      printMethodName("clearTrigerredState");
      isTriggered = false;
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

  boolean isTriggerAvailable() {
    return (millis() >= nextAvailableTime) && !isTriggered;
  }

  void rotate(Gear source) {
    printMethodName("rotate");

    // TODO: see if should be ratio of some sort
    impulse = getAverageFlow();

    rotationEndTime = millis() + ROTATION_DURATION;

    // affect rotation duration according to source size
    if (source == this) {
      isRotating = true;

      // send to arduino (via parent)
      main.triggerMotor(this);

    } else if (source == previous) {
      // reverse direction
      impulse *= -1;

      // TODO: handle previous gear rotation
      //if (previous != null) {
      //  previous.rotate();
      //}

    } else if (source == next) {
      // reverse direction
      impulse *= -1;

      // TODO: handle previous gear rotation
      //if (next != null) {
      //  next.rotate();
      //}
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
    clearRotatingState();
    clearTrigerredState();
  }


  // utils
  void printMethodName(String methodName) {
    if (main.IS_VERBOSE) {
      println("\n--- Gear[id: " + id + "]." + methodName + "()");
    }
  }
}