BoundingBox screenBounds;
PlayerCircle circle;
final PVector GRAVITY = new PVector(0, 0);

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  text("LOADING", width/2, height/2);
  
  screenBounds = new BoundingBox(0.9, 0.5, 0, 0, width, height);
  circle = new PlayerCircle(new PVector(width/2, height/2), GRAVITY, 2, 0.2, 0.6, 0.5, 25, 30, 15);
}

void draw(){
  background(0);
  screenBounds.setEdges(0, 0, width, height);
  circle.applyInputForces();
  circle.tickPhysics();
  circle.constrainToBounds(screenBounds);
  circle.updateLookAngle(new PVector(mouseX, mouseY));
  circle.render();
  
  fill(255);
  text(frameRate, 2, 16);
}

void circle(float x, float y, float diameter){
  ellipse(x, y, diameter, diameter);
}

float min(float a, float b, float c, float d){
  return min(min(a, b), min(c, d));
}

void keyPressed(){
  if(key == CODED){
    circle.activateInput(keyCode);
  }
  else{
    circle.activateInput(key);
  }
}

void keyReleased(){
  if(key == CODED){
    circle.deactivateInput(keyCode);
  }
  else{
    circle.deactivateInput(key);
  }
}

