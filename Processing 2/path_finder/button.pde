class button {
  float x, y;
  String identifier;
  boolean direction;
  PImage sprite;

  button(float X, float Y, boolean Direction, String Identifier, PImage Sprite) {
    x=X;
    y=Y;
    identifier=Identifier;
    direction=Direction;
    sprite=Sprite;
  }

  void render() {
    if(mode==identifier){
      strokeWeight(8);
      stroke(#5F5F5F);
      renderExtraOptions();
    }
    else{
      strokeWeight(3);
      stroke(#4B4B4B);
    }
    fill(50, 120, 50);
    rect(getX(), getY(), 45, 45);
    image(sprite, getX(), getY(), 45, 45);
  }
  
  void renderExtraOptions(){
    if(identifier=="placeVehicles"){
      pushStyle();
      strokeWeight(3);
      stroke(#4B4B4B);
      fill(130);
      rect(getX()-22.5,getY()-27.5,90,22.5);
      
      fill(#4B4B4B);
      text("Speed:"+speed,getX()-18,getY()-25);
      
      fill(130);
      noStroke();
      rect(getX()+37.5,getY()-24.5,28,13.5);
      
      fill(#4B4B4B);
      text("+|-",getX()+37.5,getY()-25);
      popStyle();
    }
  }

  void checkPressed() {
    if (overRect(getX(), getY(), 45, 45)) {
      mode=identifier;
    }
  }

  float getX() {
    if (direction) {
      return width/2-width/1.2/x-22.5;
    } else {
      return width/2+width/1.2/x-22.5;
    }
  }
  
  float getY(){
    return height-y;
  }
}
