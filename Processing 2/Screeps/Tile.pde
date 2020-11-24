class Tile{
  //The surface object on this tile
  Surface terrain;
  //The surface entity on this tile
  SurfaceEntity tileEntity;
  //The enitity currently on this tile
  Entity entity;
  
  //Literal x coordinate and index in parent room's room_tiles
  private final int x;
  //Literal y coordinate and index in parent room's room_tiles[x]
  private final int y;
  
  Tile(int x, int y){
    this.x = x;
    this.y = y;
    terrain = new Rock(this);
  }
  
  void renderOnto(PGraphics scene){
    if(terrain != null)
      terrain.renderOnto(scene);
    if(tileEntity != null)
      tileEntity.renderOnto(scene);
    if(entity != null)
      entity.renderOnto(scene);
  }
  
  int x(){
    return x;
  }
  
  int y(){
    return y;
  }
}

