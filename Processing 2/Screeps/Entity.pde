abstract class Entity extends TileComponent{
  //A mobile object which frequently moves between tiles:
  //A worker, a car, a bird, etc.
  protected Entity(Tile parent){
    super(parent);
    parent.entity = this;
  }
  
  protected abstract void update();
}

