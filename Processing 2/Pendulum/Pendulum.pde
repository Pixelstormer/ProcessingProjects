PVector origin;
PVector location;
PVector velocity;
PVector gravity;
PVector force;

float startAngle = 150;
float rodLength = 150;
float drag = 0.995;
float forceStrength = 0.08;

deltaTimeSystem Time;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  origin = new PVector(width/2,height/4);
  location = PVector.add(PVector.mult(PVector.fromAngle(radians(startAngle)),rodLength),origin);
  velocity = new PVector(0,0);
  gravity = new PVector(0,9.81);
  force = new PVector(0,0);
  
  Time = new deltaTimeSystem();
}

void draw(){
  background(0);
  Time.update();
  
  force = PVector.sub(new PVector(mouseX,mouseY),location);
  force.mult((mousePressed) ? forceStrength : 0);
  
  PVector acceleration = new PVector(0,0);
  PVector scaledGravity = PVector.mult(gravity,Time.scaledDeltaTime);
  PVector scaledForce = PVector.mult(force,Time.scaledDeltaTime);
  acceleration.add(scaledGravity);
  acceleration.add(scaledForce);
  
  PVector pull = PVector.sub(origin,location);
  pull.setMag(gravity.mag() * cos(PVector.angleBetween(PVector.mult(pull,-1),new PVector(0,1)))+5);
//  pull.mult(-1);
  println(pull.mag());
  acceleration.add(PVector.mult(pull,Time.scaledDeltaTime));
  
  velocity.add(acceleration);
  
//  velocity.mult(drag);
  
  location.add(velocity);
  
  stroke(255);
  strokeWeight(3);
  strokeCap(ROUND);
  line(origin.x,origin.y,location.x,location.y);
  stroke(255,0,0);
  drawVector(location,PVector.mult(acceleration,200));
  drawVector(location,PVector.mult(gravity,10));
  stroke(0,255,0);
  drawVector(location,PVector.mult(pull,10));
  drawVector(origin,PVector.mult(new PVector(0,1),100));
  stroke(0,0,255);
  drawVector(location,PVector.mult(velocity,10));
  stroke(255);
  fill(255);
  ellipse(location.x,location.y,15,15);
}

void drawVector(PVector origin, PVector direction){
  line(origin.x,origin.y,origin.x+direction.x,origin.y+direction.y);
}


