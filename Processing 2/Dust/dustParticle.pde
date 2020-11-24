class dustParticle{
  PVector location;
  PVector oldLocation;
  PVector offset;
  float size;
  float speed;
  float opacity;
  float dispersion;
  
  
  dustParticle(PVector Loc, PVector Offset, float Size, float Speed, float Opa, float Disp){
    location = Loc.get();
    oldLocation = location.get();
    offset = Offset.get();
    size = Size;
    speed = Speed;
    opacity = Opa;
    dispersion = Disp;
  }
  
  void applyWind(PVector wind){
    wind.add(offset);
    PVector newWind = PVector.mult(wind,speed);
    oldLocation = location.get();
    location.add(newWind);
  }
  
  void checkBoundries(){
    if(location.x+size/2<0){
      location.x=width+size/2;
      location.y+=random(-dispersion/2,dispersion/2);
    }
    if(location.x-size/2>width){
      location.x=0-size/2;
      location.y+=random(-dispersion/2,dispersion/2);
    }
    if(location.y+size/2<0){
      location.y=height+size/2;
      location.x+=random(-dispersion/2,dispersion/2);
    }
    if(location.y-size/2>height){
      location.y=0-size/2;
      location.x+=random(-dispersion/2,dispersion/2);
    }
  }
  
  void render(){
    strokeWeight(size);
    stroke(255,opacity);
    line(oldLocation.x,oldLocation.y,location.x,location.y);
  }
}


