class laser{
  PVector location,velocity;
  int life;
  
  laser(PVector startPos,PVector direction,float speed){
    location=startPos.get();
    velocity=direction.get();
    velocity.setMag(speed);
    life=0;
  }
  
  void update(){
    location.add(velocity);
    
    if(location.x<-20){
      location.set(width+20,location.y);
    }
    if(location.x>width+20){
      location.set(-20,location.y);
    }
    if(location.y<-20){
      location.set(location.x,height+20);
    }
    if(location.y>height+20){
      location.set(location.x,-20);
    }
    
    life++;
    
    if(life>120){
      toRemove.add(this);
    }
    
    for(asteroid a : rocks){
      if(PVector.dist(location,a.location)<a.size){
        toSplit.add(a);
        toRemove.add(this);
        break;
      }
    }
  }
  
  void render(){
    pushMatrix();
    translate(location.x,location.y);
    rotate(velocity.heading());
    rectMode(CENTER);
    rect(0,0,15,2);
    popMatrix();
  }
}


