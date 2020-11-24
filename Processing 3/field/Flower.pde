class Flower extends Entity{
  Tile root;
  
  Flower(Tile root){
    super(root.getRenderPosition());
    this.root = root;
  }
  
  void iterate(){
    
  }
  
  void move(PVector movement){
    
  }
  
  void render(){
    stroke(0);
    strokeWeight(1);
    fill(230,175,185);
    circle(super.position.x,super.position.y,TILE_SIZE/1.2);
  }
}