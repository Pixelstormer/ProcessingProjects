abstract class CelestialBody{
  protected final PVector position;
  protected final PVector velocity;
  protected final float mass;
  protected final float radius;
  
  CelestialBody(PVector position, PVector velocity, float mass, float radius){
    this.position = position.get();
    this.velocity = velocity.get();
    this.mass = mass;
    this.radius = radius;
  }
  
  CelestialBody(PVector position, float mass, float radius){
    this(position, new PVector(0, 0), mass, radius);
  }
  
  PVector getPosition(){
    return position.get();
  }
  
  PVector getVelocity(){
    return velocity.get();
  }
  
  float getMass(){
    return mass;
  }
  
  float getRadius(){
    return radius;
  }
  
  void offsetPosition(PVector by){
    position.add(by);
  }
  
  void applyForce(PVector force){
    velocity.add(PVector.div(force, mass));
  }
  
  void addVelocity(PVector force){
    velocity.add(force);
  }
  
  void applyGravity(PVector point, float mass){
    /*
           m₁m₂
    F = G ─────
            r²
    F = force
    G = Gravitational Constant
    m₁ = Mass of object 1
    m₂ = Mass of object 2
    r = distance between objects' centers of mass
    
    1-liner version
    velocity.add(PVector.mult(PVector.sub(c.getPosition(), position).normalize(null),
                 mass*c.getMass() / sq(PVector.dist(position, c.getPosition())));
    */
    float distance = PVector.dist(position, point);
    float force = this.mass * mass / sq(distance);
    PVector direction = PVector.sub(point, position);
    direction.setMag(force);
    applyForce(direction);
  }
  
  void applyGravity(List<CelestialBody> others){
    for(CelestialBody c : others){
      if(c == this)
        continue;
      applyGravity(c.getPosition(), c.getMass());
    }
  }
  
  void collide(CelestialBody c){
    float distance = PVector.dist(position, c.getPosition());
    if(distance > radius + c.getRadius())
      return;
    PVector direction = PVector.sub(position, c.getPosition());
    direction.setMag(radius + c.getRadius() - distance);
    position.add(direction);
    velocity.add(direction);
    direction.mult(-1);
    c.addVelocity(direction);
    c.offsetPosition(direction);
  }
  
  void collide(List<CelestialBody> others){
    for(CelestialBody c : others){
      if(c == this)
        continue;
      collide(c);
    }
  }
  
  void constrainToScreen(){
    if(position.x - radius < 0){
      position.x = radius;
      velocity.x *= -0.98;
    }
    
    if(position.x + radius > width){
      position.x = width-radius;
      velocity.x *= -0.98;
    }
    
    if(position.y - radius < 0){
      position.y = radius;
      velocity.y *= -0.98;
    }
    
    if(position.y + radius > height){
      position.y = height-radius;
      velocity.y *= -0.98;
    }
  }
  
  void applyVelocity(){
    position.add(velocity);
  }
  
  abstract void render();
}

