class Mover implements GameObject{
  private MoverAI ai;
  
  private PVector location;
  private PVector target;
  private PVector velocity;
  private PVector heading;
  private float distanceThreshhold;
  private float angleThreshhold;
  private float speed;
  private float turnSpeed;
  private float size;

  Mover(PVector location, float distanceTreshhold, float angleThreshhold, float speed,float turnSpeed, float size) {
    this.ai = new MoverAI(this, null);
    this.location = location.get();
    velocity = new PVector(0, 0);
    heading = new PVector(speed, 0);
    target = new PVector(0,0);
    this.distanceThreshhold = distanceThreshhold;
    this.angleThreshhold = angleThreshhold;
    this.speed = speed;
    this.turnSpeed = turnSpeed;
    this.size = size;
    
    displayName = "MOVER";
  }
  
  void updateTarget(PVector newTarget){
    target = newTarget.get();
  }
  
  void iterate(){
    ai.iterate();
  }
  
  boolean atTarget(){
    return PVector.dist(location, target)<=distanceThreshhold+size;
  }
  
  PVector position(){
    return this.position.get();
  }
  
  private void update() {
    PVector direction = PVector.sub(target, location);
    float angle = directionBetween(location, target, heading);
    if (angle<angleThreshhold) {
      heading.rotate(radians(turnSpeed));
    }
    if (angle>angleThreshhold) {
      heading.rotate(radians(-turnSpeed));
    }
    if(angle==angleThreshhold){
      heading.rotate(PVector.angleBetween(heading,direction));
    }
    if (atTarget()) {
      ai.updateTarget();
    }
    else{
      heading.setMag(speed);
      location.add(heading);
    }
  }

  private void render() {
    pushMatrix();
    translate(location.x, location.y);
    rotate(heading.heading());
    noStroke();
    fill(180);
    triangle(0, -size/2, 0, size/2, size, 0);
    fill(255);
    ellipse(0, 0, size, size);
    popMatrix();
    
    stroke(255);
    line(location.x,location.y,target.x,target.y);
  }
}

