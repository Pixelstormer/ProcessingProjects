light l;
light r;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  l=new light(width/2,height/2,120,4,color(0,255,0));
  r=new light(width/2-120,height/2,145,3,color(255,0,0));
  
  noStroke();
  background(0);
}

void draw(){
  background(0);
  
  r.render();
  l.render();
}

void mousePressed(){
  r.x=mouseX;
  r.y=mouseY;
}
