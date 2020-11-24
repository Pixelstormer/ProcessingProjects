class Firework{
  PVector location;
  PVector velocity;
  PVector acceleration;
  PVector gravity;
  PVector thrust;
  float speed;
  float launchSpeed;
  float thrustTimer;
  float detonationLimit;

  Firework(PVector location){
    this.location = location.get();
    acceleration = new PVector(0,0);
    gravity = new PVector(0,random(rocketGravRange.x,rocketGravRange.y));
    speed = random(rocketVelocityRange.x,rocketVelocityRange.y);
    launchSpeed = random(rocketLaunchRange.x,rocketLaunchRange.y);
    thrustTimer = random(rocketThrustRange.x,rocketThrustRange.y);
    detonationLimit = random(rocketLimitRange.x,rocketLimitRange.y);
    
    thrust = new PVector(0,-speed);
    velocity = new PVector(0,-launchSpeed);
    
    velocity.rotate(radians(random(rocketAngleRange.x,rocketAngleRange.y)));
    thrust.rotate(radians(random(rocketAngleRange.x,rocketAngleRange.y)));
  }
  
  void update(){
    acceleration = new PVector(0,0);
    
    thrustTimer--;
    if(thrustTimer>0){
      velocity = thrust.get();
    }
    else{
      velocity.add(gravity);
    }
    
    PVector t = velocity.get();
    t.rotate(radians(random(-24,24)));
    activeParticles.add(new Particle(
      location.get(),
      t,
      new PVector(random(20),255,255),
      random(1,3),
      random(1.08,1.1),
      random(0.5,1.2),
      random(3,5)
    ));
    t.rotate(radians(180));
    activeParticles.add(new Particle(
      location.get(),
      t,
      new PVector(random(20),255,255),
      random(3,6),
      random(1.08,1.1),
      random(1,4),
      random(3,5)
    ));
    
    if(velocity.y>detonationLimit){
      rocketsToRemove.add(this);
      detonate();
    }
    
    if(DELTATIME){
      location.add(PVector.mult(velocity,deltaTime));
    }
    else{
      location.add(velocity);
    }
  }
  
  void detonate(){
    float a = 0;
    PVector c = new PVector(random(255),255,255);
    int numberOfParticles = int(random(rocketParticleRange.x,rocketParticleRange.y));
    for(int i=0;i<numberOfParticles;i++){
      a+=360/numberOfParticles;
      PVector l = location.get();
      PVector v = PVector.fromAngle(radians(a+random(particleAngleRange.x,particleAngleRange.y)));
      float s = random(particleSpeedRange.x,particleSpeedRange.y);
      float d = random(particleDragRange.x,particleDragRange.y);
      float vl = random(particleLimitRange.x,particleLimitRange.y);
      float S = random(particleSizeRange.x,particleSizeRange.y);
      activeParticles.add(new Particle(l,v,c,s,d,vl,S));
    }
    a = 0;
    c = new PVector(random(255),255,255);
    numberOfParticles = int(random(rocketParticleRange.x,rocketParticleRange.y));
    for(int i=0;i<numberOfParticles;i++){
      a+=360/numberOfParticles;
      PVector l = location.get();
      PVector v = PVector.fromAngle(radians(a+random(particleAngleRange.x,particleAngleRange.y)));
      float s = random(particleSpeedRange.x,particleSpeedRange.y);
      float d = random(particleDragRange.x,particleDragRange.y);
      float vl = random(particleLimitRange.x,particleLimitRange.y);
      float S = random(particleSizeRange.x,particleSizeRange.y);
      activeParticles.add(new Particle(l,v,c,s,d,vl,S));
    }
  }
  
  void render(){
    stroke(255,127,0);
    strokeWeight(5);
//    ellipse(location.x,location.y,5,5);
  }
}
