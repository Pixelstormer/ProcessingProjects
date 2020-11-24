class light {
  int lightX, lightY;
  int brightness;
  float intensity;
  int shifter;

  light(int X, int Y, int Brightness, float Intensity, int Shifter) {
    lightX=X;
    lightY=Y;
    brightness=Brightness/2;
    intensity=Intensity/100;
    shifter=Shifter;
  }

  void render() {
    for (int y=lightY-brightness; y<lightY+brightness; y++) {
      for (int x=lightX-brightness; x<lightX+brightness; x++) {

        int colour=ceil(brightness-dist(x, y, lightX, lightY));
        if (colour<0||int(dist(x,y,lightX,lightY))>=brightness) {
          colour=0;
        }
        if(colour>255){
          colour=255;
        }
        colour = int(colour*intensity);
        colour = colour<<shifter;

        if (y>0&&y< height&&x>0&&x< width) {
           pixels[y* width+x]= pixels[y* width+x]|colour;
        }

//              pixels[abs(pixels.length-abs(y*width+x))]=pixels[abs(pixels.length-abs(y*width+x))]|colour;
      }
    }
    updatePixels();
  }

  void move(int newX, int newY){
//    if(clearLight){
      shiftPixels(shifter);
//    }
    lightX=newX;
    lightY=newY;
  }
}

