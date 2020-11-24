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
  
  
  Rocket(float speed,float acceleration_,float range_,float drag_,int timer_){
    println("Made rocket");
    location=new PVector(width/2,height/2);
    velocity=new PVector(0,0);
    topSpeed=speed;
    Acceleration=acceleration_;
    range=range_;
    drag=drag_;
    timer=timer_;
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
  }
  
  void display(){
    fill(150,0,0,timer);
    noStroke();
    ellipse(location.x,location.y,range*2,range*2);
    stroke(255);
    strokeWeight(2);
    fill(80);
    if(primed){
      fill(200,0,0);
    }
    ellipse(location.x,location.y,15,15);
  }
  
  void detonate(){
    fill(200,100,0,160);
    noStroke();
    ellipse(location.x,location.y,range*4,range*4);
  }
}
