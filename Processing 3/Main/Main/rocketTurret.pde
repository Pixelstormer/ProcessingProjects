class Rocket{
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector target=new PVector(mouseX,mouseY);
  float topSpeed;
  float Acceleration;
  float range;
  boolean primed=false;
  float drag;
  int timer;
  int explodetime;
  int life=0;
  //PImage rocket=loadImage("rocket.gif");
  
  
  Rocket(float speed,float acceleration_,float range_,float drag_,int timer_,int explodetime_){
    location=new PVector(width/2,height/2);
    velocity=new PVector(0,0);
    topSpeed=speed;
    Acceleration=acceleration_;
    range=range_;
    drag=drag_;
    timer=timer_;
    explodetime=explodetime_;
  }
  
  int primed(){
    if(primed){
      timer--;
    }
    return timer;
  }
  
  void update(){
    target=new PVector(targX,targY);
    PVector acceleration=PVector.sub(target,location);
    acceleration.setMag(Acceleration);
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    velocity.div(drag);
    location.add(velocity);
    
    if(overCircle(location.x,location.y,int(range/2))){
      primed=true;
    }
    
    life++;
  }
  
  void display(){
    tint(255,map(timer,120,explodetime,255,0),map(timer,120,explodetime,255,0));
    pushMatrix();
    translate(location.x,location.y);
    rotate(velocity.heading()+radians(90));
    image(rocket,0,0,45,45);
    popMatrix();
  }
  
  void detonate(){
    fill(200,100,0,map(timer,explodetime,0,255,0));
    noStroke();
    ellipse(location.x,location.y,range,range);
    if(overCircle(location.x,location.y,int(range))){
      hit(1);
    }
  }
}