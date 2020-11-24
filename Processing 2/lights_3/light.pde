class light {
  int lightX, lightY;
  int brightness;
  int shifter;

  light(int X, int Y, int Brightness, int Shifter) {
    lightX=X;
    lightY=Y;
    brightness=Brightness;
    shifter=Shifter;
  }

  void render() {
    for (int y=lightY-brightness; y<lightY+brightness; y++) {
      for (int x=lightX-brightness; x<lightX+brightness; x++) {

        int colour=floor(brightness-dist(x, y, lightX, lightY))<<shifter;
        if (colour<0) {
          colour=0;
        }

        if (y>0&&y<height&&x>0&&x<width) {
          pixels[y*width+x]=pixels[y*width+x]|colour;
        }

//              pixels[abs(pixels.length-abs(y*width+x))]=pixels[abs(pixels.length-abs(y*width+x))]|colour;
      }
    }
  }

  void move(int newX, int newY){
    if(clearLight){
      shiftPixels(shifter);
    }
    lightX=newX;
    lightY=newY;
  }
}

