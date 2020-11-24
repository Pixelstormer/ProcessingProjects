import java.util.Map.Entry;
import java.awt.Graphics2D;
import java.awt.RenderingHints;

//Number of milliseconds between each iteration
final int STEP_INTERVAL = 0;
//Number of steps each iteration actually performs
final int STEP_SIZE = 1;
//Visual scalar for render surface onto real surface
final int SCALAR = 4;
//Time since last step
int STEP_TIME = 0;
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

/*
'Chromites' Cellular Automaton

Has some similar behaviours to 'Absolute Turmites':
https://en.wikipedia.org/wiki/Turmite#Relative_vs._absolute_turmites

The name 'Chromites' is derived from a combination of 'Turmites' and 'Chromatic', given the automatic colour generation (Visualisation) it features.

Uses 2D space with 2 distinct 'grids':
  The cells, which can move, change state and interact with world space
  World space, which is composed of tiles that do not interact but can take on different states
  Cells can be imagined as being 'above' the world space, moving across it and interacting with it
  Cells cannot directly interact with eachother, but can interact via the changes they make to world space
  Depending on the state that a cell is in, it reacts differently world space

Each iteration a cell can do 3 things:
  Move to any 1 of 8 neighbouring cells, or do not move at all
  Change the state of the world space tile it is on
  Change its own state
  
Note: Cells do not have any information about neighbouring tiles, and only react to the tile they are currently on.

An iteration goes as follows:
  For each cell:
    The cell gets the state of the world space tile it is on
    Depending on the state of that tile, it will then do any combination of the 3 possible actions listed above, according to the ruleset

Note: Two cells can be on the same tile but in different states and thus act differently.

A ruleset must contain information that includes:
  For each possible state a tile can be in:
    For each possible state a cell on that tile can be in:
      Information about the action(s) that cell will take, which include:
        Changing the state of the tile the cell is on
        Changing the cell's own state
        Moving to one of 8 neighbouring tiles

To represent this information:
  The change of the state of a tile can be represented by an integer which indicates the new state of that tile
    This integer can be from 0 to the maximum number of tile states
  The change of the state of a cell can be represented by an integer which indicates the new state of that cell
    This integer can be from 0 to the maximum number of cell states
  To move to 1 of 8 neighbouring cells, or to not move at all, can be represented by any 1 of a set of 9 arbitrary characters
    Each of these 9 characters represent one of the 8 possible directions, with 1 extra to represent no movement

  Note: The number of tile states and cell states can? be assumed from the largest given value for those attributes
    To ensure this is possible the ruleset must list tile states and cell states linearly with an increment of 1 - no 'skipped' numbers
  
Each of the 8 possible movement directions will be represented by the following characters, inspired by the keypad on a keyboard:
  LEFT (-1,0): '4'
  RIGHT (1,0): '6'
  UP   (0,-1): '8'
  DOWN  (0,1): '2'
  L+U (-1,-1): '7'
  L+D  (-1,1): '1'
  R+U  (1,-1): '9'
  R+D   (1,1): '3'
  NONE  (0,0): '5'
  
  As the keypad in question is in the following format:
  7 8 9
  4 5 6
  1 2 3
  You may see how each number could represent a possible movement.

A ruleset must follow a few rules:
  It will always and only contain the digits '0123456789'
  And it will always follow the format 'xabcdabcdxabcdabcd...' such that:
      x = state of tile
      a = state of cell
      b = new state of tile
      c = new state of cell
      d = movement
    The first digit will always be an 'x'
    There will always be an equal number of 'abcd's between each x
    The last digit will always be a 'd'
    There will be no repeated 'a's between each 'x'
    There will be no 'b's that hold a value that is not also held by at least one 'x'
    There will be no 'c's that hold a value that is not also held by at least one 'a'
    All 'd's will hold one of the following values: '123456789'
    Each 'x' and each 'a' must only increment by exactly 1 relative to the previous 'x' or 'a'
 
AN EXAMPLE: To emulate Langton's Ant
2 states for tiles: 'on' or 'off'
Cells have to have a state for every previous movement:
  Last move was UP: Next move (+state) is either RIGHT or LEFT depending on state of tile
  Last move was DOWN: Next move (+state) is either RIGHT or LEFT depending on state of tile
  Last move was LEFT: Next move (+state) is either UP or DOWN depending on state of tile
  Last move was RIGHT: Next move (+state) is either UP or DOWN depending on state of tile
This is needed to emulate how Langton's ant keeps track of it's 'direction'
Each of the two tile states has four cell states for each direction
Tile state 1 'off': 'turn' to the RIGHT
Tile state 2 'on': 'turn' to the LEFT
Cell state 1: Last move was UP
Cell state 2: Last move was DOWN
Cell state 3: Last move was LEFT
Cell state 4: Last move was RIGHT */

final String RULESET_LANGTONS_ANT = "0013611242108311210024103620123008";
//                                  "xabcdabcdabcdabcdxabcdabcdabcdabcd"
//The two Xs are the two states of each tile - 'on' or 'off;
//Each state has four As - state of the cell - to represent each of the 4 possible directions
//As the Ant always flips the tile, the Bs - new state of the tile - will be the opposite of the X
//The new state of the cell Cs represent a way to store information about previous moves
//The movement Ds serve as the way to actually move the cell around

//Cells keep track of their own location, as two cells in different states can exist on the same tile
ArrayList<Cell> CellSpace;

//We use a hashmap instead of an array for worldspace
//as the majority of tiles will remain untouched, so there is no need to iterate over them
HashMap<PVector,Tile> WorldSpace;

final String RULESET_BOX = "0011211262138310410118112421323106";
//Quickly lays out a small box before getting stuck in an infinite loop.

final String RULESET_DIAGONAL_ANT = "0013911212107311310021103920133007";
//Identical in function to the Langton's Ant, but using diagonal movement.

final String RULESET_STILL = "00005";
//One of the simplest possible rulesets. Sits in place and does nothing.

final String RULESET_EXPANSION = "";
/*
Bottom Edge movement loop:
* = fill
1 = edge
o = empty
% = cell

* * *  * * *  * * *  * * *  * * *  * * *  * * *  * * *
1 1 1  % 1 1  * 1 1  * % 1  * * 1  * * %  * * *  * * * 
o o o  o o o  % o o  1 o o  1 % o  1 1 o  1 1 %  1 1 1 
  1      2      3      4      5      6      7      8

1: Before the cell enters
2: Cell enters along the edge
3: Cell moves down and converts edge to fill
4: Cell moves up and right and converts empty to edge, finishing back on the next edge tile
5-8: The process repeats itself.

Loop is same for other Edges, but directions are rotated for each Edge
Loop effect is 'pushing' the edge out by 1 tile

~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

Bottom edge -> Right edge Corner-turning movement:
* = fill
1 = edge
o = empty
% = cell

* * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 %  * * % 1  * * * 1  
* * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 o  * * 1 %  * * % 1  * * * 1  * * * 1  * * * 1  
1 1 o o  % 1 o o  * 1 o o  * % o o  * * o o  * * % o  * * 1 o  * * 1 %  * * % 1  * * * 1  * * * 1  * * * 1  * * * 1  * * * 1  
o o o o  o o o o  % o o o  1 o o o  1 % o o  1 1 o o  1 1 % o  1 1 1 o  1 1 1 o  1 1 1 o  1 1 1 o  1 1 1 o  1 1 1 o  1 1 1 o   
   1        2        3        4        5        6        7        8        9       10       11       12       13       14

1: The corner before the cell enters
2: The cell enters along the edge
3-5: The cell performs the normal 'edge-expansion'
6: The cell finds an 'o' instead of a '1' when attempting to repeat the edge-expansion, indicating it has reached the corner
7: The cell continues with its edge-expansion, but in a 'volatile' state
8: The volatile state expires and places the cell in a new 'rotated' state
9-14: The new 'rotated' state performs the same edge-expansion but along a different axis

There exists a different mirrored edge-expansion and corner-turning states for each orientation
Some states could be reused to shorten the ruleset, assuming the cell will not encounter any unexpected tile conditions
*/

final String RULESET = RULESET_DIAGONAL_ANT;
int NUM_INSTRUCTIONS = -1;
int NUM_TILES = -1;

void setup(){
  size(X_SIZE,Y_SIZE);
  //Attempt to achieve maximum possible framerate,
  //so that STEP_INTERVAL can be checked as frequently as possible
  //(In case of very low values).
  frameRate(Integer.MAX_VALUE);
  frame.setResizable(true);
  setupSurface();
  
  initSpace();
  
  //Used for detecting window size changes to rescaled render surface size appropriately
  registerMethod("pre", this);
}

void draw(){
  doIterate();
  render();
}

void doIterate(){
  //Call iterate the number of times specified by STEP_SIZE
  if(millis()-STEP_INTERVAL>STEP_TIME){
    for(int i=0;i<STEP_SIZE;i++){
      iterate();
    }
    STEP_TIME=millis();
  }
}

void iterate(){
  for(Cell c : CellSpace){
    if(WorldSpace.get(c.getLocation())==null){
      WorldSpace.put(c.getLocation().get(),new Tile());
    }
    WorldSpace.get(c.getLocation()).setState(c.performAction(WorldSpace.get(c.getLocation())));
  }
}

void render(){
  //Prevent blurryness caused by anti-aliasing
  Graphics2D g2d = ((PGraphicsJava2D)g).g2;
  g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_NEAREST_NEIGHBOR);
  renderSurface.beginDraw();
  renderSurface.background(0);
  renderSurface.noStroke();
  renderSurface.colorMode(HSB);
  
  for(Entry<PVector,Tile> e : WorldSpace.entrySet()){
    PVector RenderColour = e.getValue().getRenderColour();
    renderSurface.fill(RenderColour.x,RenderColour.y,RenderColour.z);
    renderSurface.rect(e.getKey().x,e.getKey().y,1,1);
  }
  
  for(Cell c : CellSpace){
    PVector RenderColour = c.getRenderColour();
    renderSurface.fill(RenderColour.x,RenderColour.y,RenderColour.z);
    renderSurface.rect(c.getLocation().x,c.getLocation().y,1,1);
  }
  
  renderSurface.endDraw();
  imageMode(CENTER);
  image(renderSurface, width/2, height/2, width, height);
}

void setupSurface(){
  renderSurface = createGraphics(X_SIZE_SCALED,Y_SIZE_SCALED);
}

void initSpace(){
  CellSpace = new ArrayList<Cell>();
  WorldSpace = new HashMap<PVector,Tile>();
}

void pre(){
  //Check for window size changes
  if (X_SIZE != width || Y_SIZE != height) {
    //If so, adjust variables accordingly and recreate the render surface according to the new size
    X_SIZE = width;
    Y_SIZE = height;
    X_SIZE_SCALED = X_SIZE/SCALAR;
    Y_SIZE_SCALED = Y_SIZE/SCALAR;
    setupSurface();
  }
}

void mousePressed(){
  CellSpace.add(new Cell(new PVector(mouseX/SCALAR,mouseY/SCALAR)));
}
