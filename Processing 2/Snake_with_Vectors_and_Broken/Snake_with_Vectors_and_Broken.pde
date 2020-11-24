/**
 * Vectorsnake
 * WASD and Arrow Keys move a green 'snake' around the screen,
 * affected by acceleration and drag 
 * from the use of PVectors.
 */

int segCount=5;
int growCount=4;
FloatList x=new FloatList();
FloatList y=new FloatList();

float segLength = 20;
int segWidth=9;
boolean looping;

float fruitX, fruitY;
float targetX, targetY;
int speed=6;
StringList inputBuffer;

boolean debug=true;
boolean started=false;
boolean dead=false;
PFont font;

String[] highScore;
int currentScore;

Mover mover;

void setup() {
  size(860, 520);
  frame.setResizable(true);
  background(0);
  rectMode(CENTER);
  textAlign(CENTER);
  font=loadFont("Tunga-Bold-48.vlw");
  highScore=loadStrings("score.txt");

  mover=new Mover();
  targetX=width/2;
  targetY=height/2;
  noFill();
  inputBuffer=new StringList();
  for (int i=0; i<segCount; i++) {
    x.append(i);
    y.append(i);
  }
  newFruit();
}

void draw() {
  //  fill(0,60);
  //  noStroke();
  //  rect(width/2,height/2,width,height);
  background(0);
  if (started) {
    strokeWeight(segWidth);

    if (inputBuffer.hasValue("UP")) {
      targetY-=speed;
    }
    if (inputBuffer.hasValue("LEFT")) {
      targetX-=speed;
    }
    if (inputBuffer.hasValue("RIGHT")) {
      targetX+=speed;
    }
    if (inputBuffer.hasValue("DOWN")) {
      targetY+=speed;
    }

    fill(255, 0, 0, 160);
    noStroke();
    rect(fruitX, fruitY, 20, 20, 15);

    PVector fruit=new PVector(fruitX, fruitY);
    if (PVector.dist(fruit, mover.location)<25) {
      addSegments();
      newFruit();
    }

    mover.update();
    dragSegment(0, mover.location.x, mover.location.y, true);
    for (int i=0; i<segCount; i++) {
      dragSegment(i+1, x.get(i), y.get(i), false);
    }

    if (dead) {
      kill();
    }

    if (debug) {
      stroke(255);
      strokeWeight(1);
      noFill();

      ellipse(targetX, targetY, 15, 15);
      point(targetX, targetY);

      ellipse(mover.location.x, mover.location.y, 15, 15);
      point(mover.location.x, mover.location.y);
    }
  } else {
    fill(255);
    text("Snake, programmed with\nPVectors and floating-point numbers.\nPress Space to begin.", width/2, height/2);
  }
}

void dragSegment(int i, float xin, float yin, boolean head) {
  looping=false;
  float dx=0;
  float dy=0;
  try {
    dx = xin - x.get(i);
    dy = yin - y.get(i);
  }
  catch(ArrayIndexOutOfBoundsException e){}
  float angle = atan2(dy, dx);
  
  if(xin>width){
    loopSegment(i-1,4);
    looping=true;
  }
  if(xin<0){
    loopSegment(i-11,3);
    looping=true;
  }
  if(yin>height){
    loopSegment(i-1,2);
    looping=true;
  }
  if(yin<0){
    loopSegment(i-1,1);
    looping=true;
  }
  
  if(!(looping)){
    x.set(i, xin - cos(angle) * segLength);
    y.set(i, yin - sin(angle) * segLength);
  }

  if (debug) {
    if (head) {
      pushMatrix();
      translate(xin, yin);
      rotate(angle);
      strokeWeight(1);
      stroke(255);
      line(0, 0, segLength, 0);
      popMatrix();
    } else {
      pushMatrix();
      translate(x.get(i), y.get(i));
      rotate(angle);
      strokeWeight(1);
      stroke(0,255,0);
      line(0, 0, -segLength, 0);
      line(0, 0, segLength*1.5, 0);
      popMatrix();
    }
  }

  segment(x.get(i), y.get(i), angle);
}

void segment(float x, float y, float a) {
  pushMatrix();
  translate(x, y);
  rotate(a);
  strokeWeight(segWidth);
  PVector segment=new PVector(x, y);
  if (PVector.dist(mover.location, segment)<segWidth+(segLength/10)) {
    stroke(255, 0, 0, 100);
    dead=true;
  } else {
    stroke(0, 255, 0, 100);
  }
  line(0, 0, segLength, 0);
  popMatrix();
}

void addSegments() {
  segCount+=5;
  currentScore++;
  for (int i=0; i<growCount; i++) {
    if (x.get(x.size()-1)>x.get(x.size()-2)) {
      x.append(x.get(x.size()-1)+segLength);
    } else {
      x.append(x.get(x.size()-1)-segLength);
    }

    if (y.get(y.size()-1)>y.get(y.size()-2)) {
      y.append(y.get(y.size()-1)+segLength);
    } else {
      y.append(y.get(y.size()-1)-segLength);
    }
  }
}

void removeSegments(int count) {
  if (x.size()>count) {
    segCount-=count;
    for (int i=0; i<count; i++) {
      x.remove(x.size()-1);
    }
  }
}

void loopSegment(int i,int direction){
  switch(direction){
    case 1:
      try{
        y.set(i,height-segLength);
      }
      catch(ArrayIndexOutOfBoundsException e){
        y.set(i+1,height-segLength);
      }
      targetY=height-segLength-5;
      break;
    case 2:
      try{
        y.set(i,segLength);
      }
      catch(ArrayIndexOutOfBoundsException e){
        y.set(i+1,segLength);
      }
      targetY=segLength+5;
      break;
    case 3:
      try{
        x.set(i,width-segLength);
      }
      catch(ArrayIndexOutOfBoundsException e){
        x.set(i+1,width-segLength);
      }
      targetX=width-segLength-5;
      break;
    case 4:
      try{
        x.set(i,segLength);
      }
      catch(ArrayIndexOutOfBoundsException e){
        x.set(i+1,segLength);
      }
      targetX=segLength+5;
      break;
  }
}

void newFruit() {
  fruitX=random(25, width-25);
  fruitY=random(25, height-25);
}

void kill() {
  resetMatrix();
  textFont(font);
  updateScore();
  textSize(32);
  fill(255);
  text("Dead.", width/2, height/2);
  textSize(16);
  text("Final score: "+currentScore+". Highscore: "+highScore[0]+".\nPress Space to restart, or Esc to exit.", width/2, height/1.8);
  noLoop();
}

void restart() {
  loop();
  dead=false;
  looping=false;
  removeSegments(segCount-5);
  mover.location.set(width/2, height/2);
  targetX=width/2;
  targetY=height/2;
  newFruit();
  currentScore=0;
}

void updateScore() {
  if (currentScore>int(highScore[0])) { //If score is higher than highscore, save new highscore
    String[] newScore=new String[1];
    newScore[0]=str(currentScore);
    saveStrings("score.txt", newScore);
    textSize(16);
    fill(0, 255, 0);
    text("New highscore!", width/2, height/1.6);
    highScore[0]=newScore[0];
  }
}

void keyPressed() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:
      inputBuffer.set(0, "UP");
      break;
    case RIGHT:
      inputBuffer.set(1, "RIGHT");
      break;
    case LEFT:
      inputBuffer.set(2, "LEFT");
      break;
    case DOWN:
      inputBuffer.set(3, "DOWN");
      break;
    }
    break;
  case 'w':
  case 'W':
    inputBuffer.set(0, "UP");
    break;
  case 'd':
  case 'D':
    inputBuffer.set(1, "RIGHT");
    break;
  case 'a':
  case 'A':
    inputBuffer.set(2, "LEFT");
    break;
  case 's':
  case 'S':
    inputBuffer.set(3, "DOWN");
    break;
  }
}

void keyReleased() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:
      inputBuffer.set(0, null);
      break;
    case RIGHT:
      inputBuffer.set(1, null);
      break;
    case LEFT:
      inputBuffer.set(2, null);
      break;
    case DOWN:
      inputBuffer.set(3, null);
      break;
    }
    break;
  case 'w':
  case 'W':
    inputBuffer.set(0, null);
    break;
  case 'd':
  case 'D':
    inputBuffer.set(1, null);
    break;
  case 'a':
  case 'A':
    inputBuffer.set(2, null);
    break;
  case 's':
  case 'S':
    inputBuffer.set(3, null);
    break;
  case ' ':
    started=true;
    if (dead) {
      restart();
    }
    break;
  }
}

