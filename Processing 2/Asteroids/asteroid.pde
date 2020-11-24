class asteroid{
  PVector location,velocity;
  ArrayList<PVector> vertexes=new ArrayList<PVector>();
  float rotation,angle,size;
  
  asteroid(PVector startPos,PVector direction,float Speed,float Rotation,float Size,boolean split){
    location=startPos.get();
    velocity=direction.get();
    velocity.setMag(Speed);
    rotation=Rotation;
    angle=0;
    size=Size;
    
    if(!(split)){
      while(PVector.dist(location,player.location)<size*2){
        location.set(random(width),random(height));
      }
    }
    
    int points=int(360/random(16,32));
    for(int i=0;i<360;i+=points){
      float x=sin(radians(i));
      float y=cos(radians(i));
      
      vertexes.add(new PVector(x*size+random(-size/9,size/9),y*size+random(-size/9,size/9)));
    }
  }
  
  void update(){
    location.add(velocity);
    
    if(location.x<-(size+size/9)){
      location.set(width+(size+size/9),location.y);
    }
    if(location.x>width+(size+size/9)){
      location.set(-(size+size/9),location.y);
    }
    if(location.y<-(size+size/9)){
      location.set(location.x,height+(size+size/9));
    }
    if(location.y>height+(size+size/9)){
      location.set(location.x,-(size+size/9));
    }
  }
  
  void split(){
    if(size>30){
      for(int i=0;i<random(4);i++){
        rocks.add(new asteroid(new PVector(location.x,location.y),PVector.random2D(),random((40-size)/10,(60-size)/10)*(level/10+1),random(4),size/2,true));
      }
    }
    rocks.remove(this);
  }
  
  void render(){
    pushMatrix();
    translate(location.x,location.y);
    rotate(radians(angle));
    beginShape();
    for(PVector p : vertexes){
      vertex(p.x,p.y);
    }
    endShape(CLOSE);
    popMatrix();
    angle+=rotation;
  }
}


