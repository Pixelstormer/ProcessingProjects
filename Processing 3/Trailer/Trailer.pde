ArrayList<Unit> activeUnits;

void setup() {
  size(800, 600, P2D);
  activeUnits = new ArrayList<Unit>();
  surface.setResizable(true);
  activeUnits.add(new Unit());
}

void draw() {
  background(0);
  for(Unit u : activeUnits){
    u.draw();
  }
}

void mousePressed(){
  switch(mouseButton){
    case LEFT:
      activeUnits.add(new Unit());
      break;
    case RIGHT:
      if(activeUnits.size() > 0) activeUnits.remove(activeUnits.size()-1);
      break;
  }
}