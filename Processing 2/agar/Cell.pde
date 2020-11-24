class Cell{
  private final PVector position;
  private final PVector velocity;
  private final float speed;
  private final float drag;
  private final float divisionThreshhold;
  private final List<Food> available;
  
  private float food;
  private Food target;
  
  Cell(PVector position, float speed, float drag, float divThreshhold, float startSize, List<Food> accessible){
    this.position = position.get();
    velocity = new PVector(0, 0);
    this.speed = speed;
    this.drag = drag;
    divisionThreshhold = divThreshhold;
    food = startSize;
    target = getTarget(accessible);
    available = accessible;
  }
  
  Food getTarget(List<Food> accessible){
    Food closest = null;
    for(Food f : accessible){
      if(closest == null || PVector.dist(f.getPos(), position) <= PVector.dist(closest.getPos(), position)){
        closest = f;
      }
    }
    return closest;
  }
  
  PVector getPosition(){
    return position.get();
  }
  
  float getFood(){
    return food;
  }
  
  Food getTarget(){
    return target;
  }
  
  void setTarget(Food to){
    target = to;
  }
  
  void addVelocity(PVector force){
    velocity.add(force);
  }
  
  void update(List<Cell> others){
    PVector dir = (target==null) ? new PVector(0, 0) : PVector.sub(target.getPos(), position);
    dir.setMag(speed);
    
    for(Cell c : others){
      if(c == this)
        continue;
      if(PVector.dist(position, c.getPosition()) < food/2 + c.getFood()/2){
        PVector offset = PVector.sub(position, c.getPosition());
        offset.setMag(c.getFood()/2);
        velocity.add(offset);
        offset.setMag(-food/2);
        c.addVelocity(offset);
      }
    }
    
    velocity.add(dir);
    velocity.add(PVector.mult(velocity, -drag));
    
    position.add(velocity);
    
    food-=0.02;
    
    if(target.isIntersecting(position, food)){
      food += target.getSize();
      removeFood(target);
      target = getTarget(available);
    }
    
    if(food >= divisionThreshhold){
      cells.add(new Cell(position, speed, drag, divisionThreshhold, food/2, available));
      food /= 2;
    }
  }
  
  void render(){
    stroke(220);
    strokeWeight(ceil(food/20));
    fill(160, 200);
    ellipse(position.x, position.y, food, food);
    noStroke();
    fill(220);
    ellipse(position.x, position.y, food/3, food/3);
  }
}
