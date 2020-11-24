class particle{
  PVector position,velocity;
  float drag,life,maxLife,trailTime;
  int size;
  color colour;
  boolean trail,looper;
  ArrayList<particle> subParticles=new ArrayList<particle>();
  
  particle(PVector startPos,PVector Velocity,float speed,float Drag,float MaxLife,int Size,color Colour,boolean Trail,float TrailTime,boolean Looper){
    position=startPos.get();
    velocity=Velocity.get();
    velocity.setMag(speed);
    drag=Drag;
    life=0;
    maxLife=MaxLife;
    size=Size;
    colour=Colour;
    trail=Trail;
    trailTime=TrailTime;
    looper=Looper;
  }
  
  void update(){
    velocity.setMag(velocity.mag()-drag);
    position.add(velocity);
    checkOutOfBounds();
    if(trail){
      if(velocity.mag()<1){
        toRemove.add(this);
      }
    }
    else{
      life++;
      if(life>maxLife){
        toRemove.add(this);
      }
    }
  }
  
  void checkOutOfBounds(){
    if(looper){
      if(position.x<-size){
        position.x=width+size;
      }
      if(position.x>width+size){
        position.x=-size;
      }
      if(position.y<-size){
        position.y=height+size;
      }
      if(position.y>height+size){
        position.y=-size;
      }
    }
   else{
      if(position.x<size||position.x>width-size){
        velocity.x*=-1;
      }
      if(position.y<size||position.y>height-size){
        velocity.y*=-1;
      }
    }
  }
  
  void render(){
    fill(colour);
    ellipse(position.x,position.y,size,size);
    for(particle p : subParticles){
      p.update();
      p.render();
    }
    if(trail){
      subParticles.add(new particle(position,new PVector(0,0),0,0,trailTime,size,colour,false,0,true));
    }
  }
}


