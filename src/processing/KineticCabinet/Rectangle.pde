class Rectangle {
  int x = 0;
  int y = 0;
  int w = 0;
  int h = 0;


  // constructors
  Rectangle() {}

  Rectangle(int _x, int _y, int _w, int _h) {
    x = _x;
    y = _y;
    w = _w;
    h = _h;
  }


  // methods definition
  String toString() {
    return "Rectangle [x: " + x + ", y: " + y + ", w: " + w + ", h: " + h + "]";
  }
}