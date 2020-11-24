import java.util.Map.Entry;
import java.awt.Graphics2D;
import java.awt.RenderingHints;

//Number of milliseconds between each iteration
final int STEP_INTERVAL = 250;
//Number of steps each iteration actually performs
final int STEP_SIZE = 1;
//Visual scalar for render surface onto real surface
final int SCALAR = 4;
//Time since last step
int STEP_TIME = 0;
//Is it running iterations?
boolean RUNNING = false;
//Real window width in pixels
int X_SIZE = 840;
//Real window height in pixels
int Y_SIZE = 560;
//Scaled window width of render surface in pixels
int X_SIZE_SCALED=X_SIZE/SCALAR;
//Scaled window height of render surface in pixels
int Y_SIZE_SCALED=Y_SIZE/SCALAR;
//PGraphics object used for rendering
PGraphics renderSurface;

HashMap<PVector,Cell> CellSpace;
ArrayList<Reaction> parsedRuleset;

/*
A more 'traditional' Cellular Automaton that uses static cells with neighbourhoods
Uses the Moore neighbourhood

Has a highly versatile programmable ruleset
Cells can at any given point in time be in any 1 of the states: 0,1,2,3,4,5,6,7,8,9
Each state reacts differently to different neighbours in different states
The ruleset must contain one 'default' reaction which is used for any reaction that is not explicitly defined in the ruleset

STATE 0 IS TREATED AS EQUIVALENT TO BEING NULL: ALL TILES START AS A CELL IN STATE 0 (CELLSPACE STARTS WITH 0 ENTRIES: EVERY LOCATION IS 'NULL' OR 'STATE 0')

Reactions need not be specified for states that will never be achieved

IF MORE THAN ONE REACTION IS VALID FOR A CELL THE CELL WILL UNDERGO THE REACTION SPECIFIED FURTHEST TO THE RIGHT IN THE RULESET

RULESET FORMAT
The ruleset consists of a list of reactions
Each reaction is a set of characters
The first character is an integer representing the current state of the cell in question
The last number is an integer representing the state the cell will be in after the reaction
Inbetween these are sets of 3 characters representing the neighbours:
  For each of these 3 sets:
    The first character is an integer that represents the target number of neighbours
    The second character is either '<', '=' or '>', representing 'less than' 'equal to' and 'more than'
    The third character is an integer representing the state of the neighbours

THE REACTION WILL BE VALID IF:
  The target cell's state is equal to the first character
  For every neighbour set:
    The number of neighbours around the target cell who's states are equal to the third character:
      Is 'less than'/'equal to'/'more than' the first character, DEPENDING ON THE IF THE SECOND CHARACTER IS '<'/'='/'>'

EXAMPLE: CONWAY'S GAME OF LIFE
  In Conway's Game of Life, cells have two states: 0 or 'dead' and 1 or 'alive'
  'Dead' cells have 1 reaction:
    To become 'alive' if they have exactly 3 'alive' neighbours
  'Alive' cells have 4 reactions:
    To become 'dead' if they have less than 2 'alive' neighbours
    To become 'alive' if they have exactly 2 neighbours
    To become 'alive' if they have exactly 3 neighbours
    To become 'dead' if they have more than 3 neighbours
  Knowing this, we can create a ruleset that represents this behaviour:
  03=1112<1013>10
  When it's all together it can look quite confusing, so we can split this up into the individual reactions:
  03=11 12<10 13>10
  
  '03=11' represents the reaction for 'dead' cells.
  The first character is a '0' - meaning this reaction only happens for cells that are in state 0, or 'dead'
  The last character is a '1' - meaning cells that undergoe this reaction will end up in state 1, or 'alive'
  In between these are the characters '3=1' - meaning the reaction happens if '3' neighbours are 'equal' to state '1' (alive)
*/

final String RULESET_CONWAYS_GAME_OF_LIFE = "03=1112<1013>10";
final String RULESET_WIREWORLD = "00=9010=9220=9331=1132=11";
final String RULESET = RULESET_WIREWORLD;

int NUM_STATES = -1;

void setup(){
  size(840, 560);
  //Attempt to achieve maximum possible framerate,
  //so that STEP_INTERVAL can be checked as frequently as possible
  //(In case of very low values).
  frameRate(Integer.MAX_VALUE);
  frame.setResizable(true);
  setupSurface();
  
  initSpace();
  initRuleset();
  
  //Used for detecting window size changes to rescaled render surface size appropriately
  registerMethod("pre", this);
}

void draw(){
  doIterate();
  render();
}

void doIterate(){
  //Call iterate the number of times specified by STEP_SIZE
  if(RUNNING && millis()-STEP_INTERVAL>STEP_TIME){
    for(int i=0;i<STEP_SIZE;i++){
      iterate();
    }
    STEP_TIME=millis();
  }
}

void iterate(){
//  //What CellSpace will look like at the end of this iteration
//  HashMap<PVector,Cell> nextIteration = new HashMap<PVector,Cell>();
//  //Non-existent cells that have at least one neighbour and thus need checking for if they would come alive
//  HashMap<PVector,Cell> toManualCheck = new HashMap<PVector,Cell>();
//  for(Entry<PVector,Cell> e : CellSpace.entrySet()){
//    HashMap<PVector,Cell> Neighbours = new HashMap<PVector,Cell>();
//    for(int x=-1;x<=1;x++){
//      for(int y=-1;y<=1;y++){
//        if(x!=0||y!=0){
//          Cell c = CellSpace.get(PVector.add(e.getKey(),new PVector(x,y)));
//          Neighbours.put(new PVector(x,y),(c==null)?new Cell():c);
//          if(c==null){
//            Neighbours.put(new PVector(x,y),new Cell());
//            toManualCheck.put(PVector.add(e.getKey(),new PVector(x,y)),new Cell());
//          }
//          else{
//            Neighbours.put(new PVector(x,y),c);
//          }
//        }
//      }
//    }
//    nextIteration.put(e.getKey().get(),new Cell(e.getValue().updateState(Neighbours)));
//  }
//  CellSpace.putAll(nextIteration);
  CellSpace.putAll(genericCellIterate(CellSpace,true));
}

HashMap<PVector,Cell> genericCellIterate(HashMap<PVector,Cell> target, boolean disruptive){
  //'disruptive' causes this to 'wake up' inactive neighbouring cells (Cells that are null in target array are replaced with a Cell in state 0)
  HashMap<PVector,Cell> disrupted = new HashMap<PVector,Cell>();
  HashMap<PVector,Cell> CompletedIteration = new HashMap<PVector,Cell>();
  for(Entry<PVector,Cell> e : target.entrySet()){
    HashMap<PVector,Cell> Neighbours = new HashMap<PVector,Cell>();
    for(int x=-1;x<=1;x++){
      for(int y=-1;y<=1;y++){
        if(x!=0||y!=0){
          Cell c = target.get(PVector.add(e.getKey(),new PVector(x,y)));
          if(c==null){
            Neighbours.put(new PVector(x,y),new Cell());
            if(disruptive && e.getValue().getState()!=0){
              disrupted.put(PVector.add(e.getKey(),new PVector(x,y)),new Cell());
            }
          }
          else{
            if(disruptive){
              disrupted.put(PVector.add(e.getKey(),new PVector(x,y)),c);
            }
            Neighbours.put(new PVector(x,y),c);
          }
        }
      }
    }
    CompletedIteration.put(e.getKey().get(),new Cell(e.getValue().speculativeUpdateState(Neighbours)));
  }
  if(disruptive){
    CompletedIteration.putAll(genericCellIterate(disrupted,false));
  }
  return CompletedIteration;
}

void render(){
  //Prevent blurryness caused by anti-aliasing
  Graphics2D g2d = ((PGraphicsJava2D)g).g2;
  g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_NEAREST_NEIGHBOR);
  renderSurface.beginDraw();
  renderSurface.background(0);
  renderSurface.noStroke();
  renderSurface.colorMode(HSB);
  
  for(Entry<PVector,Cell> e : CellSpace.entrySet()){
    PVector RenderColour = e.getValue().getRenderColour();
    renderSurface.fill(RenderColour.x,RenderColour.y,RenderColour.z);
    renderSurface.rect(e.getKey().x,e.getKey().y,1,1);
  }
  
  renderSurface.endDraw();
  imageMode(CENTER);
  image(renderSurface, width/2, height/2, width, height);
}

void setupSurface(){
  renderSurface = createGraphics(X_SIZE_SCALED,Y_SIZE_SCALED);
}

void initSpace(){
  CellSpace = new HashMap<PVector,Cell>();
}

void initRuleset(){
  parsedRuleset = new ArrayList<Reaction>();
  for(int i=0;i<RULESET.length();i+=5){
    parsedRuleset.add(new Reaction(RULESET.substring(i, Math.min(RULESET.length(), i + 5))));
  }
}

String getRelativeNeighbourhood(HashMap<PVector,Cell> Neighbourhood){
  String total = "\n";
  for(int y=-1;y<=1;y++){
    for(int x=-1;x<=1;x++){
      if(Neighbourhood.get(new PVector(x,y))!=null){
        total+=Neighbourhood.get(new PVector(x,y)).toString();
      }
      else{
        total+="   ";
      }
    }
    total+="\n";
  }
  return total;
}

void pre(){
  //Check for window size changes
  if (X_SIZE != width || Y_SIZE != height) {
    //If so, adjust variables accordingly and recreate the render surface according to the new size
    X_SIZE = width;
    Y_SIZE = height;
    X_SIZE_SCALED = X_SIZE/SCALAR + 1;
    Y_SIZE_SCALED = Y_SIZE/SCALAR + 1;
    setupSurface();
  }
}

int charToInt(char Char){
  return int(str(Char));
}

void placeDrag(int button){
  PVector mouse = new PVector(mouseX/SCALAR,mouseY/SCALAR);
  PVector old = new PVector(pmouseX/SCALAR,pmouseY/SCALAR);
  PVector iter = PVector.sub(mouse,old);
  iter.setMag(0.1);
  for(PVector p = old.get();PVector.dist(p,mouse)>0.1;p.add(iter)){
    place(button,p);
  }
}

void place(int button, PVector loc){
  PVector rounded = new PVector(int(loc.x),int(loc.y));
  switch(button){
    case LEFT:
      CellSpace.put(rounded,new Cell(3));
      break;
    case RIGHT:
      CellSpace.put(rounded,new Cell(1));
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
  if(key==' '){
    RUNNING = !RUNNING;
  }
}