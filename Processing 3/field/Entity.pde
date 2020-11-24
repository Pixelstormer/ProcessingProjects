abstract class Entity{
  //Mobile entity with decimal position
  
  private PVector position;
  
  Entity(PVector position){
    this.position = position.copy();
  }
  
  Entity(Tile origin){
    this.position = origin.getRenderPosition().copy();
  }
  
  PVector getPosition(){
    return this.position.copy();
  }
  
  //Equivalent to update
  abstract void iterate();
  abstract void move(PVector movement);
  abstract void render();
}