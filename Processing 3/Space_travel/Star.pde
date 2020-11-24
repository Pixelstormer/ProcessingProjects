class Star{
  PVector pos, vel, acc;
  
  Star(PVector p){
    pos=p.copy();
    setVectors();
  }
  
  void update(){
    vel.add(acc);
    pos.add(vel);
    pos.z++;
    
    if(pos.x<0||pos.x>width||pos.y<0||pos.y>height){
      pos=new PVector(random(width),random(height),0);
      setVectors();
    }
  }
  
  void render(){
    float w=map(pos.z,0,100,0,4);
    ellipse(pos.x,pos.y,w,w);
  }
  
  void setVectors(){
    vel=PVector.sub(pos,center);
    vel.setMag(random(0.1,1));
    acc=vel.copy();
  }
}