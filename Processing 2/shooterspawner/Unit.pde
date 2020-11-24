abstract class Unit{
  protected final PVector position;
  protected final PVector velocity;
  protected final float dragCoefficient;
  protected final float weight;
  
  protected Unit(PVector position, float drag, float weight){
    this.position = position.get();
    velocity = new PVector(0,0);
    dragCoefficient = drag;
    this.weight = weight;
  }
  
  PVector position(){
    return position.get();
  }
  
  protected void applyForce(PVector force){
    velocity.add(PVector.div(force, weight));
  }
  
  protected void applyVelocity(){
    position.add(velocity);
  }
  
  protected void applyDrag(){
    velocity.add(PVector.mult(velocity, -dragCoefficient));
  }
  
  boolean isOutOfBounds(){
    return position.x<0 || position.x>width || position.y<0 || position.y>height;
  }
  
  protected abstract void render();
}

