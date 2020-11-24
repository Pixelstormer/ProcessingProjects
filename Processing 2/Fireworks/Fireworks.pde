void setup(){
  size(840,560);
  frame.setResizable(true);
    
  activeRockets = new ArrayList<Firework>();
  rocketsToRemove = new ArrayList<Firework>();
  
  activeParticles = new ArrayList<Particle>();
  particlesToRemove = new ArrayList<Particle>();
  
  l = new Launcher(new PVector(width/2,height-45),1000);
  
  rectMode(CENTER);
  noFill();
  background(0);
  
  deltaTime = 0;
  doDeltaTime();
}

void draw(){
  doDeltaTime();
  deltaTime/=1000;
  background(0);
  
  updateLauncher();
  
  updateFireworks();
  
  updateParticles();
  
  l.render();
}

void updateLauncher(){
  l.move(new PVector(width/2,height-45));
  l.update();
}

void updateFireworks(){
  for(Firework r : activeRockets){
    r.update();
  }
  activeRockets.removeAll(rocketsToRemove);
}

void updateParticles(){
  for(Particle p : activeParticles){
    p.update();
    p.render();
  }
  activeParticles.removeAll(particlesToRemove);
}

void doDeltaTime(){
  deltaTime = millis() - deltaTimer;
  deltaTimer = millis();
}

void mousePressed(){
  activeRockets.add(new Firework(new PVector(mouseX,mouseY)));
}

void mouseReleased(){
  activeRockets.add(new Firework(new PVector(mouseX,mouseY)));
}

