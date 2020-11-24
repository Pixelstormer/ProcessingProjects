abstract class TileComponent{
  //Some part of a tile
  
  //Reference to the tile which currently holds the reference to this entity
  protected Tile parent;
  //X coordinate of the tile this entity is on
  protected int x;
  //Y coordinate of the tile this entity is on
  protected int y;
  
  protected TileComponent(Tile parent){
    this.parent = parent;
    x = parent.x();
    y = parent.y();
  }
  
  //Render this component onto a target PGraphics surface
  protected abstract void renderOnto(PGraphics surface);
}

