class Room{
  //Number of columns of tiles in this room
  final private int tile_width;
  //Number of tiles in a column in this room
  final private int tile_height;
  //Container for tile columns and tiles
  /* The 'x' and 'y' index of each tile is that tile's literal x and y coordinate */
  final private Tile[][] room_tiles;
  //Camera that renders this room
  final private Camera room_camera;
    
  Room(int tile_width, int tile_height){
    this.tile_width = tile_width;
    this.tile_height = tile_height;
    room_tiles = new Tile[tile_width][tile_height];
    room_camera = new Camera(SINGLE_TILE_WIDTH * tile_width,
                             SINGLE_TILE_HEIGHT * tile_height);
    init_tiles();
    room_tiles[1][1].entity = new Harvester(room_tiles[1][1]);
    room_tiles[3][3].tileEntity = new Goal(room_tiles[3][3]);
  }
  
  private void init_tiles(){
    //Attempt to instantiate tiles to a default state
    if(room_tiles == null)
      throw new IllegalStateException("Attempted to instantiate tiles when container was null!");
    Tile[] column;
    Tile tile;
    for(int x=0;x<room_tiles.length;x++){
      column = room_tiles[x];
      if(column == null)
        throw new IllegalStateException("Attempted to instantiate tiles when some columns were null!");
      for(int y=0;y<column.length;y++){
        tile = column[y];
        if(tile == null){
          column[y] = new Tile(x,y);
        }
        else{
          throw new IllegalStateException("Attempted to instantiate tiles when some tiles were already instantiated!");
        }
      }
    }
  }
  
  void renderRoom(){
    PGraphics scene = room_camera.scene();
    room_camera.beginDraw();
    scene.background(0);
    for(Tile[] column : room_tiles){
      for(Tile tile : column){
        tile.renderOnto(scene);
      }
    }
    room_camera.endDraw();
  }
  
  int scaleCoordinate(int coordinate, boolean center, boolean isX){
    if(isX){
      coordinate *= SINGLE_TILE_WIDTH;
      if(center){
        coordinate += SINGLE_TILE_WIDTH/2;
      }
    }
    else{
      coordinate *= SINGLE_TILE_HEIGHT;
      if(center){
        coordinate += SINGLE_TILE_HEIGHT/2;
      }
    }
    return coordinate;
  }
  
  Camera camera(){
    return room_camera;
  }
}

