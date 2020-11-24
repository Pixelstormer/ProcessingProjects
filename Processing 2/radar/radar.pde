import java.util.List;

int iterationsToFadeout = 50;
float currentIteration = 0;
float iterationIncrement = 1;
float fadeoutDistance = 0.2;

List<PVector> points = new ArrayList<PVector>();

void setup(){
  size(600, 600);
  frame.setResizable(true);
  
  noFill();
  stroke(0, 255, 0);
  strokeWeight(2);
}

void draw(){
  background(0);
  translate(getXOffset(), getYOffset());
  
  stroke(20);
  fill(0, 20, 0);
  ellipse(0, 0, width, height);
  
  noFill();
  
  for(int i=0; i<iterationsToFadeout; i++){
    PVector line = new PVector(-getXOffset(), 0);
    line.rotate(radians(currentIteration - i*fadeoutDistance));
    
    stroke(0, map(i, 0, iterationsToFadeout, 255, 20), 0);
    
    line(0, 0, line.x, line.y);
  }
  
  stroke(0, 255, 0);
  point(0, 0);
  
  for(PVector p : points){
    point(p.x, p.y);
  }
  
  currentIteration += iterationIncrement;
}

float getXOffset(){
  return width/2;
}

float getYOffset(){
  return height/2;
}

void mousePressed(){
  points.add(new PVector(mouseX - getXOffset(), mouseY - getYOffset()));
}

