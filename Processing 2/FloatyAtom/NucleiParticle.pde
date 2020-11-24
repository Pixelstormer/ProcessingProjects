class NucleiParticle{
  boolean Charge;
  PVector Location;
  PVector Velocity;
  float Size;
  float BorderSize;
  
  NucleiParticle(boolean Charge, PVector Location, float Size){
    this.Charge = Charge;
    this.Velocity = new PVector(0,0);
    this.Location = Location.get();
    this.Size = Size;
    this.BorderSize = this.Size/5;
  }
  
  public void Render(){
    if(this.Charge){
       fill(255,45,45);
       stroke(220,60,60);
       strokeWeight(this.BorderSize);
       ellipse(this.Location.x,this.Location.y,Size, Size);
    }
    else{
       fill(20,255,20);
       stroke(25,210,25);
       strokeWeight(this.BorderSize);
       ellipse(this.Location.x,this.Location.y,Size, Size);
    }
  }
  
  public void moveTowards(PVector target){
    PVector Acceleration = PVector.sub(target,this.Location);
    PVector noise = PVector.random2D();
    noise.setMag(0.01);
    Acceleration.setMag(1);
    Acceleration.add(noise);
    
    this.Velocity.add(Acceleration);
    this.Velocity.mult(0.8);
    this.Velocity.setMag(constrain(this.Velocity.mag(),-32, 32));
    this.Location.add(Velocity);
  }
  
  public void moveTowardsDiminishing(PVector target, float scalar, float max){
    PVector Acceleration = PVector.sub(target,this.Location);
    PVector noise = PVector.random2D();
    noise.setMag(0.01);
    float intensity = 1/PVector.dist(this.Location,target)*scalar;
    if(intensity>max){
      intensity=max;
    }
    if(intensity<noise.mag()){
      intensity*=-1;
    }
    Acceleration.setMag(intensity);
    Acceleration.add(noise);
    
    this.Velocity.add(Acceleration);
    this.Velocity.mult(0.8);
    this.Velocity.setMag(constrain(this.Velocity.mag(),-8,8));
    this.Location.add(Velocity);
  }
  
  public void offsetBy(PVector offset){
    this.Location.add(offset);
  }
  
  public void setLocation(PVector location){
    this.Location = location.get();
  }
  
  public void doCollision(ArrayList<NucleiParticle> others){
    for(NucleiParticle n : others){
      if(n!=this){
        if(PVector.dist(this.Location,n.Location)<25){
          PVector thisPositionDifference = PVector.sub(n.Location,this.Location);
          thisPositionDifference.setMag(12.5);
          PVector closestThisPoint = PVector.add(this.Location,thisPositionDifference);
          
          PVector otherPositionDifference = PVector.sub(this.Location,n.Location);
          otherPositionDifference.setMag(12.5);
          PVector closestOtherPoint = PVector.add(n.Location,otherPositionDifference);
          
          float offsetDist = PVector.dist(closestThisPoint,closestOtherPoint);
          
          PVector thisOffsetDifference = otherPositionDifference.get();
          thisOffsetDifference.setMag(offsetDist/2);
          PVector thisOffset = PVector.add(closestThisPoint,thisOffsetDifference);
          
          PVector otherOffsetDifference = thisPositionDifference.get();
          otherOffsetDifference.setMag(offsetDist/2);
          PVector otherOffset = PVector.add(closestOtherPoint, otherOffsetDifference);
          
          this.Velocity.add(thisOffsetDifference);
          n.Velocity.add(otherOffsetDifference);
//          println(thisOffset);
//          this.setLocation(thisOffset);
//          n.setLocation(otherOffset);
        }
      }
    }
  }
  
  public PVector collideWithCircle(PVector loc, float rad){
    if(PVector.dist(loc,this.Location)>rad){
      return new PVector(0,0);
    }
    
    PVector dir = PVector.sub(this.Location,loc);
    dir.setMag(4);
    this.Velocity.add(dir);
    return dir;
  }
}

