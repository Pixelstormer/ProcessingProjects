ArrayList<particle> particles = new ArrayList<particle>();
ArrayList<particle> toRemove = new ArrayList<particle>();

void setup(){
  size(840,560);
  frame.setResizable(true);
  background(0);
  noStroke();
}

void draw(){
//  background(0);
  fill(0,32);
  rect(0,0,width,height);
  noStroke();
  if(mousePressed){
    particles.add(new particle(new PVector(mouseX,mouseY),PVector.random2D(),random(8),random(0.5),random(240),ceil(random(4)),color(random(255),random(255),random(255)),random(100)>50,random(120),random(100)>50));
  }
  
  for(particle p : particles){
    p.update();
    p.render();
    p.subParticles.removeAll(toRemove);
  }
  for(particle p : toRemove){
    particles.addAll(p.subParticles);
    p.subParticles.clear();
  }
  particles.removeAll(toRemove);
  toRemove.clear();
}


