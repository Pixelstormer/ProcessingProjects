PVector position;
PVector velocity;
final float diameter = 5;
final float drag = 0.001;
final float startSpeed = 8;
final float gravityForce = 1;
final float elasticity = 0.999;
final float weight = 1;
final float pullForce = 1;

void setup(){
  size(840,560);
  frame.setResizable(true);
  noStroke();
  fill(255);
  
  position = new PVector(diameter,height-diameter);
  velocity = PVector.mult(PVector.fromAngle(radians(-45)), startSpeed);
  
  Slider s = new SliderBuilder(new PVector(0,0), new PVector(1,1), 0, 1).build();
}

void draw(){
  background(0);
  
  velocity.y += gravityForce * weight;
  
  if(mousePressed){
    pullTowardsPoint(mouseX, mouseY, pullForce);
  }
  
  velocity.add(PVector.mult(velocity, -drag));
  
  position.add(velocity);
  
  if(position.y + diameter/2 > height){
    velocity.y *= -elasticity;
    position.y = height - diameter/2;
  }
  
  if(position.x - diameter/2 < 0){
    velocity.x *= -elasticity;
    position.x = diameter/2;
  }
  
  if(position.x + diameter/2 > width){
    velocity.x *= -elasticity;
    position.x = width - diameter/2;
  }
  
  ellipse(position.x,position.y,diameter,diameter);
}

void applyForce(PVector force){
  velocity.add(PVector.div(force, weight));
}

void pullTowardsPoint(PVector point, float strength){
  applyForce(PVector.mult(PVector.sub(point, position).normalize(null),strength));
}

void pullTowardsPoint(float x, float y, float strength){
 pullTowardsPoint(new PVector(x, y), strength);
}


