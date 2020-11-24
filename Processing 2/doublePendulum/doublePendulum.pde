PVector base;
PVector joint;
PVector head;

float jointLength = 128;
float headLength = 128;

float jointMass;
float headMass;

PVector gravity;

PVector jointVelocity;
PVector headVelocity;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  gravity = new PVector(0, 1);
  
  jointMass = 1;
  headMass = 1;
  
  base = new PVector(width/2, height/4);
  joint = new PVector(width/2 + jointLength, height/4);
  head = new PVector(width/2 + jointLength + headLength, height/4);
  
  jointVelocity = new PVector(0, 0);
  headVelocity = new PVector(0, 0);
}

void draw(){
  background(0);
  
  iterate();
  
  render();
}

// length = 120 * sin(angle/2) (Degrees)
// b = 120 * sin(a/2)
// a = (2 (-sin^(-1)(b/120) + 2 π n + π))/°
// a = (2 * ( -sin(b/120) + TWO_PI + PI)) / (PI/180)
//     (2 * (asin(b/radius) + 2  * π))/(PI/180)

// length = 60 * (2 * sin(pi*theta / 360)) (Radians)
// x = 60 * (2 * sin(pi*y / 360))
// y = (360 (2 π n + sin^(-1)(x/120)))/π and n element Z
// y = (360*(2*pi + asin(-1)*(x/120)))/pi
// angle = (360 * (TWO_PI + asin(-1) * (length/120))) / PI

// angle = 2 * asin(length/(2*radius))

void iterate(){
  PVector jointAcceleration = PVector.mult(gravity, jointMass);
  PVector headAcceleration = PVector.mult(gravity, headMass);
  
//  jointVelocity.add(PVector.mult(gravity, jointMass));
//  headVelocity.add(PVector.mult(gravity, headMass));
  
//  float angle = (360 * (TWO_PI + asin(-1) * (headVelocity.mag()/120))) / PI;
//  PVector dir = PVector.sub(head, joint);
//  dir.rotate(angle);
//  PVector newHead PVector.add(dir, joint);
//  headVelocity = PVector.sub(newHead, head);
//  head = newHead;
  
//  PVector predictedHead = PVector.add(head, headVelocity);
//  PVector idealHead = PVector.sub(predictedHead, joint);
//  idealHead.setMag(headLength);
//  idealHead.add(joint);
//  PVector headOffset = PVector.sub(idealHead, predictedHead);
//  headVelocity.add(headOffset);
  
//  headOffset.mult(-1);
//  jointVelocity.add(headOffset);

//https://en.wikipedia.org/wiki/Solution_of_triangles#Two_sides_and_non-included_angle_given_(SSA)
  
  //

  PVector headTension = PVector.sub(joint, head);
  headTension.setMag((headVelocity.magSq() * headMass)/headLength + headMass*gravity.mag());
  headAcceleration.add(headTension);
  
  PVector jointTension = PVector.sub(base, joint);
  jointTension.setMag((jointVelocity.magSq() * jointMass)/jointLength + jointMass*gravity.mag());
  jointAcceleration.add(jointTension);
  
//  float angle = 2 * asin(jointVelocity.mag()/(2*jointLength));
//  float mag = jointVelocity.mag();
//  PVector dir = PVector.sub(joint, base);
//  dir.rotate(angle);
//  PVector newJoint = PVector.add(dir, base);
//  jointVelocity.add(PVector.sub(base, joint));
//  joint = newJoint;
  
//  PVector predictedJoint = PVector.add(joint, jointVelocity);
//  PVector offset = PVector.sub(newJoint, predictedJoint);
//  jointVelocity.add(offset);
  
//  jointVelocity.add(PVector.sub(newJoint, joint));
//  jointVelocity.setMag(mag);
//  joint = newJoint;
  
  println(abs(PVector.sub(base, joint).mag()));
  
//  PVector predictedJoint = PVector.add(joint, jointVelocity);
//  PVector idealJoint = PVector.sub(predictedJoint, base);
//  idealJoint.setMag(jointLength);
//  idealJoint.add(base);
//  PVector jointOffset = PVector.sub(idealJoint, predictedJoint);
//  jointVelocity.add(jointOffset);

  jointVelocity.add(jointAcceleration);
  headVelocity.add(headAcceleration);
  
  joint.add(jointVelocity);
  head.add(headVelocity);
}

void render(){
  noFill();
  stroke(220);
  strokeWeight(10);
  line(base.x, base.y, joint.x, joint.y);
  line(joint.x, joint.y, head.x, head.y);
}

