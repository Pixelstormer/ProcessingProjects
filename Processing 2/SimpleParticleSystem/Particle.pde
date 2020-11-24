// A simple Particle class

class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  float magnitude;
  float radius;

  Particle(PVector l, float Magnitude, float r) {
    acceleration = new PVector(0,0.05);
    velocity = new PVector(random(-0.4,0.4),random(-0.4,0.4));
    location = l.get();
    magnitude=Magnitude;
    lifespan = 1000;
    radius=r;
  }

  void run() {
    update();
    display();
  }

  // Method to update location
  void update() {
    PVector target=new PVector(mouseX,mouseY);
    PVector acceleration=PVector.sub(target,location);
    acceleration.setMag(magnitude);
    velocity.add(acceleration);
    location.add(velocity);
    if(location.x<radius||location.x>width-radius){
      velocity.x*=-1;
    }
    if(location.y<radius||location.y>height-radius){
      velocity.y*=-1;
    }
    lifespan -= 1.0;
  }
  
  void collision(){
    for(Particle p : ps.particles){
      float distance=dist(p.location.x,p.location.y,location.x,location.y);
      if(distance<radius/2){
        float angle=atan2(p.location.y,p.location.x);
        float targetX=location.x+cos(angle)*radius/2;
        float targetY=location.y+sin(angle)*radius/2;
        float ax=targetX-p.location.x;
        float ay=targetY-p.location.y;
        
        
        velocity.x*=-1;
        velocity.y*=-1;
        p.velocity.x*=-1;
        p.velocity.y*=-1;
      }
    }
  }

  // Method to display
  void display() {
    stroke(255,lifespan);
    fill(255,lifespan);
    ellipse(location.x,location.y,radius,radius);
  }
  
  // Is the particle still useful?
  boolean isDead() {
    if (lifespan < 0.0) {
      return true;
    } else {
      return false;
    }
  }
}

