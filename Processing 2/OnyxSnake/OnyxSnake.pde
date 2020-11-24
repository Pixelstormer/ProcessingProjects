Snake onyx;
InputSystem onyxController;
float speed = 10;

Snake ai;
float aiSpeed = 8;
PVector aiTarget;
float aiCooldown = 60;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  rectMode(CENTER);
  
  onyx = new Snake(new PVector(width/2, height/2), 8, 22.5, 0.3, 15);
  onyxController = new InputSystem(8);
  ai = new Snake(new PVector(width/2, height/4), 50, 5, 0.3, 15);
  aiTarget = new PVector(width/2, height/4);
}

void draw(){
  doUpdates();
  doRendering();
}

void doUpdates(){
  PVector inputDir = calculateInputDir();
  inputDir.setMag(speed);
  onyx.offsetHeadPosition(inputDir);
  onyx.update();
  updateAI();
}

void updateAI(){
  ai.update();
  if(PVector.dist(ai.getHeadPosition(), aiTarget) <= aiSpeed){
    aiCooldown--;
    if(aiCooldown<=0){
      aiTarget = new PVector(random(width), random(height));
      aiCooldown = random(256);
    }
  }
  else{
    PVector aiMovement = PVector.sub(aiTarget, ai.getHeadPosition());
    aiMovement.setMag(aiSpeed);
    ai.offsetHeadPosition(aiMovement);
  }
}

void doRendering(){
  background(0);
  onyx.render();
  ai.render();
}

PVector calculateInputDir(){
  PVector result = new PVector(0, 0);
  if(onyxController.getKeyState('w')
  || onyxController.getKeyState('W')
  || onyxController.getKeyState(UP)){
    result.y--;
  }
  if(onyxController.getKeyState('s')
  || onyxController.getKeyState('S')
  || onyxController.getKeyState(DOWN)){
    result.y++;
  }
  if(onyxController.getKeyState('a')
  || onyxController.getKeyState('A')
  || onyxController.getKeyState(LEFT)){
    result.x--;
  }
  if(onyxController.getKeyState('d')
  || onyxController.getKeyState('D')
  || onyxController.getKeyState(RIGHT)){
    result.x++;
  }
  return result;
}

void keyPressed(){
  if(key == CODED){
    onyxController.activateKey(keyCode);
  }
  else{
    onyxController.activateKey(key);
  }
}

void keyReleased(){
  if(key == CODED){
    onyxController.deactivateKey(keyCode);
  }
  else{
    onyxController.deactivateKey(key);
  }
}

