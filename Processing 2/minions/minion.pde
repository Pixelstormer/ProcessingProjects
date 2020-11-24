class minion {
  PVector location, velocity;
  float size, colour,drag,speed;

  minion(PVector Location, float Speed, float Size, float Colour,float Drag) {
    speed=Speed;
    drag=Drag;
    size=Size;
    colour=Colour;
    
    location=Location.get();
    velocity=PVector.random2D();
    velocity.setMag(speed);
  }

  void update(ArrayList<minion> others) {
    PVector target;
    float closestDistance=0;
    if(followMarkers){
      try{
        int index=0;
        int count=-1;
        closestDistance=PVector.dist(location,markers.get(0));
        
        for(PVector p : markers){
          count++;
          if(PVector.dist(location,p)<closestDistance){
            closestDistance=PVector.dist(location,p);
            index+=count;
            count=0;
          }
        }
        
        target=PVector.sub(markers.get(index),location);
      }
      catch(IndexOutOfBoundsException e){
        target=PVector.sub(new PVector(random(location.x-6,location.x+6),random(location.y-6,location.y+6)),location);
      }
    }
    else{
      target=PVector.sub(new PVector(mouseX,mouseY),location);
    }
    
    if(followMouse&&(PVector.dist(location,new PVector(mouseX,mouseY))<closestDistance||closestDistance==0)){
      target=PVector.sub(new PVector(mouseX,mouseY),location);
    }
    
    if(follow){
      target.setMag(speed);
    }
    else{
      target.setMag(-speed);
    }
    
    for(minion other : others){
      if(PVector.dist(location,other.location)<size/2+other.size/2+10&&PVector.dist(location,other.location)>0){
        target.add(PVector.sub(location,other.location));
      }
    }
    target.setMag(speed);
    
//    if(PVector.dist(location,other.location)<size/2+other.size/2+10){
//      target=PVector.sub(location,other.location);
//      target.setMag(speed);
//    }
//    else{
//      PVector mouse=new PVector(mouseX, mouseY);
//      target=PVector.sub(mouse, location);
//      target.setMag(speed);
//    }
    
    move(target);
    render();
  }

  void move(PVector target) {
    velocity.add(target);
    velocity.div(drag);
    location.add(velocity);
    
    if(location.x<0-size/2-5){
      location.set(width+size/2+5,location.y);
    }
    if(location.x>width+size/2+5){
      location.set(0-size/2-5,location.y);
    }
    if(location.y<0-size/2-5){
      location.set(location.x,height+size/2+5);
    }
    if(location.y>height+size/2+5){
      location.set(location.x,0-size/2-5);
    }
  }

  void render() {
    fill(colour);
    stroke(102);
    strokeWeight(3);
    ellipse(location.x, location.y, size, size);
  }
}

