class Vine extends Tile{
  
  Vine(int x, int y, PVector renderPosition){
    super(x,y,renderPosition);
  }
  
  void iterate(){
    if(!(frameCount%120==0)) return;
    int newX = constrain(super.x+(int)Math.signum(random(-1,1)),0,X_SIZE-1);
    int newY = constrain(super.y+(int)Math.signum(random(-1,1)),0,Y_SIZE-1);
    
    Tile t = tiles[newX][newY];
    if (!(t instanceof Vine)) tiles[newX][newY] = new Vine(newX,newY,t.getRenderPosition());
  }
  
  void render(){
    fill(145,175,85);
    stroke(200,20,20);
    strokeWeight(2);
    square(super.renderPosition.x,super.renderPosition.y,TILE_SIZE);
  }
}