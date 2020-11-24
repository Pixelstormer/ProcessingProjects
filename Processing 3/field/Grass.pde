class Grass extends Tile{
  private Color colour = new Color(130,200,100);
  
  Grass(int x, int y, PVector renderPosition){
    super(x,y,renderPosition);
  }
  
  void iterate(){
    
  }
  
  void render(){
    noStroke();
    fill(colour.getRed(),colour.getGreen(),colour.getBlue());
    square(super.renderPosition.x,super.renderPosition.y,TILE_SIZE);
  }
}