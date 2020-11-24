//The camera currently responsible for rendering
Camera activeCamera;
Room room;

//Constant representing the width of a single tile, measured in pixels
final private int SINGLE_TILE_WIDTH = 25;
//Constant representing the height of a single tile, measured in pixels
final private int SINGLE_TILE_HEIGHT = 25;

void setup(){
  size(840,560);
  frame.setResizable(true);
  text("LOADING", 0,0);
  imageMode(CENTER);
  
  room = new Room(5,5);
}

void draw(){
  background(0);
  
  room.renderRoom();
  image(room.camera().scene(), width/2, height/2);
}

void circle(PGraphics target, float x, float y, float radius){
  target.ellipse(x,y,radius,radius);
}

