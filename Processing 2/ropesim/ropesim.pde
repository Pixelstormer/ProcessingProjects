import java.util.List;
import java.util.Iterator;

final PVector SIZE = new PVector(840, 560);
PVector cameraOffset = new PVector(0, 0);
float cameraSpeed = 15;

//Strength of gravity
final float GRAVITY_MAGNITUDE = 0;
//Default mass for joints
final float DEFAULT_MASS = 10;
//Strength of manual pull
final float PULL_FORCE = 32;

final float JOINT_TIGHTNESS = 5;
final float JOINT_DAMPING = 0;

//Force of drag
final float DRAG_FORCE = .06;

final float FRICTION = .4;

final float DEINTERSECTION_RANDOMNESS = 0;
final float DEINTERSECTION_NOISE = .001;
final float SAME_ANGLE_TOLERANCE = 2;

final float EXTRA_COLLISION_SPACE = 0;

final int SPRING_ITERATIONS = 1;
final int COLLISION_ITERATIONS = 1;

final boolean CAM_FOLLOW = false;
final boolean SCREEN_CLAMPED = true;

float EDGE_LEFT = 1;
float EDGE_RIGHT = SIZE.x-2;
float EDGE_TOP = 1;
float EDGE_FLOOR = SIZE.y-2;

final PVector GRAVITY = new PVector(0, GRAVITY_MAGNITUDE);

final boolean[] inputs = new boolean[8];

Rope rope;

void setup() {
  size(int(SIZE.x), int(SIZE.y));
  frame.setResizable(true);

  rectMode(CENTER);

  rope = new Rope(new PVector(width/2, height/4), 32, 8, 9, JOINT_TIGHTNESS, JOINT_DAMPING);
  //rope.getLastJoint().anchor();
  rope.getLastJoint().xAnchored = true;
  rope.segments.get(0).xAnchored = true;
}

void draw() {
  background(0);
  translate(cameraOffset.x, cameraOffset.y);
  drawCross();
  doCamera();
  updateEdges();

  doInput();
  rope.iterate();
  doMouse();
  rope.render();
}

void drawCross() {
  stroke(200);
  strokeWeight(1);
  line(0, SIZE.y/2, SIZE.x, SIZE.y/2);
  line(SIZE.x/2, 0, SIZE.x/2, SIZE.y);
}

void doCamera() {
  if (CAM_FOLLOW) {
    cameraOffset = PVector.mult(rope.segments.get(0).position.get(), -1);
    cameraOffset.add(new PVector(width/2, height/2));
  } else {
    PVector offset = new PVector(0, 0);
    if (inputs[4]) {
      offset.y+=cameraSpeed;
    }
    if (inputs[5]) {
      offset.y-=cameraSpeed;
    }
    if (inputs[6]) {
      offset.x+=cameraSpeed;
    }
    if (inputs[7]) {
      offset.x-=cameraSpeed;
    }

    cameraOffset.add(offset);
  }
}

void doMouse() {
  if (!mousePressed) return;

  switch(mouseButton) {
  case LEFT:
    for (int i=0, s=rope.segments.size (); i<1; i++) {
      Rope.Joint j = rope.segments.get(i);
      PVector dif = PVector.sub(new PVector(mouseX, mouseY), j.position);
      dif.setMag(PULL_FORCE);
      PVector move = PVector.add(dif,j.position);
      j.position.set(mouseX,mouseY);
    }
    break;
  case RIGHT:

    break;
  }
}

void subMag(PVector input, float toSub) {
  if (toSub > abs(input.mag())) {
    input.setMag(0);
  } else {
    input.setMag(input.mag() - toSub);
  }
}

void updateEdges() {
  EDGE_TOP = -cameraOffset.y+1;
  EDGE_LEFT = -cameraOffset.x+1;
  EDGE_FLOOR = height-cameraOffset.y-2;
  EDGE_RIGHT = width-cameraOffset.x-2;
}

void doInput() {
  Rope.Joint target = rope.segments.get(0);
  PVector dir = new PVector(0, 0);

  if (inputs[0]) {
    dir.x+=-1;
  }

  if (inputs[1]) {
    dir.x+=1;
  }

  if (inputs[2]) {
    dir.y+=1;
  }

  if (inputs[3]) {
    dir.y+=-1;
  }

  dir.setMag(PULL_FORCE);
  target.addVelocity(dir);
}

void keyPressed() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:
      inputs[4] = true;
      break;
    case DOWN:
      inputs[5] = true;
      break;
    case LEFT:
      inputs[6] = true;
      break;
    case RIGHT:
      inputs[7] = true;
      break;
    }
    break;
  case 'a':
  case 'A':
    inputs[0] = true;
    break;
  case 'd':
  case 'D':
    inputs[1] = true;
    break;
  case 's':
  case 'S':
    inputs[2] = true;
    break;
  case 'w':
  case 'W':
    inputs[3] = true;
    break;
  case ' ':
    rope.segments.get(0).flipAnchor();
    break;
  }
}

void keyReleased() {
  switch(key) {
  case CODED:
    switch(keyCode) {
    case UP:
      inputs[4] = false;
      break;
    case DOWN:
      inputs[5] = false;
      break;
    case LEFT:
      inputs[6] = false;
      break;
    case RIGHT:
      inputs[7] = false;
      break;
    }
    break;
  case 'a':
  case 'A':
    inputs[0] = false;
    break;
  case 'd':
  case 'D':
    inputs[1] = false;
    break;
  case 's':
  case 'S':
    inputs[2] = false;
    break;
  case 'w':
  case 'W':
    inputs[3] = false;
    break;
  }
}

void mousePressed() {
  switch(mouseButton) {
  case LEFT:
    //rope.segments.get(0).anchor();
    frameRate(60);
    break;
  case RIGHT:
    frameRate(8);
  }
}

void mouseReleased(){
  switch(mouseButton){
    case LEFT:
   //rope.segments.get(0).unAnchor();
  }
}
