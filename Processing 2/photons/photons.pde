ArrayList<photon> photons=new ArrayList<photon>();
ArrayList<photon> toRemove=new ArrayList<photon>();
PVector gravity=new PVector(0,0.06);

float ApproximateMaximumVelocity = 50;

well Well;
well Hole;

void setup(){
  size(840,560);
  frame.setResizable(true);
  background(0);
  colorMode(HSB);
  
  Well=new well(new PVector(width/3,height/2),2,false,false);
  Hole=new well(new PVector(width/1.5,height/2),3,true,true);
  
  photons.add(new photon(new PVector(width/2,height/2),PVector.random2D(),5,1.02,false,true));
  photons.add(new photon(new PVector(width/2,height/2),PVector.random2D(),5,1.02,true,true));

  background(0);
}

void draw(){
  background(0);
//  noStroke();
//  fill(0,100);
//  rect(0,0,width,height);
  
  if(Well.dragged){
    Well.location.set(mouseX,mouseY);
  }
  
  if(Hole.dragged){
    Hole.location.set(mouseX,mouseY);
  }
  
  doPhysics();
}

void doPhysics(){
  Well.attract(photons);
  Hole.attract(photons);
  
  for(photon p : photons){
    p.update();
    p.render();
  }
  
  Well.render();
  Hole.render();
  
  photons.removeAll(toRemove);
}

boolean overCircle(float x,float y,float diameter) {
  return sqrt(sq(x-mouseX) + sq(y-mouseY)) < diameter/2;
}

void keyPressed(){
  switch(key){
    case ' ':
      photons.add(new photon(new PVector(mouseX,mouseY),PVector.random2D(),int(random(1,25)),random(1.001,1.002),random(100)>50,random(100)>50));
      break;
    
  }
}

void mousePressed(){
  if(overCircle(Well.location.x,Well.location.y,Well.size)&&!(Hole.dragged)){
    Well.dragged=true;
  }
  if(overCircle(Hole.location.x,Hole.location.y,Hole.size)&&!(Well.dragged)){
    Hole.dragged=true;
  }
}

void mouseReleased(){
  Well.dragged=false;
  Hole.dragged=false;
}


