PVector location;
PVector velocity;
float speed = 3;
float distance = 120;
float drag = 0.98;
float angle = 0;

void setup(){
  size(840,560);
  surface.setResizable(true);
  
  location = new PVector(width/2,height/2);
  velocity = new PVector(0,0);
  
  background(0);
}

void draw(){
  background(0);
  
  PVector acceleration = PVector.sub(new PVector(width/2-distance,height/2),location);
  
  if(mousePressed){
    acceleration.add(PVector.sub(new PVector(mouseX,mouseY),location));
  }
  acceleration.setMag(1);
  
  velocity.add(acceleration);
  velocity.mult(drag);
  
  location.add(velocity);
  
  translate(width/2,height/2);
  rotate(radians(angle));
  
  fill(180);
  ellipse(location.x-width/2,location.y-height/2,15,15);
  ellipse(0,0,25,25);
  
  noFill();
  stroke(255);
  strokeWeight(2);
  ellipse(0,0,distance*2,distance*2);
  
  angle+=speed;
}