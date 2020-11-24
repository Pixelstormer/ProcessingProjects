//Location vector representing Anchor point
PVector origin;
//Location vector representing Current location
PVector location;
//Direction vector representing Current velocity
PVector velocity;
//Direction vector representing Pull towards origin
PVector pull;
//Direction vector representing Pull of gravity
PVector gravity;
//Direction vector representing Manual external pull
PVector force;

//Float representing strength of Pull towards origin
float pullScalar = 0.8;

//Float representing length from origin at which Pull begins to be applied
float stringLength = 120;

//Float representing strength of Force towards mouse
float forceStrength = 0.08;

//Float representing drag applied to velocity
float drag = 0.995;

//Float representing maximum pull strength of string
float maxPull = 1000;

//Time system calculates deltatime to scale speed with framerate
deltaTimeSystem Time;

void setup(){
  size(840,560);
  frame.setResizable(true);
  //frameRate(9999);
  text("LOADING",width/2,height/2);
  
  Time = new deltaTimeSystem();
  
  origin = new PVector(width/2,height/4);
  location = new PVector(width/2,height/2);
  velocity = new PVector(0,0);
  pull = new PVector(0,0);
  gravity = new PVector(0,9.81);
  force = new PVector(0,0);
}

void draw(){
  background(0);
  Time.update();
  text(frameRate,5,15);
  origin.set(width/2,height/4);
  
  pull = PVector.sub(origin,location);
  pull.setMag(constrain(PVector.dist(origin,location)*pullScalar - stringLength,0,maxPull));
  
  force = PVector.sub(new PVector(mouseX,mouseY),location);
  force.mult((mousePressed) ? forceStrength : 0);
  
  PVector acceleration = new PVector(0,0);
  PVector scaledPull = PVector.mult(pull,Time.scaledDeltaTime);
  PVector scaledGravity = PVector.mult(gravity,Time.scaledDeltaTime);
  PVector scaledForce = PVector.mult(force,Time.scaledDeltaTime);
  acceleration.add(scaledPull);
  acceleration.add(scaledGravity);
  acceleration.add(scaledForce);
  
  velocity.add(acceleration);
  velocity.mult(drag);
  
  location.add(velocity);
  
  stroke(255);
  strokeWeight(3);
  strokeCap(ROUND);
  line(origin.x,origin.y,location.x,location.y);
  fill(255);
  ellipse(location.x,location.y,15,15);
}


