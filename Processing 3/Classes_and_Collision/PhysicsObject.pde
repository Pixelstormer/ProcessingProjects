//Object with physics (Velocity, acceleration etc.)

class PhysicsObject extends BasicObject{
  PVector Velocity;
  PVector Acceleration;
  float Drag;
  float MaximumVelocity;
  float VelocityMultiplier;
  boolean Looping;
  boolean IgnoreScreenBounds;

  protected PhysicsObject(PVector Velocity, PVector Location, float Drag, float MaximumVelocity, float VelocityMultiplier, boolean Looping, boolean IgnoreScreenBounds){
    super(Location);
    this.Velocity = Velocity.copy();
    this.Acceleration = new PVector(0, 0);
    this.Drag = Drag;
    this.MaximumVelocity = MaximumVelocity;
    this.VelocityMultiplier = VelocityMultiplier;
    this.Looping = Looping;
    this.IgnoreScreenBounds = IgnoreScreenBounds;
  }
  
  //Default constructor with default values
  protected PhysicsObject(){
    super();
    Velocity = new PVector(0,0);
    Acceleration = new PVector(0,0);
    Drag = 0.95;
    MaximumVelocity = -1;
    VelocityMultiplier = 1;
    Looping = false;
    IgnoreScreenBounds = true;
  }
  
  public void Render(){
    super.Render();
  }
  
  public void IteratePhysics(){
    this.Acceleration.setMag(0);
    this.doPhysics();
  }
  
  public void IteratePhysics(PVector Acceleration){
    this.Acceleration.setMag(0);
    this.Acceleration.add(Acceleration);
    this.doPhysics();
  }
  
  protected void doPhysics(){
    Velocity.add(Acceleration);
    Velocity.mult(Drag);
    Velocity.mult(VelocityMultiplier);
    if(MaximumVelocity > 0){
      Velocity.limit(MaximumVelocity);
    }
    Location.add(Velocity);
  }
  
  public void bounceVelocity(int dir){
    switch(dir){
      case 0:
      case 1:
        this.Velocity.y *= -1;
        break;
      case 2:
      case 3:
        this.Velocity.x *= -1;
        break;
      default:
        break;
    }
  }
  
  public boolean CheckScreenBounds(){
    if(IgnoreScreenBounds){
      println("This object ignores screen bounds, don't try and check them.");
      Thread.dumpStack();
      return false;
    }
    if(Location.x<0){
      Location.x = (Looping) ? width : 0;
      Velocity.x *= (Looping) ? 1 : -1;
      return true;
    }
    if(Location.x>width){
      Location.x = (Looping) ? 0 : width;
      Velocity.x *= (Looping) ? 1 : -1;
      return true;
    }
    if(Location.y<0){
      Location.y = (Looping) ? height : 0;
      Velocity.y *= (Looping) ? 1 : -1;
      return true;
    }
    if(Location.y>height){
      Location.y = (Looping) ? 0 : height;
      Velocity.y *= (Looping) ? 1 : -1;
      return true;
    }
    return false;
  }
}