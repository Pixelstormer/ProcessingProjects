class Electron{
  PVector Location;
  float Size;
  float BorderSize;
  
  Electron(PVector location, float Size){
    this.Location = location.get();
    this.Size = Size;
    this.BorderSize = this.Size/4;
  }
  
  public void Render(){
     fill(120,120,225);
     stroke(160,160,255);
     strokeWeight(this.BorderSize);
     ellipse(this.Location.x,this.Location.y,this.Size,this.Size);
  }
  
  public void rotateAround(PVector center, float distance){
    PVector dir = PVector.sub(center,this.Location);
    PVector axis = new PVector(0,0,1);
    PVector vel = dir.cross(axis);
    vel.setMag(4);
    float dist = PVector.dist(this.Location,center) - distance;
    dir.setMag(dist);
    vel.add(dir);
    this.Location.add(vel);
  }
  
  public void offsetBy(PVector offset){
    this.Location.add(offset);
  }
}

