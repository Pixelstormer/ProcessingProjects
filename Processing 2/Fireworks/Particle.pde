class Particle{
  PVector location;
  PVector velocity;
  PVector colour;
  float drag;
  float velocityLimit;
  float size;
  
  Particle(PVector location,PVector velocity, PVector colour, float Speed, float Drag, float VelocityLimit, float Size){
    this.location = location.get();
    this.velocity = velocity.get();
    this.velocity.setMag(Speed);
    this.colour = colour.get();
    drag = Drag;
    velocityLimit = VelocityLimit;
    size = Size;
  }
  
  void update(){
    velocity.div(drag);
    location.add(velocity);
    if(velocity.mag()<=velocityLimit){
      particlesToRemove.add(this);
    }
  }
  
  void render(){
    colorMode(HSB);
    stroke(colour.x,colour.y,colour.z);
    strokeWeight(velocity.mag());
    point(location.x,location.y);
    colorMode(RGB);
  }
}

