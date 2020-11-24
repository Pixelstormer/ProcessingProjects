class ball {
  PVector location, velocity, acceleration;
  float drag;
  int interval, countdown, maxConnections;
  ArrayList<ball> connected;
  ArrayList<ball> rendered;
  ArrayList<ball> toRemove;

  ball(PVector initialPos, PVector initialVel, float Drag, int Countdown) {
    location=initialPos.get();
    velocity=initialVel.get();
    acceleration=new PVector(0, 0);
    drag=Drag;
    interval=200;
    countdown=Countdown;
    connected = new ArrayList<ball>();
    rendered = new ArrayList<ball>();
    toRemove = new ArrayList<ball>();
    maxConnections = 8;
  }

  void update() {
    countdown++;
    if (countdown>interval) {
      countdown=0;
      applyForce(new PVector(random(-10, 10), random(-10, 10)));
    }

    for (ball other : connected) {
      if(PVector.dist(location,other.location)>300){
        toRemove.add(other);
        other.toRemove.add(this);
        PVector snap = PVector.sub(location,other.location);
        snap.setMag(0.25);
        applyForce(snap);
        snap.mult(-1);
        other.applyForce(snap);
      }
      if (PVector.dist(location, other.location)>200) {
        PVector pull = PVector.sub(location, other.location);
        pull.setMag(-0.5);
        applyForce(pull);
      }
    }

    velocity.add(acceleration);
    velocity.div(drag);
    location.add(velocity);
    acceleration.set(0, 0);

    if (location.x>width) {
      velocity.x*=-1;
      location.x=width;
    }
    if (location.x<0) {
      velocity.x*=-1;
      location.x=0;
    }
    if (location.y>height) {
      velocity.y*=-1;
      location.y=height;
    }
    if (location.y<0) {
      velocity.y*=-1;
      location.y=0;
    }
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void collide(ball other) {

    boolean shared = false;

    for (ball connections : connected) {
      if (!(shared)) {
        shared = other.connected.contains(connections);
      }
    }

    if (PVector.dist(location, other.location)<15 && !(shared) && connected.size()<maxConnections && other.connected.size()<maxConnections) {
      connected.add(other);
    }
  }

  void renderLines() {
    for (ball connections : connected) {
      if (!(rendered.contains(connections))) {
        stroke(25, 25, 140);
        strokeWeight(constrain(map(PVector.dist(location, connections.location), 25, 200, 10, 2), 2, 7));
        line(location.x, location.y, connections.location.x, connections.location.y);
        connections.rendered.add(this);
      }
    }
    rendered.clear();
  }
  
  void renderBall(){
    noStroke();
    fill(25, 25, 200);
    ellipse(location.x, location.y, 15, 15);
  }
}

