//A square with physics

class PhysicsSquare extends PhysicsObject implements CollidableObject{
  //Bounds = 2x the distance from center to an edge
  PVector Bounds;
  
  public PhysicsSquare(PVector Velocity, PVector Location, PVector Bounds, float Drag, float MaximumVelocity, float VelocityMultiplier, boolean Looping, boolean IgnoreScreenBounds){
    super(Velocity, Location, Drag, MaximumVelocity, VelocityMultiplier, Looping, IgnoreScreenBounds);
    this.Bounds = Bounds.copy();
  }
  
  public PhysicsSquare(){
    super();
    this.Bounds = new PVector(25,25);
  }
  
  public void MovePoint(PVector point){
    PVector dir = PVector.sub(point, Location);
    dir.setMag(1);
    this.IteratePhysics(dir);
  }
  
  public void MoveDirection(PVector point){
    PVector dir = point.copy();
    dir.setMag(1);
    this.IteratePhysics(dir);
  }
  
  public int pollForPointCollision(PVector point){
    pushMatrix();
    translate(Location.x,Location.y);
    rotate(Rotation);
    boolean Result = point.x > Location.x - Bounds.x/2 &&
                     point.x < Location.x + Bounds.x/2 &&
                     point.y > Location.y - Bounds.y/2 &&
                     point.y < Location.y + Bounds.y/2;
    
    float topDistance = abs(point.y-(Location.y+Bounds.y/2));
    float bottomDistance = abs(point.y-(Location.y-Bounds.y/2));
    float leftDistance = abs(point.x-(Location.x+Bounds.x/2));
    float rightDistance = abs(point.x-(Location.x-Bounds.x/2));
    
    popMatrix();
    
    if(Result){
      if(topDistance < bottomDistance && topDistance < leftDistance && topDistance < rightDistance){
        return 0;
      }
      if(bottomDistance < topDistance && bottomDistance < leftDistance && bottomDistance < rightDistance){
        return 1;
      }
      if(leftDistance < topDistance && leftDistance < bottomDistance && leftDistance < rightDistance){
        return 2;
      }
      if(rightDistance < topDistance && rightDistance < bottomDistance && rightDistance < leftDistance){
        return 3;
      }
    };
    return -1;
  }
  
  public PVector pollForBoundsCollision(PVector center, PVector bounds){
    pushMatrix();
    translate(Location.x,Location.y);
    rotate(Rotation);
    boolean Result = center.x-bounds.x/2 < Location.x+Bounds.x/2 &&
                     center.x+bounds.x/2 > Location.x-Bounds.x/2 &&
                     center.y-bounds.y/2 < Location.y+Bounds.y/2 &&
                     center.y+bounds.y/2 > Location.y-Bounds.y/2;
    
    float bottomDistance = abs((center.y-bounds.y/2)-(Location.y+Bounds.y/2));
    float topDistance = abs((center.y+bounds.y/2)-(Location.y-Bounds.y/2));
    float leftDistance = abs((center.x-bounds.x/2)-(Location.x+Bounds.x/2));
    float rightDistance = abs((center.x+bounds.x/2)-(Location.x-Bounds.x/2));
    
    popMatrix();
    
    if(Result){
      if(topDistance < bottomDistance && topDistance < leftDistance && topDistance < rightDistance){
        return new PVector(center.x,Location.y-Bounds.y/2-bounds.y/2,0);
      }
      if(bottomDistance < topDistance && bottomDistance < leftDistance && bottomDistance < rightDistance){
        return new PVector(center.x,Location.y+Bounds.y/2+bounds.y/2,1);
      }
      if(leftDistance < topDistance && leftDistance < bottomDistance && leftDistance < rightDistance){
        return new PVector(Location.x+Bounds.x/2+bounds.x/2,center.y,2);
      }
      if(rightDistance < topDistance && rightDistance < bottomDistance && rightDistance < leftDistance){
        return new PVector(Location.x-Bounds.x/2-bounds.x/2,center.y,3);
      }
    }
    return new PVector(center.x,center.y,-1);
  }
  
  public void forceSetLocation(PVector newLocation){
    this.Location = newLocation.copy();
  }
  
  public void forceOffetLocation(PVector offset){
    this.Location.add(offset);
  }
  
  public boolean CheckScreenBounds(){
    if(IgnoreScreenBounds){
      println("This object ignores screen bounds, don't try and check them.");
      Thread.dumpStack();
      return false;
    }
    if(Looping){
      if(Location.x + Bounds.x/2<0){
        Location.x = width + Bounds.x/2;
        return true;
      }
      if(Location.x - Bounds.x/2>width){
        Location.x = 0 - Bounds.x/2;
        return true;
      }
      if(Location.y + Bounds.y/2<0){
        Location.y = height + Bounds.y/2;
        return true;
      }
      if(Location.y - Bounds.y/2>height){
        Location.y = 0 - Bounds.y/2;
        return true;
      }
    }
    else{
     if(Location.x - Bounds.x/2<0){
        Location.x = 0 + Bounds.x/2;
        Velocity.x *= -1;
        return true;
      }
      if(Location.x + Bounds.x/2>width){
        Location.x = width - Bounds.x/2;
        Velocity.x *= -1;
        return true;
      }
      if(Location.y - Bounds.y/2<0){
        Location.y = 0 + Bounds.y/2;
        Velocity.y *= -1;
        return true;
      }
      if(Location.y + Bounds.y/2>height){
        Location.y = height - Bounds.y/2;
        Velocity.y *= -1;
        return true;
      }
    }
    return false;
  }
  
  public void Render(){
    noFill();
    stroke(255);
    strokeWeight(3);
    rectMode(CENTER);
    pushMatrix();
    translate(Location.x,Location.y);
    rotate(Rotation);
    rect(0,0,Bounds.x,Bounds.y);
    popMatrix();
  }
}