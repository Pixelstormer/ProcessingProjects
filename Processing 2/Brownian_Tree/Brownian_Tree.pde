import java.awt.Graphics2D;
import java.awt.RenderingHints;

final int SPAWN_RANDOM = 0;
final int SPAWN_EDGES = 1;
final int SPAWN_CIRCLE = 2;
final int SPAWN_TYPE = SPAWN_EDGES;
final int SCALAR = 1;
final int X_SIZE = 840;
final int Y_SIZE = 560;
final int X_SIZE_SCALED=X_SIZE/SCALAR;
final int Y_SIZE_SCALED=Y_SIZE/SCALAR;
final int FREE_PARTICLE_LIMIT = 1200;
final int HIGHLIGHT_FRAME_DURATION = 24;
final int STEP_SIZE = 1;
final int TARGET_TREE_SIZE = 750;
final float PARTICLE_SIZE = 6;
final float PARTICLE_BOUNDS = PARTICLE_SIZE/2;
final float MOTION_HINT_MAGNITUDE = 0.05;
final float PARTICLE_SPAWNING_RADIUS = 250;
final boolean LOOPING = false;
final boolean SIMULATED = false;
final boolean LOG_ITERATION_TIME = true;
final boolean LOG_COLLISION_POSITIONS = false;
final PVector PARTICLE_COLOUR = new PVector(255,255,255);//(125,75,60);
final PVector BROWNIAN_X_MOTION = new PVector(-6,6);
final PVector BROWNIAN_Y_MOTION = new PVector(-6,6);
PGraphics renderSurface;
final ArrayList<Particle> Free = new ArrayList<Particle>(); //Free-floating particles
final ArrayList<Particle> Tree = new ArrayList<Particle>(); //Particles stuck to the tree
final ArrayList<Particle> toRemove = new ArrayList<Particle>();

boolean paused = true;

void setup(){
  size(840, 560);
  //frame.setResizable(true);
  frameRate(1000);
  
  renderSurface = createGraphics(X_SIZE_SCALED,Y_SIZE_SCALED);
  
  Tree.add(new Particle(new PVector(X_SIZE_SCALED/2,Y_SIZE_SCALED/2)));
  
  println(String.format("Initiating generation of brownian tree with the following settings:"+
    "\nSPAWN TYPE: %s"+
    "\nSCALE: %s"+
    "\nPARTICLE LIMIT: %s"+
    "\nHIGHLIGHT DURATION: %s"+
    "\nSTEP SIZE: %s"+
    "\nTARGET SIZE: %s"+
    "\nPARTICLE SIZE: %s"
  ,SPAWN_TYPE,SCALAR,FREE_PARTICLE_LIMIT,HIGHLIGHT_FRAME_DURATION,STEP_SIZE,TARGET_TREE_SIZE,PARTICLE_SIZE));
  
  println("Starting generation of tree...");
}

void draw(){
  if(!paused) {
    fillFree();
    doIterate();
  }
  
  render();
}

void fillFree(){
  while(Free.size()<FREE_PARTICLE_LIMIT){
    Free.add(generateParticle(SPAWN_TYPE));
  }
}

Particle generateParticle(int spawnMode){
  switch(spawnMode){
    case 0:
    default:
      //100% random
      return new Particle(new PVector(random(X_SIZE_SCALED),random(Y_SIZE_SCALED)));
    case 1:
      //From edges of screen
      PVector loc = new PVector(random(X_SIZE_SCALED),random(Y_SIZE_SCALED));
      float up = dist(loc.x,loc.y,loc.x,PARTICLE_SIZE);
      float down = dist(loc.x,loc.y,loc.x,Y_SIZE_SCALED+PARTICLE_SIZE);
      float left = dist(loc.x,loc.y,PARTICLE_SIZE,loc.y);
      float right = dist(loc.x,loc.y,X_SIZE_SCALED+PARTICLE_SIZE,loc.y);
      if(up<down&&up<left&&up<right){
        loc.y=-PARTICLE_SIZE;
      }
      else if(down<up&&down<left&&down<right){
        loc.y=Y_SIZE_SCALED+PARTICLE_SIZE;
      }
      else if(left<up&&left<down&&left<right){
        loc.x=-PARTICLE_SIZE;
      }
      else if(right<up&&right<down&&right<left){
        loc.x=X_SIZE_SCALED+PARTICLE_SIZE;
      }
      return new Particle(loc);
    case 2:
      //From circle around origin
      PVector angle = PVector.random2D();
      angle.setMag(PARTICLE_SPAWNING_RADIUS);
      angle.add(new PVector(X_SIZE_SCALED/2,Y_SIZE_SCALED/2));
      return new Particle(angle);
  }
}

void doIterate(){
  if(SIMULATED){
    iterate();
  }
  else{
    int oldTree = Tree.size()-1;
    int stepCount = 0;
    //int timeElapsed = millis();
    long startTime = System.nanoTime();
    while(Tree.size()<=oldTree+STEP_SIZE){
      iterate();
      stepCount++;
    }
    long endTime = System.nanoTime();
    if(LOG_ITERATION_TIME)
      println(String.format("%s iterations elapsed in ~%s nanoseconds.", stepCount, endTime - startTime));
      //println(String.format("%s iterations elapsed in ~%s milliseconds.", stepCount, millis()-timeElapsed));
  }
}

void iterate(){
  for(Particle p : Free){
    p.performNaturalMovement();
    if(p.checkForCollision(Tree)){
      Tree.add(p);
      toRemove.add(p);
      if(LOG_COLLISION_POSITIONS)
        println(String.format("Collision with tree at position (%s, %s).", int(p.getLocation().x), int(p.getLocation().y)));
    }
  }
  Free.removeAll(toRemove);
  toRemove.clear();
  if(TARGET_TREE_SIZE>0&&Tree.size()>=TARGET_TREE_SIZE){
    println(String.format("Finished generating tree: Tree has reached target size of %s with an actual size of %s.",TARGET_TREE_SIZE,Tree.size()));
    noLoop();
  }
}

void render(){
  //Graphics2D g2d = ((PGraphicsJava2D)g).g2;
  //g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_NEAREST_NEIGHBOR);
  renderSurface.beginDraw();
  renderSurface.background(0);
  
  for(Particle p : Tree){
    p.Render(renderSurface);
  }
  
  if(SIMULATED){
    for(Particle p : Free){
      p.Render(renderSurface);
    }
  }
  
  renderSurface.endDraw();
  imageMode(CENTER);
  image(renderSurface, X_SIZE/2, Y_SIZE/2, X_SIZE, Y_SIZE);
}

PVector limitToBounds(PVector input){
  if (LOOPING) {
    float nx = input.x;
    float ny = input.y;
    if (input.x<-PARTICLE_SIZE) {
      nx = X_SIZE_SCALED+PARTICLE_SIZE;
    }
    if (input.x>X_SIZE_SCALED+PARTICLE_SIZE) {
      nx = -PARTICLE_SIZE;
    }
    if (input.y<-PARTICLE_SIZE) {
      ny = Y_SIZE_SCALED+PARTICLE_SIZE;
    }
    if (input.y>Y_SIZE_SCALED+PARTICLE_SIZE) {
      ny = -PARTICLE_SIZE;
    }
    return new PVector(nx, ny);
  }
  return new PVector(constrain(input.x, PARTICLE_BOUNDS, X_SIZE_SCALED-PARTICLE_BOUNDS), constrain(input.y, PARTICLE_BOUNDS, Y_SIZE_SCALED-PARTICLE_BOUNDS));
}

void keyPressed() {
  if(key == ' ')
    paused = !paused;
}