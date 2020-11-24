//Object that follows the mouse

class MouseFollower extends PhysicsObject{
  public MouseFollower(PVector Velocity, PVector Location, float Drag, float MaximumVelocity, float VelocityMultiplier, boolean Looping, boolean IgnoreScreenBounds){
    super(Velocity, Location, Drag, MaximumVelocity, VelocityMultiplier, Looping, IgnoreScreenBounds);
  }
  
  public MouseFollower(){
    super();
  }
  
  public void Update(){
    PVector Direction = PVector.sub(new PVector(mouseX,mouseY), Location);
    Direction.setMag(1);
    super.IteratePhysics(Direction);
  }
  
  public void Render(){
    noStroke();
    fill(255);
    ellipse(Location.x,Location.y,25,25);
    
    stroke(255);
    line(Location.x,Location.y,Location.x+Velocity.x,Location.y+Velocity.y);
  }
}