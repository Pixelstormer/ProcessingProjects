PVector arrow,currentM,lastM;

PVector p,v,a;

void setup(){
  size(640,580);
  surface.setResizable(true);
  
  noFill();
  stroke(255);
  strokeWeight(3);
  arrow = new PVector(0,0);
  currentM=new PVector(0,0);
  lastM=new PVector(0,0);
  
  v=new PVector(0,0);
  a=new PVector(0,0);
  p=new PVector(random(width),random(height));
}

void draw(){
  background(0);
  translate(mouseX,mouseY);
  noCursor();
  
  updateVectors();
  
  drawArrow();
  resetMatrix();
  translate(width/2,height/2);
  drawArrow();
  
  doPhysics();
}

void updateVectors(){
  currentM = new PVector(mouseX, mouseY);
  lastM = new PVector(pmouseX, pmouseY);
  arrow = PVector.sub(currentM,lastM);
}

void drawArrow(){
  line(0,0,arrow.x,arrow.y);
  
  translate(arrow.x,arrow.y);
  PVector pointer = PVector.sub(lastM,currentM);
  pointer.setMag(8);
  
  pointer.rotate(radians(45));
  line(0,0,pointer.x,pointer.y);
  pointer.rotate(radians(-90));
  line(0,0,pointer.x,pointer.y);
}

void doPhysics(){
  resetMatrix();
  
  a.setMag(0);
  PVector d=arrow.copy();
  d.mult(0.1);
  a.add(d);
  v.add(a);
  v.div(1.2);
  p.add(v);
  float x=p.x;
  float y=p.y;
  p.x = constrain(p.x,0,width);
  p.y = constrain(p.y,0,height);
  if(x!=p.x||y!=p.y){
    v.setMag(0);
  }
  
  point(p.x,p.y);
  ellipse(p.x,p.y,15,15);
}