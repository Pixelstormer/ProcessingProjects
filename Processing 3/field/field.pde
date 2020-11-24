import java.awt.Color;

Tile[][] tiles;
ArrayList<Entity> entities;

final int X_SIZE = 12;
final int Y_SIZE = 12;
final float TILE_SIZE = 25;
final PVector SCREEN_EDGE_INDENT = new PVector(25,25);
final float TILE_GAP_SIZE = 2;

void setup(){
  size(840,560);
  surface.setResizable(true);
  rectMode(CENTER);
  
  tiles = new Tile[X_SIZE][Y_SIZE];
  entities = new ArrayList<Entity>();
  
  fillEmptyTiles();
  
  tiles[8][10] = new Hive(8,10,tiles[8][10].getRenderPosition().copy());
  //tiles[0][11] = new Vine(0,11,tiles[0][11].getRenderPosition().copy());
  
  entities.add(new Bee(tiles[6][6], (Hive)tiles[8][10]));
  entities.add(new Flower(tiles[1][1]));
}

void draw(){
  background(60);
  iterateTiles();
  iterateEntities();
  renderTiles();
  renderEntities();
}

void iterateTiles(){
  for(Tile[] yTiles : tiles){
    for(Tile t : yTiles){
      if(t == null) continue;
      t.iterate();
      
    }
  }
}

void iterateEntities(){
  for(Entity e: entities){
    e.iterate();
  }
}

void renderEntities(){
  for(Entity e : entities){
    e.render();
  }
}

void renderTiles(){
  for(Tile[] yTiles : tiles){
    for(Tile t : yTiles){
      if(t == null) continue;
      t.render();
    }
  }
}

void fillEmptyTiles(){
  for(int x=0; x<X_SIZE; x++){
    for(int y=0; y<Y_SIZE; y++){
      if(tiles[x][y] != null) continue;
      tiles[x][y] = new Grass(x,y,new PVector(x*(TILE_SIZE+TILE_GAP_SIZE)+SCREEN_EDGE_INDENT.x,
                                              y*(TILE_SIZE+TILE_GAP_SIZE)+SCREEN_EDGE_INDENT.y));
    }
  }
}

void square(float x, float y, float size){
  rect(x,y,size,size);
}

void circle(float x, float y, float size){
  ellipse(x,y,size,size);
}