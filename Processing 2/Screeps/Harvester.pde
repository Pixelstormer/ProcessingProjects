class Harvester extends Entity{
  private float angle;
  
  Harvester(Tile parent){
    super(parent);
    angle = 270;
  }
  
  void renderOnto(PGraphics target){
    angle++;
    
    target.ellipseMode(CORNER);
    target.noStroke();
    target.fill(130);
    circle(target,room.scaleCoordinate(x,false,true),room.scaleCoordinate(y,false,false),min(SINGLE_TILE_WIDTH,SINGLE_TILE_HEIGHT));
    target.stroke(205);
    target.strokeWeight(4);
    PVector head = PVector.add(new PVector(room.scaleCoordinate(x,true,true),room.scaleCoordinate(y,true,false)), PVector.mult(PVector.fromAngle(radians(angle)).normalize(null),min(SINGLE_TILE_WIDTH,SINGLE_TILE_HEIGHT)/2));
    target.line(room.scaleCoordinate(x,true,true),room.scaleCoordinate(y,true,false),head.x,head.y);
  }
  
  void update(){
    
  }
}

