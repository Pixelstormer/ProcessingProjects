class BasicCircle extends PhysicalObject implements ICanRender{
  //Basic solid circular rigidbody
  
  protected float diameter;
  protected float radius;
  
  BasicCircle(PVector position, PVector velocity, PVector gravity, float mass, float dragCoefficient, float elasticity, float friction, float diameter){
    super(elasticity, friction, position, velocity, gravity, mass, dragCoefficient);
    this.diameter = diameter;
    radius = diameter/2;
  }
  
  BasicCircle(PVector position, PVector gravity, float mass, float drag, float elasticity, float friction, float diameter){
    super(elasticity, friction, position, gravity, mass, drag);
    this.diameter = diameter;
    radius = diameter/2;
  }
  
  @Override
  boolean isIntersecting(PVector point){
    return PVector.dist(point, position) < radius;
  }
  
  @Override
  PVector closestPointTo(PVector point){
    PVector dir = PVector.sub(point, position);
    dir.setMag(min(radius, PVector.dist(point, position)));
    return PVector.add(position, dir);
  }
  
  void constrainToBounds(BoundingBox bounds){
    if(position.x - radius < bounds.getLeftEdge()){
      position.x = bounds.getLeftEdge() + radius;
      velocity.x *= -elasticity;
    }
    if(position.x + radius > bounds.getRightEdge()){
      position.x = bounds.getRightEdge() - radius;
      velocity.x *= -elasticity;
    }
    if(position.y - radius < bounds.getTopEdge()){
      position.y = bounds.getTopEdge() + radius;
      velocity.y *= -elasticity;
    }
    if(position.y + radius > bounds.getBottomEdge()){
      position.y = bounds.getBottomEdge() - radius;
      velocity.y *= -elasticity;
    }
  }
  
  @Override
  void render(){
    fill(255);
    noStroke();
    circle(position.x, position.y, diameter);
  }
}

