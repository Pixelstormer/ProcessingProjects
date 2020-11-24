final PVector mouseTail = new PVector(0, 0);
final ArrayList<Arc> activeArcs = new ArrayList<Arc>();
final float castCancelLimit = 10;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
}

void draw(){
  background(0);
  for(Arc a : activeArcs){
    if(a.isFinished())
      continue;
    a.update();
    a.render();
  }
  if(mousePressed){
    stroke(255);
    strokeWeight(1);
    line(mouseTail.x, mouseTail.y, mouseX, mouseY);
  }
}

void mousePressed(){
  mouseTail.set(mouseX, mouseY);
}

void mouseReleased(){
  PVector mouseHead = new PVector(mouseX, mouseY);
  if(PVector.dist(mouseHead, mouseTail) > castCancelLimit){
    float angle = degrees(PVector.sub(mouseHead, mouseTail).normalize(null).heading());
    activeArcs.add(new Arc(mouseTail, angle, 50, new Bounds(-100, 100), new Bounds(40, 60), new Bounds(0, 1)));
  }
}

