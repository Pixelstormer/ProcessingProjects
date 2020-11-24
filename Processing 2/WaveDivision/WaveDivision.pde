float stepDistance = 1;
float waveHeight = 34;
float waveSpeed = 0.8;
float waveOffset = 0.4;
float rippleHeight = 6;
float rippleSpeed = 2.5;
float rippleOffset = 1;
float timerValue = 0;

void start(){
  size(840,560);
  frame.setResizable(true);
  noCursor();
}

void draw(){
  background(0);
  fill(255);
  noStroke();
  timerValue++;
  
  beginShape();
  vertex(0,0);
  for(float i=0;i<width;i+=stepDistance){
    PVector point = new PVector(i,height/2);
    point.y += sin(radians(i*waveOffset+noise(i*0.006)*32+(timerValue*waveSpeed)))*waveHeight;
    point.y += cos(radians(i*rippleOffset+(timerValue*rippleSpeed)))*rippleHeight;
    
    vertex(point.x,point.y);
    //vertex(i,height/2+(sin(radians(i+(timerValue*waveSpeed)))+cos(radians(i+(timerValue*rippleSpeed)))*rippleHeight) * waveHeight);
  }
  vertex(width,0);
  endShape();
}

