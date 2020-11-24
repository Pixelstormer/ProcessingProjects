class well{
  PVector location;
  int force;
  int size=45;
  boolean hole;
  boolean black;
  boolean dragged=false;
  
  well(PVector Location,int Force,boolean Hole, boolean Black){
    location=Location.get();
    force=Force;
    hole=Hole;
    black = Black;
  }
  
  void attract(ArrayList<photon> particles){
    for(photon p : particles){
      if(PVector.dist(location,p.location)<size/2&&hole){
        toRemove.add(p);
//        size++;
      }
      
      PVector pull=PVector.sub(location,p.location);
      pull.setMag(constrain(map(PVector.dist(location,p.location),0,size*3,force,0),0,1));
      pull.mult(black?1:-1);
      p.applyForce(pull);
    }
  }
  
  void render(){
    noFill();
    stroke(255);
    strokeWeight(3);
    ellipse(location.x,location.y,size,size);
  }
}

