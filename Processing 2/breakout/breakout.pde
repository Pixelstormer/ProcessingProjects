float paddleX;
int speed=12;
boolean[] inputs=new boolean[2];

PVector ballPosition, ballVelocity;
float ballSpeed=6;

int blocksInRow;
int blocksInColumn;
block[][] blocks;

int lives=3;
boolean allDestroyed;

void setup() {
  size(840, 560);
  frame.setResizable(true);
  rectMode(CENTER);
  textAlign(CENTER);

  text("Loading",width/2,height/2);
  restart();
}

void draw() {
  background(0);

  drawPaddle();
  
  if(lives>0&&!(allDestroyed)){
    movePaddle();
  
    checkCollision();
    moveBall();
    drawBall();
  }
  else{
    textSize(64);
    fill(255);
    if(lives<=0){
      text("Game over",width/2,height/2);
    }
    else if(allDestroyed){
      text("You win",width/2,height/2);
    }
    else{
      text("Game ended (Unknown reason)",width/2,height/2);
    }
    textSize(32);
    text("Press space to restart",width/2,height/2+64);
  }
  
  for(int x=0;x<blocksInRow;x++){
    for(int y=0;y<blocksInColumn;y++){
      blocks[x][y].render();
    }
  }
}

void movePaddle() {
  if (mousePressed && mouseButton==LEFT) {
    paddleX=lerp(paddleX, mouseX, 0.15);
  } else {
    if (inputs[0]) {
      paddleX-=speed;
    }
    if (inputs[1]) {
      paddleX+=speed;
    }
  }

  paddleX=constrain(paddleX, 32, width-32);
}

void drawPaddle() {
  noStroke();
  fill(255);

  rect(paddleX, height-30, 64, 10);
}

void checkCollision() {
  if (ballPosition.x<paddleX+32 && ballPosition.x>paddleX-32 && ballPosition.y>height-45) {
    if (abs(ballVelocity.x)==ballVelocity.x) { //If positive - Going Right
      ballVelocity=PVector.fromAngle(radians(map(dist(ballPosition.x, ballPosition.y, paddleX, height-45), 0, 39, 270, 330)));
      ballVelocity.setMag(ballSpeed);
    } else { //Else - must be negative - going Left
      ballVelocity=PVector.fromAngle(radians(map(dist(ballPosition.x, ballPosition.y, paddleX, height-45), 0, 39, 270, 210)));
      ballVelocity.setMag(ballSpeed);
    }
    ballPosition.y=height-45;
    //    ballSpeed+=0.2;
  }
  
  boolean toBreak=false;
  allDestroyed=true;
  for(int y=blocksInColumn-1;y>=0;y--){
    if(toBreak){
      break;
    }
    for(int x=blocksInRow-1;x>=0;x--){
      if(allDestroyed){
        allDestroyed=blocks[x][y].dead;
      }
      if(toBreak){
        break;
      }
      if(ballPosition.x<blocks[x][y].x+14 && 
         ballPosition.x>blocks[x][y].x-14 && 
         ballPosition.y<blocks[x][y].y+22 && 
         ballPosition.y>blocks[x][y].y-22 &&
         !(blocks[x][y].dead)){
           
        PVector brick=new PVector(blocks[x][y].x,blocks[x][y].y);
        PVector angle=PVector.sub(brick, ballPosition);
        angle.setMag(-ballSpeed);
        ballVelocity.set(angle);
        
        blocks[x][y].dead=true;
        toBreak=true;
        ballSpeed+=0.05;
      }
    }
  }
}

void moveBall() {
  ballPosition.add(ballVelocity);

  if (ballPosition.x<7){
    ballVelocity.x*=-1;
    ballPosition.x=7;
  }
  if(ballPosition.x>width-7) {
    ballVelocity.x*=-1;
    ballPosition.x=width-7;
  }
  if (ballPosition.y<7) {
    ballVelocity.y*=-1;
    ballPosition.y=7;
  }
  
  if(ballPosition.y>height+7){
    ballPosition.set(paddleX,height-45);
    lives--;
    ballSpeed=6;
  }
}

void drawBall() {
  fill(255);
  noStroke();

  rect(ballPosition.x, ballPosition.y, 15, 15);
}

void restart(){
  lives=3;
  ballSpeed=6;
  
  blocksInRow=width/31;
  blocksInColumn=8;
  blocks=new block[blocksInRow][blocksInColumn];
  
  inputs[0]=false;
  inputs[1]=false;
  paddleX=width/2;
  
  for(int x=0;x<blocksInRow;x++){
    for(int y=0;y<blocksInColumn;y++){
      blocks[x][y]=new block(width/blocksInRow*x+17,y*16+9);
    }
  }

  ballPosition=new PVector(paddleX, height-45);
  ballVelocity=PVector.random2D();
  ballVelocity.setMag(ballSpeed);
}

void keyPressed() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case LEFT:
      inputs[0]=true;
      break;
    case RIGHT:
      inputs[1]=true;
      break;
    }
    break;
  case 'a':
  case 'A':
    inputs[0]=true;
    break;
  case 'd':
  case 'D':
    inputs[1]=true;
    break;
  case ' ':
    if(lives<=0){
      restart();
    }
    break;
  }
}

void keyReleased() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case LEFT:
      inputs[0]=false;
      break;
    case RIGHT:
      inputs[1]=false;
      break;
    }
    break;
  case 'a':
  case 'A':
    inputs[0]=false;
    break;
  case 'd':
  case 'D':
    inputs[1]=false;
    break;
  }
}

