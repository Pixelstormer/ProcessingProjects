final int spokes = 6;
final int arcs = 4;
final float scanSpeed = 1;

final int guiWeight = 3;
final int scanWeight = 12;

final color backgroundColour = color(0, 4);
final color guiColour = color(0, 255, 0);
final color obstructedColour = color(255, 0, 0);

PVector origin;

float scanDegree = 0;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  origin = new PVector(width/2, height);
  
  strokeCap(SQUARE);
  background(0);
}

void draw(){
  //background(0);
  fill(backgroundColour);
  noStroke();
  rect(0, 0, width, height);
  
  translate(origin.x, origin.y);
  
  strokeWeight(scanWeight);
  stroke(guiColour);
  drawScan();
  
  strokeWeight(guiWeight);
  stroke(guiColour);
  drawSpokes();
  drawArcs();
  
  //ellipse(mouseX - origin.x, mouseY - origin.y, 15, 15);
  
  scanDegree += scanSpeed;
}

void drawSpokes(){
  PVector spokeHead = new PVector(-origin.x, 0);
  line(-origin.x, -guiWeight/2, origin.x, -guiWeight/2);
  for(int i = 0; i < spokes; i++){
    spokeHead.rotate(radians(180/(spokes+1)));
    line(0, 0, spokeHead.x, spokeHead.y);
  }
}

void drawArcs(){
  for(int i = 1; i <= arcs; i++){
    ellipse(0, 0, width/(arcs+1)*i, width/(arcs+1)*i);
  }
}

void drawScan(){
  PVector scanHead = new PVector(-origin.x, 0);
  scanHead.rotate(radians(scanDegree));
  if(mousePressed){
    stroke(obstructedColour);
    float mouseMag = new PVector(mouseX - origin.x, mouseY - origin.y).mag();
    PVector mouseHead = scanHead.get();
    mouseHead.setMag(mouseMag);
    line(mouseHead.x, mouseHead.y, scanHead.x, scanHead.y);
    stroke(guiColour);
    line(0, 0, mouseHead.x, mouseHead.y);
  }
  else{
    line(0, 0, scanHead.x, scanHead.y);
  }
}

