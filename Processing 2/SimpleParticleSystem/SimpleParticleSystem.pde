ParticleSystem ps;

void setup() {
  size(840,560);
  frame.setResizable(true);
  noStroke();
  ps = new ParticleSystem(new PVector(width/2,height/2));
}

void draw() {
  background(0);
//  ps.addParticle();
  ps.run();
  
  fill(255);
  text(frameRate,4,15);
}

void mousePressed(){
  ps.addParticle();
}
