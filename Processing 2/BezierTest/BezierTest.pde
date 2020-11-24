DraggablePoint control1;
DraggablePoint control2;
DraggablePoint anchor1;
DraggablePoint anchor2;
DraggablePoint dragging;

Slider t;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  control1 = new DraggablePoint(width/3, height/2, 20, "Control1");
  control2 = new DraggablePoint(width/1.5, height/2, 20, "Control2");
  anchor1 = new DraggablePoint(width/2.5, height/1.5, 20, "Anchor1");
  anchor2 = new DraggablePoint(width/1.75, height/1.5, 20, "Anchor2");
  
  t = new Slider(new PVector(35, height-35), new PVector(width-35, height-35), 0, 1, 0.5);
}

void draw(){
  background(0);
  
  if(dragging != null){
    dragging.setLocation(mouseX, mouseY);
  }
  else if(mousePressed && t.isIntersecting(new PVector(mouseX, mouseY))){
    t.setPercent(t.getPercentAlong(new PVector(mouseX, mouseY)));
  }
  
  t.render();
  
  stroke(160);
  line(anchor1.getLocation(), control1.getLocation());
  line(control1.getLocation(), control2.getLocation());
  line(control2.getLocation(), anchor2.getLocation());
  
  stroke(255, 0, 0);
  bezier(anchor1.getLocation(), control1.getLocation(), control2.getLocation(), anchor2.getLocation());
  
  stroke(0, 255, 0);
  PVector lerp1 = PVector.lerp(anchor1.getLocation(), control1.getLocation(), t.getValue());
  PVector lerp2 = PVector.lerp(control1.getLocation(), control2.getLocation(), t.getValue());
  PVector lerp3 = PVector.lerp(control2.getLocation(), anchor2.getLocation(), t.getValue());
  line(lerp1, lerp2);
  line(lerp2, lerp3);
  noStroke();
  fill(0, 255, 0);
  circle(lerp1, 8);
  circle(lerp2, 8);
  circle(lerp3, 8);
  PVector lerp4 = PVector.lerp(lerp1, lerp2, t.getValue());
  PVector lerp5 = PVector.lerp(lerp2, lerp3, t.getValue());
  stroke(0, 0, 255);
  line(lerp4, lerp5);
  fill(0, 0, 255);
  noStroke();
  circle(lerp4, 8);
  circle(lerp5, 8);
  fill(255);
  circle(PVector.lerp(lerp4, lerp5, t.getValue()), 4);
  
  noFill();
  stroke(255);
  
  control1.render();
  control1.renderFlavourText();
  control2.render();
  control2.renderFlavourText();
  anchor1.render();
  anchor1.renderFlavourText();
  anchor2.render();
  anchor2.renderFlavourText();
}

void bezier(PVector anchor1, PVector control1, PVector control2, PVector anchor2){
  bezier(anchor1.x, anchor1.y, control1.x, control1.y, control2.x, control2.y, anchor2.x, anchor2.y);
}

void line(PVector point1, PVector point2){
  line(point1.x, point1.y, point2.x, point2.y);
}

void point(PVector point){
  point(point.x, point.y);
}

void ellipse(PVector location, float width, float height){
  ellipse(location.x, location.y, width, height);
}

void circle(PVector location, float diameter){
  ellipse(location, diameter, diameter);
}

void circle(float x, float y, float diameter){
  ellipse(x, y, diameter, diameter);
}

void mousePressed(){
  PVector mousePos = new PVector(mouseX, mouseY);
  if(control1.isIntersecting(mousePos))
    dragging = control1;
  if(control2.isIntersecting(mousePos))
    dragging = control2;
  if(anchor1.isIntersecting(mousePos))
    dragging = anchor1;
  if(anchor2.isIntersecting(mousePos))
    dragging = anchor2;
}

void mouseReleased(){
  dragging = null;
}

