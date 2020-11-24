import java.util.List;
import java.util.Arrays;

List<Snake> Snakes;
PVector mouse;
PVector center;
final int DEFAULT_LENGTH = 12;
final float SEGMENT_DIAMETER = 12;
final float MIN_TURN_ANGLE = 0;
final float MAX_TURN_ANGLE = 18;
final float GRAVITY_MAG = 2;
final float GRAVITY_ANGLE = 90;
final float NATURAL_DRAG = 0.9;
final float NATURAL_FRICTION = 0.9;
final float SLEEP_TOLERANCE = 0.1;
final float FUDGE_TOLERANCE = 0.1;
final float PULL_FORCE = 2.8;
final float MOVE_FORCE = 0.6;
final float DEFAULT_WEIGHT = 1;
final PVector POSITIVE_INDENT = new PVector(1,1);
final PVector NEGATIVE_INDENT = new PVector(2,2);

boolean[] inputs = new boolean[4];

void setup(){
  size(840,560);
  frame.setResizable(true);
  initVars();
}

void initVars(){
  Snakes = new ArrayList<Snake>();
  updateMouse();
  updateCenter();
  
  Snakes.add(new Snake(DEFAULT_LENGTH,center));
}

void draw(){
  preUpdate();
  update();
  postUpdate();
}

void preUpdate(){
  updateMouse();
  updateCenter();
  background(0);
}

void update(){
  for(int i=0;i<Snakes.size();i++){
    List<Snake> toCollide = Snakes.subList(i,Snakes.size());
    Snakes.get(i).iteratePhysics(toCollide);
    Snakes.get(i).Render();
  }
}

void postUpdate(){
  
}

void updateMouse(){
  mouse = new PVector(mouseX,mouseY);
}

void updateCenter(){
  center = new PVector(width/2,height/2);
}

PVector GRAVITY(){
  PVector g = PVector.fromAngle(radians(GRAVITY_ANGLE));
  g.setMag(GRAVITY_MAG);
  return g;
}

void keyPressed(){
  switch(key){
    case 'a':
    case 'A':
    inputs[0] = true;
    break;
    case 'd':
    case 'D':
    inputs[1] = true;
    break;
    case 's':
    case 'S':
    inputs[2] = true;
    break;
    case 'w':
    case 'W':
    inputs[3] = true;
    break;
  }
}

void keyReleased(){
  switch(key){
    case 'a':
    case 'A':
    inputs[0] = false;
    break;
    case 'd':
    case 'D':
    inputs[1] = false;
    break;
    case 's':
    case 'S':
    inputs[2] = false;
    break;
    case 'w':
    case 'W':
    inputs[3] = false;
    break;
    default:
      Snakes.add(new Snake(DEFAULT_LENGTH,mouse));
  }
}
