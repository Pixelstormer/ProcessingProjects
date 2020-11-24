ArrayList<atom> particles;
int fill=255;

void setup() {
  size(1024, 320);
  noStroke();
  rectMode(CENTER);
  frame.setResizable(true);
  
  particles = new ArrayList<atom>();
  
  particles.add(new atom(48,-10,1,height/4,false,false,true,false));
  particles.add(new atom(16,1,2,height/2,true,true,false,true));
  particles.add(new atom(24,61,1.5,height/1.25,true,true,true,false));
  background(0);
}

void draw() {  
  fill(0,fill);
  rect(width/2,height/2,width,height);
  
  for(atom a : particles){
    a.update();
  }
}

void mousePressed(){
  background(0);
}

boolean overCircle(int x, int y, int diameter,float targx,float targy) {
  float disX = x - targx;
  float disY = y - targy;
  if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
    return true;
  } else {
    return false;
  }
}

