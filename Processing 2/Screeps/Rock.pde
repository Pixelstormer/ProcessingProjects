class Rock extends Surface{
  Rock(Tile parent){
    super(parent);
  }
  
  void renderOnto(PGraphics target){
    target.fill(95);
    target.noStroke();
    target.rect(x*SINGLE_TILE_WIDTH,y*SINGLE_TILE_HEIGHT,SINGLE_TILE_WIDTH, SINGLE_TILE_HEIGHT, 8);
  }
}

