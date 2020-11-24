class Vehicle {
  PVector location;
  PVector target=new PVector();
  PVector velocity=new PVector();
  int point=0;
  float speed;
  float size;

  Vehicle(float Speed, int x, int y) {
    location=new PVector(x, y);
    setTarget();
    speed=Speed;
    size=speed*2;
  }

  void render() {
    float theta = velocity.heading2D() + radians(90);
    fill(175);
    stroke(0);
    pushMatrix();
    translate(location.x, location.y);
    rotate(theta);
    beginShape(PConstants.TRIANGLES);
    vertex(0, -size*2);
    vertex(-size, size*2);
    vertex(size, size*2);
    endShape();
    popMatrix();
  }

  void followPath() {
    setTarget();
    velocity=PVector.sub(target, location);
    velocity.setMag(speed);
    location.add(velocity);

    try {
      if (location.dist(path.points.get(point+1))<1) {
        point++;
        target.set(path.points.get(point+1).x, path.points.get(point+1).y);
      }
      
      if(location.dist(path.points.get(point+1))<speed){
        location.set(path.points.get(point+1));
      }
    }
    catch(IndexOutOfBoundsException e) {
      point=0;
      target.set(path.points.get(0).x, path.points.get(0).y);
      location.set(path.points.get(0).x, path.points.get(0).y);
    }
  }

  void setTarget() {
    try {
      target.set(path.points.get(point+1).x, path.points.get(point+1).y);
    }
    catch(IndexOutOfBoundsException e) {
      target.set(path.points.get(0).x, path.points.get(0).y);
    }
  }
}

