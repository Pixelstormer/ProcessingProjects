class car{
  float x,y;
  float speed=0;
  int rotation;
  
  car(float X,float Y){
    x=X;
    y=Y;
    rotation=0;
  }
  
  void move(){
//    speed=constrain(speed,-24,24);
    
    applyDrag(0.08);
    
    x=speed*cos(radians(rotation))+x;
    y=speed*sin(radians(rotation))+y;
    
    if(x>width+10){
      x=-8;
    }
    if(x<-10){
      x=width+8;
    }
    
    if(y>height+10){
      y=-8;
    }
    if(y<-10){
      y=height+8;
    }
  }
  
  void applyDrag(float amt){
    if(abs(speed)!=speed){
      speed+=amt;
    }
    else{
      speed-=amt;
    }
  }
  
  void render(){
    pushMatrix();
    translate(x,y);
    rotate(radians(rotation)+radians(90));
    fill(255,0,0);
    beginShape(PConstants.TRIANGLES);
    vertex(0, -4*2);
    vertex(-4, 4*2);
    vertex(4, 4*2);
    endShape();
    popMatrix();
  }
}

