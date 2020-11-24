car Car;
car Car2;
car ai;
track Track;
StringList inputBuffer=new StringList();
StringList inputBuffer2=new StringList();
PImage redCarSprite;
PImage blueCarSprite;
PImage greenCarSprite;
PImage goalSprite;
boolean debug=true;

boolean aiSwitch=false;

void setup() {
  size(760, 540);
  frame.setResizable(true);

  rectMode(CENTER);
  imageMode(CENTER);
  redCarSprite=loadImage("racecar.png");
  goalSprite=loadImage("checkerboard.png");
  blueCarSprite=loadImage("racecar_blue.png");
  greenCarSprite=loadImage("racecar_green.png");

  Car=new car(width/2, 78, redCarSprite);
  Car2=new car(width/2, 78, greenCarSprite);
  ai=new car(width/2, 78, blueCarSprite);
  Track= new track();

  Track.addPoint(new PVector(width/2, 78), true);
  Track.addPoint(new PVector(width/4, height/4), false);
  Track.addPoint(new PVector(width-width/1.4, height/2), true);
  Track.addPoint(new PVector(width/4, height-height/4), false);
  Track.addPoint(new PVector(width/2, height-78), true);
  Track.addPoint(new PVector(width-width/4, height-height/4), false);
  Track.addPoint(new PVector(width/1.4, height/2), true);
  Track.addPoint(new PVector(width-width/4, height/4), false);
}

void draw() {
  background(0, 128, 0);

  Track.render();

  if (debug) {
    for (point p : Track.points) {
      if (p.isWaypoint) {
        noStroke();
        fill(0, 0, 255, 85);
        ellipse(p.location.x, p.location.y, 116, 116);
        noFill();
        stroke(0, 0, 255);
      } else {
        stroke(255, 0, 0);
      }
      strokeWeight(3);
      noFill();
      ellipse(p.location.x, p.location.y, 15, 15);
    }
  }

  doInputs();
  Car.move();
  Car.render();
  Car.checkWayPoints();

  doInputs2();
  Car2.move();
  Car2.render();
  Car2.checkWayPoints();

  moveAI2();
  ai.checkWayPoints();
}

void drawTrack() {
  noFill();
  stroke(88);
  strokeWeight(116);
  ellipse(width/2, height/2, width/1.4, height/1.4);

  noStroke();
  fill(255);
  image(goalSprite, width/2, 78, 64, 118);
}

void moveAI() {
  float targetAngle;
  try {
    targetAngle=atan2(Track.points.get(ai.lastWaypointIndex+1).location.y-ai.y, Track.points.get(ai.lastWaypointIndex+1).location.x-ai.x);
  }
  catch(IndexOutOfBoundsException e) {
    targetAngle=atan2(Track.points.get(0).location.y-ai.y, Track.points.get(0).location.x-ai.x);
  }

  //  if(degrees(targetAngle)>180){
  //    targetAngle= radians(-180);
  //  }
  //  else if(degrees(targetAngle)< -180){
  //    targetAngle=radians(180);
  //  }

  if (degrees(targetAngle)>160) {
    aiSwitch=true;
  } else {
    aiSwitch=false;
  }

  if (!(aiSwitch)) {
    if (degrees(targetAngle)>ai.rotation) {
      ai.rotation+=3;
    } else {
      ai.rotation-=3;
    }
  } else {
    if (degrees(targetAngle)<ai.rotation) {
      ai.rotation+=3;
    } else {
      ai.rotation-=3;
    }
  }

  ai.speed+=0.8;

  ai.move();
  ai.render();
}

void moveAI2() {

  float targetX=Track.points.get(ai.lastWaypointIndex+1).location.x;
  float targetY=Track.points.get(ai.lastWaypointIndex+1).location.y;

  boolean below=false;
  boolean right=false;
  
  int result=0;

  targetX=mouseX;
  targetY=mouseY;
  strokeWeight(1);
  stroke(255);

  text(ai.rotation, ai.x, ai.y+100);

  if (abs(targetX-ai.x)==targetX-ai.x) {
    result++;
  }

  if (abs(targetY-ai.y)==targetY-ai.y) {
    result+=2;
  }
  
  switch(result){
    case 0:
      strokeWeight(1);
      stroke(0,0,255);
      break;
    case 1:
      strokeWeight(2);
      stroke(0,0,255);
      break;
    case 2:
      strokeWeight(1);
      stroke(255,0,0);
      break;
    case 3:
      strokeWeight(2);
      stroke(255,0,0);
  }

  line(ai.x, ai.y, targetX, targetY);
  
  if(ai.rotation<90){
    println("Not over 90");
  }
  else if(ai.rotation<180){
    println("Between 90 and 180");
  }
  else if(ai.rotation<270){
    println("Over 180");
  }
  else{
    println("Less than 360");
  }

  ai.rotation+=3;
  //  ai.speed+=0.8;
  ai.move();
  ai.render();
}

void doInputs() {
  if (inputBuffer.hasValue("UP")) {
    Car.speed+=0.2;
  }
  if (inputBuffer.hasValue("LEFT")) {
    Car.rotation-=3;
    Car.applyDrag(0.05);
  }
  if (inputBuffer.hasValue("RIGHT")) {
    Car.rotation+=3;
    Car.applyDrag(0.05);
  }
  if (inputBuffer.hasValue("DOWN")) {
    Car.speed-=0.2;
  }
}

void doInputs2() {
  if (inputBuffer2.hasValue("UP")) {
    Car2.speed+=0.2;
  }
  if (inputBuffer2.hasValue("LEFT")) {
    Car2.rotation-=3;
    Car2.applyDrag(0.05);
  }
  if (inputBuffer2.hasValue("RIGHT")) {
    Car2.rotation+=3;
    Car2.applyDrag(0.05);
  }
  if (inputBuffer2.hasValue("DOWN")) {
    Car2.speed-=0.2;
  }
}

void keyPressed() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:
      inputBuffer2.set(0, "UP");
      break;
    case RIGHT:
      inputBuffer2.set(1, "RIGHT");
      break;
    case LEFT:
      inputBuffer2.set(2, "LEFT");
      break;
    case DOWN:
      inputBuffer2.set(3, "DOWN");
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
      inputBuffer2.set(0, null);
      break;
    case RIGHT:
      inputBuffer2.set(1, null);
      break;
    case LEFT:
      inputBuffer2.set(2, null);
      break;
    case DOWN:
      inputBuffer2.set(3, null);
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
  }
}

