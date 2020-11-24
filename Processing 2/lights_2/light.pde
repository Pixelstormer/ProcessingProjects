class light {
  int x, y;
  int diameter;
  int brightness;
  color fill;

  light(int X, int Y, int Diameter, int Brightness,color Fill) {
    x=X;
    y=Y;
    diameter=Diameter;
    brightness=Brightness;
    fill=Fill;
  }

  void render() {
    noStroke();
    for (int i=diameter; i>0; i--) {
      fill(fill, tan(map(i, diameter, 0, 0, radians(90)))*brightness);
      ellipse(x, y, i, i);
    }
  }
}

