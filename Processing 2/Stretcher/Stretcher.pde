int amt = 34;
float[] x = new float[amt];
float[] y = new float[amt];
float segLength = 0;
int lenThresh=32;
boolean growState=true;

float targetX, targetY;
float ballX = 50;
float ballY = 50;
int ballXDirection = 1;
int ballYDirection = -1;
int ballWidth=5;

void setup() {
  size(640, 360);
  strokeWeight(9);
  stroke(255, 100);
  frame.setResizable(true);
}

void draw() {
  background(0);
  
  if(segLength>=lenThresh){
    growState=false;
  }else if(segLength<=0){
    growState=true;
  }
  
  if(growState){
    segLength+=0.1;
  }else{
    segLength-=map(segLength,0,lenThresh,1,0.05);
  }
  
  ballX = ballX + 2 * ballXDirection;
  ballY = ballY + 4 * ballYDirection;
  if(ballX > width-ballWidth || ballX < ballWidth) {
    ballXDirection *= -1; 
  }
  if(ballY > height-ballWidth || ballY < ballWidth) {
    ballYDirection *= -1; 
  }
  
  dragSegment(0, ballX, ballY);
  for(int i=0; i<x.length-1; i++) {
    dragSegment(i+1, x[i], y[i]);
  }
}

void dragSegment(int i, float xin, float yin) {
  float dx = xin - x[i];
  float dy = yin - y[i];
  float angle = atan2(dy, dx);  
  x[i] = xin - cos(angle) * segLength;
  y[i] = yin - sin(angle) * segLength;
  segment(x[i], y[i], angle);
}

void segment(float x, float y, float a) {
  pushMatrix();
  translate(x, y);
  rotate(a);
  line(0, 0, segLength, 0);
  popMatrix();
}
