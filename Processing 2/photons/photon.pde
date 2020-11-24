class photon{
  PVector location;
  PVector velocity;
  boolean grav;
  float drag;
  boolean looping;
  
  int trailLength = 6;
  
  PVector[] trail=new PVector[trailLength];
  
  photon(PVector Location,PVector Velocity,int speed,float Drag,boolean Grav,boolean Looping){
    location=Location.get();
    velocity=Velocity.get();
    velocity.setMag(speed);
    grav=Grav;
    drag=Drag;
    looping=Looping;
    
    for(int i=0;i<trailLength;i++){
      trail[i]=location.get();
    }
  }
  
  void update(){
    
    velocity.div(drag);
    
    if(grav){
      velocity.add(gravity);
    }
    
    location.add(velocity);
    
    updateTrail();
    
    if(location.x<0){
      if(looping){
        location.x=width;
        updateTrail();
      }
      else{
        velocity.x*=-1;
        location.x=0;
      }
    }
    if(location.x>width){
      if(looping){
        location.x=0;
        updateTrail();
      }
      else{
        velocity.x*=-1;
        location.x=width;
      }
    }
    if(location.y<0){
      if(looping){
        location.y=height;
        updateTrail();
      }
      else{
        velocity.y*=-1;
        location.y=0;
      }
    }
    if(location.y>height){
      if(looping){
        location.y=0;
        updateTrail();
      }
      else{
        velocity.y*=-1;
        location.y=height;
      }
    }
  }
  
  void updateTrail(){
    for(int i=0;i<trailLength-1;i++){
      trail[i]=trail[i+1].get();
    }
    
    trail[trailLength-1]=location.get();
  }
  
  void applyForce(PVector force){
    velocity.add(force);
  }
  
  void render(){
    noStroke();
    stroke(255-velocity.mag()*10,255,255);
//    ellipse(location.x,location.y,6,6);
    
    for(int i=0;i<trailLength-1;i++){
//      ellipse(trail[i].x,trail[i].y,5,5);
      if(PVector.dist(trail[i],trail[i+1])<ApproximateMaximumVelocity){
        stroke(255-velocity.mag()*10,255,255,255/trailLength*i);
        line(trail[i].x,trail[i].y,trail[i+1].x,trail[i+1].y);
      }
    }
  }
}


