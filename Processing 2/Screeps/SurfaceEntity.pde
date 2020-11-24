abstract class SurfaceEntity extends TileComponent{
  //Static objects that do not move*, but have advanced behaviour like entities:
  //A house, a bridge, a tree, etc.
  protected SurfaceEntity(Tile parent){
    super(parent);
    parent.tileEntity = this;
  }
  
  
  protected abstract void update();
}

