int leftPaddle,rightPaddle;
int leftScore;
int rightScore;
int speed=6;

boolean[] leftInputs=new boolean[2];
boolean[] rightInputs=new boolean[2];

PVector ballPosition,ballVelocity;
float ballSpeed;

PImage[] scoreNumbers=new PImage[10];

void setup(){
  size(840,560);
  frame.setResizable(true);
  rectMode(CENTER);
  noSmooth();
  
  textSize(120);
  textAlign(CENTER);
  text("Loading",width/2,height/2);
  
  scoreNumbers[0]=loadImage("pixil-frame-0.png");
  scoreNumbers[1]=loadImage("pixil-frame-1.png");
  scoreNumbers[2]=loadImage("pixil-frame-2.png");
  scoreNumbers[3]=loadImage("pixil-frame-3.png");
  scoreNumbers[4]=loadImage("pixil-frame-4.png");
  scoreNumbers[5]=loadImage("pixil-frame-5.png");
  scoreNumbers[6]=loadImage("pixil-frame-6.png");
  scoreNumbers[7]=loadImage("pixil-frame-7.png");
  scoreNumbers[8]=loadImage("pixil-frame-8.png");
  scoreNumbers[9]=loadImage("pixil-frame-9.png");
  
  restart();
}

void draw(){
  if(leftScore<7 && rightScore<7){
    background(0);
    
    movePaddles();
    drawPaddles();
    
    checkCollision();
    
    moveBall();
    drawBall();
    
    drawScore();
  }
  else{
    background(0);
    drawScore();
    textSize(60);
    if(leftScore>=7){
      text("Player 1 wins!",width/2,height/2);
    }
    else if(rightScore>=7){
      text("Player 2 wins!",width/2,height/2);
    }
    textSize(32);
    text("Press SPACE to restart",width/2,height/2+60);
  }
}

void movePaddles(){
  if(leftInputs[0]){
    leftPaddle-=speed;
  }
  if(leftInputs[1]){
    leftPaddle+=speed;
  }
  
  if(rightInputs[0]){
    rightPaddle-=speed;
  }
  if(rightInputs[1]){
    rightPaddle+=speed;
  }
  
  leftPaddle=constrain(leftPaddle,32,height-32);
  rightPaddle=constrain(rightPaddle,32,height-32);
}

void drawPaddles(){
  fill(255);
  noStroke();
  
  rect(30,leftPaddle,15,64);
  rect(width-30,rightPaddle,15,64);
}

void checkCollision(){
  if(ballPosition.x<-7){
    resetBall();
    rightScore++;
  }
  if(ballPosition.x>width+7){
    resetBall();
    leftScore++;
  }
  
  if(ballPosition.x<45 && (ballPosition.y>leftPaddle-39 && ballPosition.y<leftPaddle+39)){
    if(abs(ballVelocity.y)==ballVelocity.y){ //If positive - Going Down
      ballVelocity=PVector.fromAngle(radians(map(dist(ballPosition.x,ballPosition.y,37,leftPaddle),0,39,0,60)));
      ballVelocity.setMag(ballSpeed);
    }
    else{ //Else - must be negative - going Up
      ballVelocity=PVector.fromAngle(radians(map(dist(ballPosition.x,ballPosition.y,37,leftPaddle),0,39,360,300)));
      ballVelocity.setMag(ballSpeed);
    }
    
    ballPosition.x=45;
    ballSpeed+=0.2;
  }
  
  if(ballPosition.x>width-45 && (ballPosition.y>rightPaddle-39 && ballPosition.y<rightPaddle+39)){
    if(abs(ballVelocity.y)==ballVelocity.y){ //If positive - Going Down
      ballVelocity=PVector.fromAngle(radians(map(dist(ballPosition.x,ballPosition.y,37,leftPaddle),0,39,0,80)));
      ballVelocity.setMag(ballSpeed);
    }
    else{ //Else - must be negative - going Up
      ballVelocity=PVector.fromAngle(radians(map(dist(ballPosition.x,ballPosition.y,37,leftPaddle),0,39,360,280)));
      ballVelocity.setMag(ballSpeed);
    }
    
    ballPosition.x=width-45;
    ballSpeed+=0.2;
  }
}

void moveBall(){
  ballPosition.add(ballVelocity);
  
  if(ballPosition.y<7 || ballPosition.y>height-7){
    ballVelocity.y*=-1;
  }
}

void drawBall(){
  fill(255);
  noStroke();
  
  rect(ballPosition.x,ballPosition.y,15,15);
}

void resetBall(){
  ballPosition=new PVector(width/2,height/2);
  ballVelocity=PVector.random2D();
  ballSpeed=5;
  ballVelocity.setMag(ballSpeed);
}

void restart(){
  leftPaddle=height/2;
  rightPaddle=height/2;
  leftScore=0;
  rightScore=0;
  leftInputs[0]=false;
  leftInputs[1]=false;
  rightInputs[0]=false;
  rightInputs[1]=false;
  resetBall();
}

void drawScore(){
  tint(255);
  image(scoreNumbers[leftScore],40,45,40,80);
  image(scoreNumbers[rightScore],width-80,45,40,80);
}

void keyPressed(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          rightInputs[0]=true;
          break;
        case DOWN:
          rightInputs[1]=true;
          break;
      }
      break;
    case 'w':
    case 'W':
      leftInputs[0]=true;
      break;
    case 's':
    case 'S':
      leftInputs[1]=true;
      break;
    case ' ':
      if(leftScore>=7 || rightScore>=7){
        restart();
      }
      break;
  }
}

void keyReleased(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          rightInputs[0]=false;
          break;
        case DOWN:
          rightInputs[1]=false;
          break;
      }
      break;
    case 'w':
    case 'W':
      leftInputs[0]=false;
      break;
    case 's':
    case 'S':
      leftInputs[1]=false;
      break;
  }
}

void mousePressed(){
  resetBall();
}

