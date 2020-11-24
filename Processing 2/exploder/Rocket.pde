class Rocket{
  PVector location;
  PVector velocity;
  PVector target=new PVector(mouseX,mouseY);
  float topSpeed;
  float Acceleration;
  float range;
  boolean primed=false;
  float drag;
  int timer;
  int explodetime;
  int lifetime=0;
  int maxLifeTime;
  
  
  Rocket(float speed,float acceleration_,float range_,float drag_,int timer_,int explodetime_,int maxLifeTime_){
    location=new PVector(width/2,height/2);
    velocity= PVector.random2D();
    velocity.mult(20);
    topSpeed=speed;
    Acceleration=acceleration_;
    range=range_;
    drag=drag_;
    timer=timer_;
    explodetime=explodetime_;
    maxLifeTime=maxLifeTime_;
  }
  
  int primed(){
    if(primed){
      timer--;
    }
    return timer;
  }
  
  void update(){
    target=new PVector(mouseX,mouseY);
    PVector acceleration=PVector.sub(target,location);
    acceleration.setMag(Acceleration);
    velocity.add(acceleration);
    velocity.limit(topSpeed);
    velocity.div(drag);
    location.add(velocity);
    
    if(location.dist(target)<=range){
      primed=true;
    }
    lifetime++;
  }
  
  void display(){
    tint(255,map(timer,240,explodetime,255,0),map(timer,240,explodetime,255,0));
    pushMatrix();
    translate(location.x,location.y);
    rotate(velocity.heading()+radians(90));
    image(img,0,0,45,45);
    popMatrix();
  }
  
  void detonate(){
    fill(200,100,0,map(timer,explodetime,0,255,0));
    noStroke();
    ellipse(location.x,location.y,range*4,range*4);
  }
}
