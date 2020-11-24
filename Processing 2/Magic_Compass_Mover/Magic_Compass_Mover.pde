int numSegments = 32;
float[] reachX = new float[numSegments];
float[] reachY = new float[numSegments];
float[] angle = new float[numSegments];
float segLength = 2;
float targetX, targetY;

Ball[] balls =  { 
  new Ball(100, 400, 80), 
  new Ball(700, 400, numSegments*segLength) 
};

void setup() {
  size(640, 480);
  frame.setResizable(true);
}

void draw() {
  background(0);
  
  reachX[reachX.length-1] = balls[1].position.x;
  reachY[reachY.length-1] = balls[1].position.y;
  
//  for (Ball b : balls) {
//    b.update();
//    b.display();
//    b.checkBoundaryCollision();
//  }
  
  balls[0].update();
//  balls[0].display();
  balls[0].checkBoundaryCollision();
  
  balls[1].update();
  balls[1].display();
  balls[1].checkBoundaryCollision();
  
  balls[0].checkCollision(balls[1]);
  
  stroke(255,100);
  
  reachSegment(0, balls[0].position.x, balls[0].position.y);
  for(int i=1; i<numSegments; i++) {
    reachSegment(i, targetX, targetY);
  }
  for(int i=reachX.length-1; i>=1; i--) {
    positionSegment(i, i-1);  
  } 
  for(int i=0; i<reachX.length; i++) {
    segment(reachX[i], reachY[i], angle[i], map(i,0,reachX.length,1,20));
  }
}

void positionSegment(int a, int b) {
  reachX[b] = reachX[a] + cos(angle[a]) * segLength;
  reachY[b] = reachY[a] + sin(angle[a]) * segLength; 
}

void reachSegment(int i, float xin, float yin) {
  float dx = xin - reachX[i];
  float dy = yin - reachY[i];
  angle[i] = atan2(dy, dx);  
  targetX = xin - cos(angle[i]) * segLength;
  targetY = yin - sin(angle[i]) * segLength;
}

void segment(float x, float y, float a, float sw) {
  strokeWeight(sw);
  pushMatrix();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  popMatrix();
}


