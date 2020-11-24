class rocket{
  PVector location,velocity,acceleration;
  float thrust;
  int rotation;
  
  rocket(PVector startingPos,float Thrust){
    location=startingPos.get();
    velocity=new PVector(0,0);
    acceleration=new PVector(0,0);
    thrust=Thrust;
    rotation=0;
  }
  
  void applyForce(PVector force){
    acceleration.add(force);
  }
  
  void spin(int amount){
    rotation+=amount;
  }
  
  void update(){
    acceleration.setMag(thrust);
    velocity.add(acceleration);
    velocity.limit(8);
    location.add(velocity);
    acceleration.mult(0);
    
    for(asteroid a : rocks){
      if(PVector.dist(location,a.location)<a.size+15&&!(iframes>0)){
        lives--;
        iframes=120;
        toSplit.add(a);
        score-=500;
      }
    }
  }
  
  void checkOutOfBounds(){
    if(location.x<-25){
      location.set(width+25,location.y);
    }
    if(location.x>width+25){
      location.set(-25,location.y);
    }
    if(location.y<-25){
      location.set(location.x,height+25);
    }
    if(location.y>height+25){
      location.set(location.x,-25);
    }
  }
  
  void render(){
    pushMatrix();
    translate(location.x,location.y);
    rotate(radians(rotation));
    triangle(20,0,-10,-10,-10,10);
    popMatrix();
  }
}


