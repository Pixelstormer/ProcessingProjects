abstract class Tile{
  //Entity with integer position and constant(?) size
  
  private int x;
  private int y;
  private PVector renderPosition;
  
  Tile(int x, int y, PVector renderPosition){
    this.x = x;
    this.y = y;
    this.renderPosition = renderPosition.copy();
  }
  
  int getX(){
    return this.x;
  }
  
  int getY(){
    return this.y;
  }
  
  PVector getRenderPosition(){
    return this.renderPosition.copy();
  }
  
  //Equivalent to update
  abstract void iterate();
  abstract void render();
}