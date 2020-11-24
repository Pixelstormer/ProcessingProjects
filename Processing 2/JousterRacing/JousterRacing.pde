boolean[] Inputs;

PVector targetLoc;
float targetSpeed = 16;

Jouster[] Jousters;
int jousterAmount = 4;

PVector turnSpeedRange = new PVector(3,16);
PVector moveSpeedRange = new PVector(3,16);
PVector timeoutRange = new PVector(60,200);

PVector[] targetLocations;
int targets =  5;
float targetSize = 15;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  Inputs = new boolean[4];
  
  targetLocations = new PVector[targets];
  for(int i=0;i<targets;i++){
    targetLocations[i] = new PVector(random(width),random(height));
  }
  
  targetLoc = new PVector(width/1.5,height/2);
  
  Jousters = new Jouster[jousterAmount];
  for(int i=0;i<jousterAmount;i++){
    Jousters[i] = new Jouster(
          //At random position on screen
          new PVector(random(width),random(height)),
          //Facing random direction
          PVector.fromAngle(radians(random(360))),
          //Random turn speed from in the possible range
          random(turnSpeedRange.x,turnSpeedRange.y),
          //Random move speed from in the possible range
          random(moveSpeedRange.x,moveSpeedRange.y),
          //Random time to find a new target
          random(timeoutRange.x,timeoutRange.y)
        );
  }
  
  noFill();
  stroke(255);
  strokeWeight(3);
}

void draw(){
  background(0);
  
  if(Inputs[0]){
    targetLoc.y-=targetSpeed;
  }
  if(Inputs[1]){
    targetLoc.y+=targetSpeed;
  }
  if(Inputs[2]){
    targetLoc.x+=targetSpeed;
  }
  if(Inputs[3]){
    targetLoc.x-=targetSpeed;
  }
  
  targetLoc.x = constrain(targetLoc.x,8,width-7.5);
  targetLoc.y = constrain(targetLoc.y,8,height-7.5);
  
  for(Jouster j : Jousters){
//    j.updateNewTarget(-1);
    j.move();
    j.render();
  }
  
  for(PVector p : targetLocations){
    ellipse(p.x,p.y,targetSize,targetSize);
  }
  
//  ellipse(targetLoc.x,targetLoc.y,15,15);
}

void keyPressed(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          Inputs[0] = true;
          break;
        case DOWN:
          Inputs[1] = true;
          break;
        case LEFT:
          Inputs[3] = true;
          break;
        case RIGHT:
          Inputs[2] = true;
          break;
      }
      break;
    case 'w':
    case 'W':
      Inputs[0] = true;
      break;
    case 's':
    case 'S':
      Inputs[1] = true;
      break;
    case 'd':
    case 'D':
      Inputs[2] = true;
      break;
    case 'a':
    case 'A':
      Inputs[3] = true;
  }
}

void keyReleased(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          Inputs[0] = false;
          break;
        case DOWN:
          Inputs[1] = false;
          break;
        case LEFT:
          Inputs[3] = false;
          break;
        case RIGHT:
          Inputs[2] = false;
          break;
      }
      break;
    case 'w':
    case 'W':
      Inputs[0] = false;
      break;
    case 's':
    case 'S':
      Inputs[1] = false;
      break;
    case 'd':
    case 'D':
      Inputs[2] = false;
      break;
    case 'a':
    case 'A':
      Inputs[3] = false;
  }
}
