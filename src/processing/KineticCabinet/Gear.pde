class Gear {
  int type; // 1: small, 2: medium, 3: big
  int id = -1;

  int viewLeftEdge;
  int viewWidth;
  
  PImage view;
  
  Gear(int _id) {
    id = _id;
  }
  
  void initView(int viewHeight) {
    view = new PImage(viewWidth, viewHeight);
  }
}