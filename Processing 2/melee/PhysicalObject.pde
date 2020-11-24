abstract class PhysicalObject extends CollideableObject{
  //Represents a mass point with basic physics and collision
  
  protected final PVector position;
  protected final PVector velocity;
  protected PVector gravity;
  protected float mass;
  protected float dragCoefficient;
  
  PhysicalObject(float elasticity, float friction, PVector position, PVector velocity, PVector gravity, float mass, float dragCoefficient){
    super(elasticity, friction);
    this.position = position.get();
    this.velocity = velocity.get();
    this.gravity = gravity.get();
    this.mass = mass;
    this.dragCoefficient = dragCoefficient;
  }
  
  PhysicalObject(float elasticity, float friction, PVector position, PVector gravity, float mass, float drag){
    super(elasticity, friction);
    this.position = position.get();
    velocity = new PVector(0,0);
    this.gravity = gravity.get();
    this.mass = mass;
    this.dragCoefficient = drag;
  }
  
  protected void tickVelocity(){
    velocity.add(PVector.mult(gravity, mass));
    velocity.add(PVector.mult(velocity, -dragCoefficient));
  }
  
  protected void tickPosition(){
    position.add(PVector.div(velocity, mass));
  }
  
  public void tickPhysics(){
    tickVelocity();
    tickPosition();
  }
  
  public PVector applyForce(PVector force){
    velocity.add(PVector.div(force, mass));
    return velocity.get();
  }
  
  public PVector pullTowards(PVector point, float strength){
    PVector force = PVector.sub(point, position);
    force.setMag(strength);
    return applyForce(force);
  }
  
  public PVector getPosition(){
    return position.get();
  }
  
  public PVector getVelocity(){
    return velocity.get();
  }
  
  public PVector getGravity(){
    return gravity.get();
  }
  
  public float getMass(){
    return mass;
  }
  
  public float getDrag(){
    return dragCoefficient;
  }
  
  abstract PVector closestPointTo(PVector point);
  abstract boolean isIntersecting(PVector point);
}

