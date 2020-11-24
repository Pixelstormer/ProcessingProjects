int numSegments = 32;
float[] x = new float[numSegments];
float[] y = new float[numSegments];
float[] angle = new float[numSegments];
float segLength = 2;
float targetX, targetY;

float ballX = 50;
float ballY = 50;
int ballXDirection = 1;
int ballYDirection = -1;

void setup() {
  size(640, 360);
  strokeWeight(20.0);
  stroke(255, 100);
  noFill();
  x[x.length-1] = width/2;     // Set base x-coordinate
  y[x.length-1] = height/2;  // Set base y-coordinate
  frame.setResizable(true);
}

void draw() {
  background(0);

  x[x.length-1] = width/2;     // Set base x-coordinate
  y[x.length-1] = height/2;  // Set base y-coordinate
  
  strokeWeight(20);
  ballX = ballX + 8 * ballXDirection;
  ballY = ballY + 8 * ballYDirection;
  if(ballX > width-25 || ballX < 25) {
    ballXDirection *= -1; 
  }
  if(ballY > height-25 || ballY < 25) {
    ballYDirection *= -1; 
  }
  if(overCircle(width/2,height/2,(numSegments*segLength)*2)){
    ballXDirection*= -1;
    ballYDirection*= -1;
  }
  
  strokeWeight(2);
  noFill();
  ellipse(width/2,height/2,(numSegments*segLength)*2,(numSegments*segLength)*2);
  
  reachSegment(0, ballX, ballY);
  for(int i=1; i<numSegments; i++) {
    reachSegment(i, targetX, targetY);
  }
  for(int i=x.length-1; i>=1; i--) {
    positionSegment(i, i-1);  
  } 
  for(int i=0; i<x.length; i++) {
    segment(x[i], y[i], angle[i], map(i,0,x.length,1,20));
  }
}

void positionSegment(int a, int b) {
  x[b] = x[a] + cos(angle[a]) * segLength;
  y[b] = y[a] + sin(angle[a]) * segLength; 
}

void reachSegment(int i, float xin, float yin) {
  float dx = xin - x[i];
  float dy = yin - y[i];
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

boolean overCircle(int x, int y, float diameter) {
  float disX = x - ballX;
  float disY = y - ballY;
  if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}
