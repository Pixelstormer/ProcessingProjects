class MassPoint{
  //Class representing a given center of mass
  protected final PVector position;
  protected final PVector velocity;
  protected final float mass;
  protected final float drag;
  
  MassPoint(PVector position, float mass, float drag){
    this.position = position.get();
    this.mass = mass;
    this.drag = drag;
    velocity = new PVector(0, 0);
  }
  
  //Applies a force and returns the new velocity
  PVector applyForce(PVector force){
    velocity.add(PVector.div(force, mass));
    return velocity;
  }
  
  void update(PVector gravity){
    updateVelocity(gravity);
    updatePosition();
  }
  
  protected void updateVelocity(PVector gravity){
    velocity.add(PVector.mult(gravity, mass));
    velocity.add(PVector.mult(velocity, -drag));
  }
  
  protected void updatePosition(){
    position.add(velocity);
  }
  
  PVector getPosition(){
    return position.get();
  }
  
  PVector offsetPosition(PVector by){
    position.add(by);
    return getPosition();
  }
  
  PVector offsetPosition(float x, float y){
    position.x += x;
    position.y += y;
    return getPosition();
  }
  
  PVector setPosition(PVector to){
    position.set(to.x, to.y);
    return getPosition();
  }
  
  PVector setPosition(float x, float y){
    position.set(x, y);
    return getPosition();
  }
}

