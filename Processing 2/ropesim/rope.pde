class Rope {
  List<Joint> segments;
  int size;
  float stretchTolerance;

  Rope(PVector origin, int size, float thickness, float stretchTolerance, float k, float damping) {
    this.size = size;
    this.stretchTolerance = stretchTolerance;
    this.segments = new ArrayList<Joint>(size);
    float len = size * thickness;
    PVector offset = new PVector(-len, 0);
    PVector difference = new PVector(thickness*2, 0);
    PVector point = PVector.add(origin, offset);
    offset.mult(-1);
    for (int i=0, j=this.size; i<j; i++) {
      this.segments.add(new Joint(point, DEFAULT_MASS, thickness, stretchTolerance, k, damping, false, false));
      point.add(difference);
    }
  }

  void iterate() {
    PVector old = this.segments.get(0).velocity.get();
    for (int i = 0; i < SPRING_ITERATIONS; i++) {
      final Iterator<Joint> it = this.segments.iterator();
      for (Joint next = (it.hasNext () ? it.next() : null), current = null; next != null; ) {
        Joint previous = current;
        current = next;
        next = it.hasNext() ? it.next() : null;

        current.iterate(previous, next);
      }
    }

    for (int x = 0; x < COLLISION_ITERATIONS; x++) {
      for (int i = 0, s = this.segments.size (); i < s; i++) {
        Joint first = this.segments.get(i);
        for (int j = i+1; j < s; j++) {
          // compare list.get(i) and list.get(j)
          Joint second = this.segments.get(j);
          first.collideWith(second);
        }
      }
    }

    //println("OLD: "+old.mag()+" NEW: "+this.segments.get(0).velocity.get().mag());
  }

  void render() {
    final Iterator<Joint> it = this.segments.iterator();
    for (Joint next = (it.hasNext () ? it.next() : null), current = null; next != null; ) {
      Joint previous = current;
      current = next;
      next = it.hasNext() ? it.next() : null;

      //stroke(120);
      //strokeWeight(current.radius*2);
      //if(previous!=null) line(previous.position.x, previous.position.y, current.position.x, current.position.y);

      stroke(map(noise(current.position.x*0.01, current.position.y*0.01), 0, 1, 0, 255));
      strokeWeight(current.radius*2);
      //strokeWeight(1);
      if (previous!=null) line(previous.position.x, previous.position.y, current.position.x, current.position.y);
      //current.render();
    }
  }

  Joint getLastJoint() {
    return this.segments.get(this.segments.size()-1);
  }

  class Joint {
    //A given point on a rope
    PVector position;
    PVector velocity;
    float radius;
    float stretchTolerance;
    float mass;
    float k;
    float damping;
    boolean xAnchored;
    boolean yAnchored;

    Joint(PVector position, float mass, float radius, float stretchTolerance, float k, float damping, boolean xAnchored, boolean yAnchored) {
      this.position = position.get();
      this.velocity = new PVector(0, 0);
      this.mass = mass;
      this.radius = radius;
      this.stretchTolerance = stretchTolerance;
      this.k = k;
      this.damping = damping;
      this.xAnchored = xAnchored;
      this.yAnchored = yAnchored;
    }

    PVector getBoundsConstraintOffset() {
      if (!SCREEN_CLAMPED) return new PVector(0, 0);

      PVector nextPosition = this.position.get();

      nextPosition.x = constrain(nextPosition.x, EDGE_LEFT, EDGE_RIGHT);
      nextPosition.y = constrain(nextPosition.y, EDGE_TOP, EDGE_FLOOR);

      return PVector.sub(nextPosition, this.position);
    }

    void addVelocity(PVector vel) {
      this.velocity.add(PVector.div(vel, this.mass));
      if(this.xAnchored) this.velocity.x = 0;
      if(this.yAnchored) this.velocity.y = 0;
    }

    void setVelocity(PVector vel) {
      this.velocity = vel.get();
      if(this.xAnchored) this.velocity.x = 0;
      if(this.yAnchored) this.velocity.y = 0;
    }

    void offsetPosition(PVector offset) {
      this.position.x += (this.xAnchored) ? 0 : offset.x;
      this.position.y += (this.yAnchored) ? 0 : offset.y;
    }

    void setPosition(PVector set) {
      this.position.x = (this.xAnchored) ? this.position.x : set.x;
      this.position.y = (this.yAnchored) ? this.position.y : set.y;
    }

    PVector calculateWeight(PVector gravity) {
      return PVector.mult(gravity, this.mass);
    }
    
    void anchor(){
      this.xAnchored = true;
      this.yAnchored = true;
    }
    
    void unAnchor(){
      this.xAnchored = false;
      this.yAnchored = false;
    }
    
    void flipAnchor(){
      this.xAnchored = !this.xAnchored;
      this.yAnchored = !this.yAnchored;
    }

    void addGravity(PVector gravity) {
      this.velocity.add(calculateWeight(gravity));
      if(this.xAnchored) this.velocity.x = 0;
      if(this.yAnchored) this.velocity.y = 0;
    }

    void iterate(Joint prev, Joint next) {
      this.addGravity(GRAVITY);

      subMag(this.velocity, DRAG_FORCE*this.velocity.mag());

      this.iterateWith(prev);

      this.iterateWith(next);

      this.offsetPosition(this.velocity);

      PVector boundsOffset = this.getBoundsConstraintOffset();
      this.position.add(boundsOffset);
      this.velocity.add(boundsOffset);
    }

    void iterateWith(Joint other) {
      // F = - kx - bv
      // k = spring constant (tightness)
      // x = distance from desired position
      // b = dampening coefficient
      // v  = relative velocity between the points

      // F = -this.k * dist - this.damping * relative velocity

      if (other == null) return;
      float dist = PVector.dist(this.position, other.position);
      float threshhold = this.stretchTolerance+other.stretchTolerance;
      if (dist > threshhold) {
        PVector rvel = PVector.sub(other.velocity, this.velocity);
        float F = -this.k*(dist-threshhold) - this.damping*rvel.mag();
        if (F > dist) F = dist;

        PVector dir = PVector.sub(this.position, other.position);
        dir.setMag(F);
        this.addVelocity(dir);
        dir.mult(-1);
        other.addVelocity(dir);
      }
    }

    void collideWith(Joint other) {
      if (other == null) return;
      float dist = PVector.dist(this.position, other.position);
      if (dist == 0) {
        PVector displacement = PVector.random2D();
        displacement.setMag(this.radius);
        this.offsetPosition(displacement);
        displacement.setMag(other.radius);
        displacement.mult(-1);
        other.offsetPosition(displacement);
        return;
      }

      if (dist < this.radius + other.radius) {
        //Joints are intersecting - Resolve!

        //Difference between sum of the radii and the distance between centerpoints
        //is how far 'into' eachother the intersection goes
        float angle = degrees(PVector.angleBetween(this.velocity, other.velocity));
        PVector additionalOffset = new PVector(0, 0);
        if (angle<SAME_ANGLE_TOLERANCE || abs(angle-180)<SAME_ANGLE_TOLERANCE) {
          PVector displacement = PVector.random2D();
          displacement.setMag(DEINTERSECTION_NOISE);
          additionalOffset.add(displacement);
        }

        float depth = abs(this.radius+other.radius-dist);
        PVector direction = PVector.sub(this.position, other.position);
        PVector centerpoint = PVector.add(PVector.mult(direction, 0.5), other.position);

        PVector jitter = PVector.random2D();
        jitter.setMag(DEINTERSECTION_RANDOMNESS);
        direction.add(jitter);
        direction.add(additionalOffset);

        float thisOffset = abs(this.radius - PVector.dist(this.position, centerpoint)) + EXTRA_COLLISION_SPACE;
        float otherOffset = abs(other.radius - PVector.dist(other.position, centerpoint)) + EXTRA_COLLISION_SPACE;

        float oldMag = this.velocity.mag();
        float otherMag = other.velocity.mag();

        direction.setMag(thisOffset);
        this.offsetPosition(direction);
        this.addVelocity(direction);
        if (this.velocity.mag() > oldMag) this.velocity.setMag(oldMag);
        subMag(this.velocity, FRICTION);
        direction.setMag(otherOffset);
        direction.mult(-1);
        other.offsetPosition(direction);
        other.addVelocity(direction);
        if (other.velocity.mag() > otherMag) other.velocity.setMag(otherMag);
        subMag(other.velocity, FRICTION);
      }
    }

    void render() {
      noFill();
      stroke(255);
      strokeWeight(1);
      ellipse(this.position.x, this.position.y, this.radius*2, this.radius*2);
      PVector vel = this.velocity.get();
      vel.mult(2);
      PVector end = PVector.add(this.position, this.velocity);
      stroke(255, 0, 255);
      line(this.position.x, this.position.y, end.x, end.y);

      stroke(255, 0, 0);
      //ellipse(this.position.x,this.position.y,this.stretchTolerance*2,this.stretchTolerance*2);
      fill(255);
      noStroke();
      //rect(this.position.x,this.position.y,5,5);
    }
  }
}

