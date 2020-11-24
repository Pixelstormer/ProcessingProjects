float x=mouseX;
float y=mouseY;
float ease=0.03;
int fade=255;
boolean pulse=false;
int cx=200;
int cy=200;

void setup(){
  size(640,480);
  stroke(255);
}

void draw(){
  fill(0,fade);
  rect(0,0,width,height);
  stroke(255);
    
  x=lerp(x,mouseX,ease);
  y=lerp(y,mouseY,ease);
  ellipse(x,y,20,20);
  
  noFill();
  ellipse(cx,cy,15,15);
  
  PVector mouse=new PVector(x,y);
  PVector pointer=new PVector(200,200);
  
  mouse.sub(pointer);
  mouse.normalize();
  mouse.mult(40);
  
  pushMatrix();
  translate(200,200);
  line(0,0,mouse.x,mouse.y);
  stroke(100,200);
  mouse.mult(20);
  line(0,0,mouse.x,mouse.y);
  popMatrix();
}
