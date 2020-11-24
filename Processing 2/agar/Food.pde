class Food{
  private final PVector position;
  private final float size;
  
  Food(PVector position, float size){
    this.position = position.get();
    this.size = size;
  }
  
  PVector getPos(){
    return position.get();
  }
  
  float getSize(){
    return size;
  }
  
  boolean isIntersecting(PVector point){
    return PVector.dist(point, position) <= size/2;
  }
  
  boolean isIntersecting(PVector center, float radius){
    return PVector.dist(center, position) <= size/2 + radius/2;
  }
  
  void render(){
    fill(0, 190, 0);
    ellipse(position.x, position.y, size, size);
  }
}

