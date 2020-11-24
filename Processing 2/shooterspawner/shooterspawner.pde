Player player;
ArrayList<Projectile> projectiles;

Spawner spawner;

Melee unit;

HashMap<Integer, Boolean> inputs;

void setup() {
  size(840, 560);
  frame.setResizable(true);

  inputs = new HashMap<Integer, Boolean>(4);
  projectiles = new ArrayList<Projectile>();

  player = new Player(new PVector(width/2, height/2));
  
  unit = new Melee(new PVector(width/1.2, height/2));
}

void draw() {
  background(0);
  player.move();
  player.shoot();
  
  unit.move();
  
  ArrayList<Projectile> toRemove = new ArrayList<Projectile>();
  for(Projectile p : projectiles){
    p.move();
    if(p.isOutOfBounds()){
      toRemove.add(p);
    }
    p.render();
  }
  projectiles.removeAll(toRemove);
  
  unit.render();
  
  player.render();
}

boolean getInput(char Char){
  return getInput(int(Character.toLowerCase(Char))) || getInput(int(Character.toUpperCase(Char)));
}

boolean getInput(int in){
  return inputs.get(in) != null && inputs.get(in);
}

void keyPressed() {
  if (key == CODED) {
    inputs.put(keyCode, true);
    println(char(keyCode));
  } else {
    inputs.put(int(key), true);
  }
}

void keyReleased() {
  if (key == CODED) {
    inputs.put(keyCode, false);
  } else {
    inputs.put(int(key), false);
  }
}

void mousePressed(){
  inputs.put(mouseButton, true);
}

void mouseReleased(){
  inputs.put(mouseButton, false);
}


