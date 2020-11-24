class Hive extends Tile{
  
  Hive(int x, int y, PVector renderPosition){
    super(x,y,renderPosition);
  }
  
  void iterate(){
    
  }
  
  void render(){
    stroke(0);
    strokeWeight(3);
    fill(255,255,0);
    pushMatrix();
    translate(super.renderPosition.x,super.renderPosition.y);
    rotate(radians(45));
    square(0,0,TILE_SIZE/1.4);
    popMatrix();
  }
}