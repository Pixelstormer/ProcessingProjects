//3D ONLY

final HashMap<Integer, Boolean> inputs = new HashMap<Integer, Boolean>(10);
final PVector position = new PVector(0, 0, 0);
final PVector camOffset = new PVector(5, -100, 50);
PVector camPos = PVector.add(position, camOffset);
final float speed = 8;
final float camSpeed = 0.1;
final float camDist = 85;
final float originSize = 250;
final float camMoveTolerance = 1;
final float onOriginTolerance = 0.1;

float horizontalRotation = 0;
float verticalRotation = 0;

final PVector projectedCamPos = new PVector(0, 0, 0);

float camAngle = 0;

PVector vector = new PVector(100, -100, 100);

PVector mousePos = new PVector(0, 0);

void setup() {
  size(840, 560, P3D);
  frame.setResizable(true);

  //6 degrees of freedom:
  /*
  
   W: Forward
   S: Backwards
   A: Left
   D: Right
   SHIFT: Down
   SPACE: Up
   
   */
}

void draw() {
  background(0);
  lights();
  PVector offset = new PVector(0, 0, 0);
  try {
    if (inputs.get(int('w')) || inputs.get(int('W'))) {
      offset.z -= speed;
    }
  }
  catch(NullPointerException e) {
  }
  try {
    if (inputs.get(int('s')) || inputs.get(int('S'))) {
      offset.z += speed;
    }
  }
  catch(NullPointerException e) {
  }
  try {
    if (inputs.get(int('a')) || inputs.get(int('A'))) {
      offset.x -= speed;
    }
  }
  catch(NullPointerException e) {
  }
  try {
    if (inputs.get(int('d')) || inputs.get(int('D'))) {
      offset.x += speed;
    }
  }
  catch(NullPointerException e) {
  }
  try {
    if (inputs.get(SHIFT)) {
      offset.y += speed;
    }
  }
  catch(NullPointerException e) {
  }
  try {
    if (inputs.get(int(' '))) {
      offset.y -= speed;
    }
  }
  catch(NullPointerException e) {
  }
  drawOrigin();
  noStroke();
  position.add(offset);
  camPos.add(offset);

  float dist = PVector.dist(position, camPos);
  if (dist!=camDist) {
    PVector dir = PVector.sub(position, camPos);
    dir.setMag(dist-camDist);
    camPos.add(dir);
  }

  //camPos.lerp(PVector.add(position,camOffset),camSpeed);
  camera(camPos.x, camPos.y, camPos.z, 
  position.x, position.y, position.z, 
  0, 1, 0);
  translate(position.x, position.y, position.z);
  sphere(15);
}

void drawOrigin() {
  stroke(255, 0, 0);
  strokeWeight(3);
  line(originSize, 0, 0, -originSize, 0, 0);
  stroke(0, 255, 0);
  line(0, originSize, 0, 0, -originSize, 0);
  stroke(0, 0, 255);
  line(0, 0, originSize, 0, 0, -originSize);
  stroke(255, 255, 0);
  PVector endPoint = PVector.mult(position, 0.8);
  line(position.x, position.y, position.z, endPoint.x, endPoint.y, endPoint.z);
}

void drawCross() {
  stroke(255, 255, 0);
  line(0, 0, 0, vector.x, vector.y, vector.z);
  stroke(255, 0, 255);
  PVector xCross = vector.cross(new PVector(1, 0, 0));
  PVector yCross = vector.cross(new PVector(0, 1, 0));
  PVector zCross = vector.cross(new PVector(0, 0, 1));
  line(0, 0, 0, xCross.x, xCross.y, xCross.z);
  line(0, 0, 0, yCross.x, yCross.y, yCross.z);
  line(0, 0, 0, zCross.x, zCross.y, zCross.z);
}

void keyPressed() {
  switch(key) {
  case CODED:
    inputs.put(keyCode, true);
    break;
  default:
    inputs.put(int(key), true);
    break;
  }
  
  verticalRotation += 1;
  PVector newVertical = rotateAroundAxis(new PVector(0,0,1), new PVector(1,0,0), radians(verticalRotation));
  newVertical.setMag(camPos.mag()*2);
  camPos = newVertical;
}

void keyReleased() {
  switch(key) {
  case CODED:
    inputs.put(keyCode, false);
    break;
  default:
    inputs.put(int(key), false);
    break;
  }
}

PVector rotateAroundAxis(PVector point, PVector axis, float angle)
{
  PVector normalisedAxis = axis.normalize(null);
  PVector normalisedPoint = point.normalize(null);
  float dot = PVector.dot(normalisedAxis, point);
  PVector parallel = PVector.mult(normalisedAxis, dot);
  PVector perpendicular = PVector.sub(parallel, point);
  PVector Cross = point.cross(normalisedAxis);
  PVector result = PVector.add(parallel, PVector.add(PVector.mult(Cross, sin(-angle)), PVector.mult(perpendicular, cos(-angle))));
  return result;
}

PVector pointOnCircle(float orbitRadius, float rotation) {
  float ypos= mouseY/3;
  float xpos= cos(radians(rotation))*orbitRadius;
  float zpos= sin(radians(rotation))*orbitRadius;

  return new PVector(xpos, ypos, zpos);
}

float[] mapToLatLong(float x, float y, float mapRadius) {
  float longitude = x / mapRadius;
  float latitude = 2 * atan(exp(y/mapRadius)) - PI/2;

  return new float[] {
    longitude, latitude
  };
}

PVector mapLatLongToSphere(PVector origin, float latitude, float longitude, float sphereRadius) {
  float sx = sphereRadius * cos(latitude) * cos(longitude);
  float sy = sphereRadius * cos(latitude) * sin(longitude);
  float sz = sphereRadius * sin(latitude);

  return PVector.add(origin, new PVector(sx, sy, sz));
}

void mouseDragged() {
  PVector newMouse = new PVector(mouseX, mouseY);
  if (PVector.dist(newMouse, mousePos) < camMoveTolerance)
    return;
  PVector offset = PVector.sub(newMouse, mousePos);
  PVector camPointer = PVector.sub(position, camPos);
  
  verticalRotation += offset.y;
  horizontalRotation += offset.x;
  
  PVector newVertical = rotateAroundAxis(new PVector(0,0,1), new PVector(1,0,0), radians(verticalRotation));
  PVector newHorizontal = rotateAroundAxis(new PVector(0,0,1), new PVector(0,1,0), radians(horizontalRotation));
  camPos = PVector.add(newVertical, newHorizontal);
  
  mousePos = newMouse.get();
}

void mouseMoved() {
  //
}

void mousePressed() {
  if (position.mag() < onOriginTolerance)
    return;
  PVector dir = PVector.mult(position, 1.2);
  camPos.set(dir);
}


