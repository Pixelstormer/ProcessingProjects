class Goal extends SurfaceEntity{
  
  Goal(Tile parent){
    super(parent);
  }
  
  void renderOnto(PGraphics target){
    target.fill(232);
    target.noStroke();
    target.ellipseMode(CENTER);
    circle(target, room.scaleCoordinate(x,true,true), room.scaleCoordinate(y,true,false), min(SINGLE_TILE_WIDTH,SINGLE_TILE_HEIGHT));
  }
  
  void update(){
    
  }
}

