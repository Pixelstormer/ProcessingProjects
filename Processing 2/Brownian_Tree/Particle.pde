class Particle{
  private PVector Location;
  private int highlightDuration;
  
  Particle(PVector origin){
    this.Location = origin.get();
    this.highlightDuration = HIGHLIGHT_FRAME_DURATION;
  }
  
  PVector getLocation(){
    return this.Location.get();
  }
  
  void Render(PGraphics targetSurface){
    float highlight = map(this.highlightDuration,HIGHLIGHT_FRAME_DURATION,0,0,255);
    targetSurface.noStroke();
    targetSurface.fill(PARTICLE_COLOUR.x,highlight,highlight);
    //targetSurface.colorMode(HSB);
    //targetSurface.fill(random(255),255,255);
    targetSurface.ellipse(this.Location.x,this.Location.y,PARTICLE_SIZE,PARTICLE_SIZE);
   if(this.highlightDuration>0){
      this.highlightDuration--;
    }
  }
  
  void performNaturalMovement(){
    float xDisplacement = random(BROWNIAN_X_MOTION.x,BROWNIAN_X_MOTION.y);
    float yDisplacement = random(BROWNIAN_Y_MOTION.x,BROWNIAN_Y_MOTION.y);
    PVector totalDisplacement = new PVector(xDisplacement,yDisplacement);
    PVector motionHint = PVector.sub(new PVector(X_SIZE/2,Y_SIZE/2),this.Location);
    motionHint.setMag(MOTION_HINT_MAGNITUDE);
    totalDisplacement.add(motionHint);
    this.Location = limitToBounds(PVector.add(this.Location,totalDisplacement));
  }
  
  boolean checkForCollision(ArrayList<Particle> toCollide){
    for(Particle p : toCollide){
      if(PVector.dist(this.Location,p.getLocation())<=PARTICLE_SIZE){
        PVector deIntersectDisplacement = PVector.sub(this.Location,p.getLocation());
        deIntersectDisplacement.setMag(PARTICLE_SIZE);
        this.Location = PVector.add(p.getLocation(),deIntersectDisplacement);
        return true;
      }
    }
    return false;
  }
}

