class Unit{
  int segCount=800;
  float[] x = new float[segCount];
  float[] y = new float[segCount];
  float segLength = 1;
  float easeX;
  float easeY;
  float ease=0.9;
  float mouseEase=0.08;
  
  String[] colour=new String[10];
  float red;
  float blue;
  float green;
  
  PVector target;
  PVector velocity;
  
  Unit(){
    this.setup();
  }
  
  void setup() {
    stroke(100, 200);
    PVector origin = new PVector(random(width),random(height));
    for(int i=0;i<segCount;i++){
      x[i] = origin.x;
      y[i] = origin.y;
    }
    easeX = origin.x;
    easeY = origin.y;
    target = origin.copy();
    velocity = new PVector(6, 0);
  }
  
  void draw() {
    updateTarget();
    //PVector next = PVector.add(target, PVector.mult(velocity, 6));
    //line(target.x, target.y, next.x, next.y);
    strokeWeight(9);
    easeX=lerp(easeX, target.x, mouseEase);
    easeY=lerp(easeY, target.y, mouseEase);
    dragSegment(0, easeX, easeY);
    noFill();
    strokeWeight(9);
    beginShape();
    for (int i=0; i<x.length-1; i++) {
      PVector[] result = dragSegment(i+1, x[i], y[i]);
      if(i%4 == 0){
        PVector point = result[0];
        PVector colour = result[1];
        stroke(colour.x,colour.y,colour.z);
        curveVertex(point.x,point.y);
        if(i==0 || i==x.length-2) curveVertex(point.x,point.y);
      }
    }
    endShape();
  }
  
  PVector makeVelocity(float angle) {
    PVector newVel = PVector.fromAngle(radians(angle));
    newVel.setMag(6);
    return newVel.copy();
  }
  
  void updateTarget() {
    velocity.rotate(radians(random(-32,32)));
    target.add(velocity);
  
    if (target.x < 0) {
      target.x = 0; 
      //velocity = makeVelocity(0);
      velocity.rotate(radians(180));
    }
    if (target.x > width) {
      target.x = width; 
      //velocity = makeVelocity(180);
      velocity.rotate(radians(180));
    }
    if (target.y < 0) {
      target.y = 0; 
      //velocity = makeVelocity(90);
      velocity.rotate(radians(180));
    }
    if (target.y > height) {
      target.y = height; 
      //velocity = makeVelocity(270);
      velocity.rotate(radians(180));
    }
  }
  
  PVector[] dragSegment(int i, float xin, float yin) {
    float dx = xin - x[i];
    float dy = yin - y[i];
    float angle = atan2(dy, dx);
    float ex=xin - cos(angle) * segLength;
    float ey=yin - sin(angle) * segLength;
    x[i] = lerp(x[i], ex, ease);
    y[i] = lerp(y[i], ey, ease);
    PVector colour = new PVector(255-abs(map(float(i), 1, segCount, 255, -255)), map(float(i), 1, segCount, 255, 1), map(float(i), 1, segCount, 1, 255));
    return new PVector[]{new PVector(x[i],y[i],angle),colour};
  }
  
  void segment(float x, float y, float a) {
    pushMatrix();
    translate(x, y);
    rotate(a);
    line(0, 0, segLength, 0);
    popMatrix();
  }
}