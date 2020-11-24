import java.util.List;
import java.util.Collections;
import java.util.Comparator;

final int hookCount = 24;
final float speed = 6;

boolean[] inputs;

Grappler grappler;
List<Hook> hooks;

void setup(){
  size(840, 560);
  frame.setResizable(true);
  
  inputs = new boolean[4];
  
  grappler = new Grappler(new PVector(width/2, height/2),
                          30, //Core strength
                          6,  //Core mass
                          0.8, //Core drag
                          8,   //Grapple count
                          2,   //Grapple mass
                          0.8, //Grapple drag
                          16,   //Grapple strength
                          0.08,   //Grapple tension
                          12);  //Grapple grip
  hooks = new ArrayList<Hook>(hookCount);
  ensureHooks(hookCount, hooks);
  grappler.supplyHooks(hooks);
  grappler.setGravity(new PVector(0, 1));
}

void ensureHooks(int amt, List<Hook> container){
  if(container == null)
    throw new NullPointerException("Cannot put hooks into a container that is null.");
  while(container.size() < amt)
    container.add(new Hook(random(width), random(height)));
}

void replaceHooks(int amt, List<Hook> container, Grappler toInterrupt){
  container.clear();
  ensureHooks(amt, container);
  toInterrupt.replaceHooks(container);
}

void replaceHooks(int amt, List<Hook> container, List<Grappler> toInterrupt){
  for(Grappler g : toInterrupt)
    replaceHooks(amt, container, g);
}

void draw(){
  background(0);
  grappler.setTarget(getInputOffset(grappler.getCorePosition()));
  grappler.update();
  for(Hook h : hooks)
    h.render();
  grappler.render();
}

PVector getInputOffset(PVector point){
  if(inputs[0])
    point.y-=speed;
  if(inputs[1])
    point.y+=speed;
  if(inputs[2])
    point.x-=speed;
  if(inputs[3])
    point.x+=speed;
  return point;
}

boolean anyTrue(boolean[] in){
  for(boolean b : in)
    if(b) return true;
  return false;
}

void keyPressed(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          inputs[0] = true;
          break;
        case DOWN:
          inputs[1] = true;
          break;
        case LEFT:
          inputs[2] = true;
          break;
        case RIGHT:
          inputs[3] = true;
          break;
      }
      break;
    case 'w':
    case 'W':
      inputs[0] = true;
      break;
    case 's':
    case 'S':
      inputs[1] = true;
      break;
    case 'a':
    case 'A':
      inputs[2] = true;
      break;
    case 'd':
    case 'D':
      inputs[3] = true;
      break;
  }
}

void keyReleased(){
  switch(key){
    case CODED:
      switch(keyCode){
        case UP:
          inputs[0] = false;
          break;
        case DOWN:
          inputs[1] = false;
          break;
        case LEFT:
          inputs[2] = false;
          break;
        case RIGHT:
          inputs[3] = false;
          break;
      }
      break;
    case 'w':
    case 'W':
      inputs[0] = false;
      break;
    case 's':
    case 'S':
      inputs[1] = false;
      break;
    case 'a':
    case 'A':
      inputs[2] = false;
      break;
    case 'd':
    case 'D':
      inputs[3] = false;
      break;
    case ' ':
      replaceHooks(hookCount, hooks, grappler);
      break;
  }
}

