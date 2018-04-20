class Gear{

private:
  // constants
  int ROTATION_DURATION = 250;
  
  // vars
  int rotationEndTime = -1;

public:
  // vars
  int id = -1;
  float rotationRatio = 0;
  bool isTriggered = false;


  // constructor
  Gear(int _id) {
    id = _id;
  }


  // methods definitions
  void trigger() {
    if (isTriggered) {
      return;
    }

    isTriggered = true;
    rotationEndTime = millis() + ROTATION_DURATION;
  }

  void update() {
    if (isTriggered) {
      if (millis() >= rotationEndTime) {
        isTriggered = false;
      }
    }
  }
};
