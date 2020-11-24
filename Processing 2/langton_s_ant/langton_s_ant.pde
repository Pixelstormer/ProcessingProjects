import java.util.Map.Entry;
import java.awt.Graphics2D;
import java.awt.RenderingHints;

final float STEP_INTERVAL = 0;
final int STEP_SIZE = 1;
final int SCALAR = 4;
int X_SIZE = 840;
int Y_SIZE = 560;
int X_SIZE_SCALED=X_SIZE/SCALAR;
int Y_SIZE_SCALED=Y_SIZE/SCALAR;
PGraphics renderSurface;

HashMap<PVector,tile> space;
HashMap<PVector,ant> ants;

int STEP_TIME;

void setup(){
  size(X_SIZE,Y_SIZE);
  frameRate(1000);
  frame.setResizable(true);
  setupSurface();
  
  STEP_TIME = 0;
  
  space = new HashMap<PVector,tile>();
  ants = new HashMap<PVector,ant>();
  
  registerMethod("pre", this);
  thread("doIterate");
}

void draw(){
  //println(frameRate);
  //iterate();
  render();  
}

void doIterate(){
  while(true){
    if(millis()-STEP_INTERVAL>STEP_TIME){
      for(int i=0;i<STEP_SIZE;i++){
        iterate();
      }
      STEP_TIME=millis();
    }
  }
}

void setupSurface(){
  renderSurface = createGraphics(X_SIZE_SCALED,Y_SIZE_SCALED);
}

void pre(){
  if (X_SIZE != width || Y_SIZE != height) {
    X_SIZE = width;
    Y_SIZE = height;
    X_SIZE_SCALED = X_SIZE/SCALAR;
    Y_SIZE_SCALED = Y_SIZE/SCALAR;
    setupSurface();
  }
}

synchronized void iterate(){
  HashMap<PVector,ant> newState = new HashMap<PVector,ant>();
  for(Entry<PVector,ant> e : ants.entrySet()){
    PVector dir = ((ant) e.getValue()).iterate(space.get(e.getKey()));
    PVector newLoc = PVector.add(dir,e.getKey());
    newState.put(newLoc,e.getValue());
    flip(e.getKey());
  }
  ants.clear();
  ants.putAll(newState);
}

synchronized void render(){
  Graphics2D g2d = ((PGraphicsJava2D)g).g2;
  g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_NEAREST_NEIGHBOR);
  renderSurface.beginDraw();
  renderSurface.background(0);
  for(Entry<PVector,tile> t : space.entrySet()){
    renderSubject(t.getKey(),(point)t.getValue(),renderSurface);
  }
  for(Entry<PVector,ant> a : ants.entrySet()){
    renderSubject(a.getKey(),(ant)a.getValue(),renderSurface);
  }
  renderSurface.endDraw();
  imageMode(CENTER);
  image(renderSurface, width/2, height/2, width, height);
}

synchronized void renderSubject(PVector location, point target, PGraphics surface){
  target.render(location,surface);
}

synchronized void flip(PVector target){
  if(space.get(target)==null){
    space.put(target,new tile());
  }
  else{
    space.remove(target);
  }
}

synchronized void placeDrag(int button){
  PVector mouse = new PVector(mouseX/SCALAR,mouseY/SCALAR);
  PVector old = new PVector(pmouseX/SCALAR,pmouseY/SCALAR);
  PVector iter = PVector.sub(mouse,old);
  iter.setMag(0.1);
  for(PVector p = old.get();PVector.dist(p,mouse)>0.1;p.add(iter)){
    place(button,p);
  }
}

synchronized void place(int button, PVector loc){
  PVector rounded = new PVector(int(loc.x),int(loc.y));
  switch(button){
    case LEFT:
      space.put(rounded,new tile());
      break;
    case RIGHT:
      space.remove(rounded);
      break;
    case ' ':
      ants.put(rounded,new ant());
      break;
  }
}

void mousePressed(){
  place(mouseButton,new PVector(mouseX/SCALAR,mouseY/SCALAR));
}

void mouseDragged(){
  placeDrag(mouseButton);
}

void keyPressed(){
  place(key, new PVector(mouseX/SCALAR,mouseY/SCALAR));
}
