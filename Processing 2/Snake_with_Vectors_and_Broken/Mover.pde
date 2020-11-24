class Mover {

  // The Mover tracks location, velocity, acceleration and drag.
  PVector location;
  PVector velocity;
  PVector acceleration;
  float drag=1.02;

  Mover() {
    // Start in the center
    location = new PVector(width/2,height/2);
    velocity = new PVector(0,0);
  }

  void update() {
    
    // Compute a vector that points from location to mouse
    PVector target = new PVector(targetX,targetY);
    PVector acceleration = PVector.sub(target,location);
    
    if(PVector.dist(target,location)>20){
      drag=1.1;
    }
    else{
      drag=1.2;
    }
    
    if(PVector.dist(target,location)>3){
      // Set magnitude of acceleration
      acceleration.setMag(0.8);
      // Velocity changes according to acceleration
      velocity.add(acceleration);
      //Add drag
      velocity.div(drag);
      // Location changes by velocity
      location.add(velocity);
    }
    else{
      velocity.set(0,0);
    }
  }
}

