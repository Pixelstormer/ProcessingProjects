int dustAmount = 360;
PVector windRange = new PVector(0.06,0.25);
PVector dustSizeRange = new PVector(0.1,2);
PVector opacityRange = new PVector(80,255);
PVector dispersionRange = new PVector(50,400);
PVector offsetRange = new PVector(-2,2);
ArrayList<dustParticle> Dust;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  InitialiseDust();
  
  stroke(255);
  strokeWeight(1);
  strokeCap(ROUND);
  noFill();
  noCursor();
  background(0);
}

void draw(){
  background(0);
  PVector Center = new PVector(width/2,height/2);
  PVector Mouse = new PVector(mouseX,mouseY);
  PVector Wind = PVector.sub(Mouse,Center);
  
  for(dustParticle p : Dust){
    p.applyWind(Wind);
    p.render();
    p.checkBoundries();
  }
}

void InitialiseDust(){
  Dust = new ArrayList<dustParticle>();
  for(int i=0;i<dustAmount;i++){
    Dust.add(new dustParticle(
             new PVector(random(width),random(height)),
             new PVector(random(offsetRange.x,offsetRange.y),random(offsetRange.x,offsetRange.y)),
             random(dustSizeRange.x,dustSizeRange.y),
             random(windRange.x,windRange.y),
             random(opacityRange.x,opacityRange.y),
             random(dispersionRange.x,dispersionRange.y)
    ));
  }
}

void keyPressed(){
  InitialiseDust();
}