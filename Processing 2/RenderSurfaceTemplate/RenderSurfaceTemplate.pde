import java.awt.Graphics2D;
import java.awt.RenderingHints;

//Number of milliseconds between each iteration
final int STEP_INTERVAL = 1;
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
Possible actions:
  Do not move ()
  Move UP (y--)
  Move DOWN (y++)
  Move LEFT (x--)
  Move RIGHT (x++)
  Move UP+LEFT (y--,x--)
  Move UP+RIGHT (y--,x++)
  Move DOWN+LEFT (y++,x--)
  Move DOWN+RIGHT (y++,x++)
  Get state of this cell ()
  Get state of UP cell (y-1)
  Get state of DOWN cell (y+1)
  Get state of LEFT cell (x-1)
  Get state of RIGHT cell (x+1)
  Get state of UP+LEFT cell (y-1,x-1)
  Get state of UP+RIGHT cell (y-1,x+1)
  Get state of DOWN+LEFT cell (y+1,x-1)
  Get state of DOWN+RIGHT cell (y+1,x+1)
  Change state of this cell
*/

void setup(){
  size(X_SIZE,Y_SIZE);
  //Attempt to achieve maximum possible framerate,
  //so that STEP_INTERVAL can be checked as frequently as possible
  //(In case of very low values).
  frameRate(Integer.MAX_VALUE);
  frame.setResizable(true);
  setupSurface();
  
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
  //Functionality goes here
}

void render(){
  //Prevent blurryness caused by anti-aliasing
  Graphics2D g2d = ((PGraphicsJava2D)g).g2;
  g2d.setRenderingHint(RenderingHints.KEY_INTERPOLATION, RenderingHints.VALUE_INTERPOLATION_NEAREST_NEIGHBOR);
  renderSurface.beginDraw();
  renderSurface.background(0);
  
  //Replace the next three lines with your own rendering
  renderSurface.fill(255);
  renderSurface.noStroke();
  renderSurface.rect(X_SIZE_SCALED/2,Y_SIZE_SCALED/2,4,4);
  
  renderSurface.endDraw();
  imageMode(CENTER);
  image(renderSurface, width/2, height/2, width, height);
}

void setupSurface(){
  renderSurface = createGraphics(X_SIZE_SCALED,Y_SIZE_SCALED);
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

