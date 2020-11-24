ArrayList<splash> ripples=new ArrayList<splash>();
ArrayList<splash> toRemove=new ArrayList<splash>();
float time;

void setup(){
  size(300,300);
  frame.setResizable(true);
//  rectMode(CENTER);
  
  strokeWeight(2);
  noFill();
}

void draw(){
  background(80,80,200);
  
  for(splash s : ripples){
    s.render();
    
    if(s.life>255){
      toRemove.add(s);
    }
  }
  
  ripples.removeAll(toRemove);
  time+=0.02;
}

void mousePressed(){
  ripples.add(new splash(mouseX,mouseY,random(40,140)));
}

void mouseDragged(){
  ripples.add(new splash(mouseX,mouseY,random(40,100)));
}

void keyPressed(){
  switch(key){
    case ' ':
      ripples.add(new splash(random(width),random(height),random(10,80)));
  }
}
