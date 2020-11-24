class Hook{
  static final float size = 15;
  private final PVector position;
  private boolean beingUsed;
  
  Hook(PVector position){
    this.position = position.get();
  }
  
  Hook(float x, float y){
    this(new PVector(x, y));
  }
  
  void setPos(float x, float y){
    position.set(x, y);
  }
  
  void setPos(PVector to){
    setPos(to.x, to.y);
  }
  
  PVector pos(){
    return position.get();
  }
  
  boolean beingUsed(){
    return beingUsed;
  }
  
  void setBeingUsed(boolean to){
    beingUsed = to;
  }
  
  void render(){
    noStroke();
    fill(160);
    ellipse(position.x, position.y, size, size);
  }
}

class DistanceComparator implements Comparator<Hook>{
  private final PVector point;
  
  DistanceComparator(PVector point){
    this.point = point.get();
  }
  
  @Override
  int compare(Hook a, Hook b){
    return (int)Math.signum(PVector.dist(a.pos(), point) - PVector.dist(b.pos(), point));
  }
}

