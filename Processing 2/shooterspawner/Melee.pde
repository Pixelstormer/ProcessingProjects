class Melee extends Unit implements ICanMoveMyself{
  
  boolean aggressive;
  int timeout;
  int angle;
  
  int rotateSpeed = 4;
  float speed = 2.5;
  
  Melee(PVector origin){
    super(origin, 0, 0);
    velocity.set(speed, 0);
    aggressive = false;
    timeout = 0;
    angle = 0;
  }
  
  @Override
  void move(){
    if(aggressive){
      chasePlayer();
    }
    else{
      wander();
    }
  }
  
  private void chasePlayer(){
    
  }
  
  private void wander(){
    timeout--;
    
    if(timeout <= 0){
      angle = int(random(360));
      timeout = int(random(270, 560));
    }
    
    PVector target = PVector.fromAngle(radians(angle));
    
    if(degrees(PVector.angleBetween(velocity, target)) <= rotateSpeed){
      velocity.rotate(PVector.angleBetween(velocity, target));
    }
    
    if(degrees(velocity.heading()) > angle){
      velocity.rotate(radians(-rotateSpeed));
    }
    
    if(degrees(velocity.heading()) < angle){
     velocity.rotate(radians(rotateSpeed));
    }
    
    applyVelocity();
    
    if(isOutOfBounds()){
      angle = int(degrees(PVector.sub(new PVector(width/2, height/2),position).heading()));
    }
  }
  
  @Override
  void render(){
    pushMatrix();
    translate(position.x,position.y);
    rotate(velocity.heading());
    
    fill(255);
    noStroke();
    ellipse(0, 0, 15, 15);
    triangle(0, 7.5, 0, -7.5, 18, 0);
    
    popMatrix();
  }
}

