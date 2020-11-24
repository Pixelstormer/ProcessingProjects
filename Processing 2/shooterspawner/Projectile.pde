class Projectile extends Unit implements ICanMoveMyself{
  
  Projectile(PVector origin, PVector heading){
    super(origin, 0, 0);
    velocity.set(heading.x, heading.y);
    velocity.setMag(8);
  }
  
  @Override
  void move(){
    applyVelocity();
  }
  
  @Override
  void render(){
     pushMatrix();
     translate(position.x, position.y);
     rotate(velocity.heading());
     
     fill(255);
     noStroke();
     
     rectMode(CENTER);
     rect(0, 0, 15, 5);
     
     popMatrix();
  }
}

