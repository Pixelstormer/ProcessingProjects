class Snake{
  Body body;
  
  Snake(int Length, PVector Origin){
    this.body = new Body(Length,Origin.get());
  }
  
  void iteratePhysics(List<Snake> toCollide){
    this.body.iteratePhysics(toCollide);
  }
  
  void Render(){
    this.body.Render();
  }
  
  class Body{
    Head head;
    List<Segment> body;
    float totalWeight;
    
    Body(int Length,PVector Origin){
      if(Length<3){
        throw new IllegalArgumentException(String.format("Given an illegal body length of %s when minimum body length is 3.",Length));
      }
      
      PVector extendDir = PVector.random2D();
      extendDir.setMag(SEGMENT_DIAMETER);
      float turnAngle = radians(random(MIN_TURN_ANGLE,MAX_TURN_ANGLE));
      PVector segmentLocation = Origin.get();
      
      this.head = new Head(Origin);
      this.totalWeight = this.head.weight;
      
      this.body = new ArrayList<Segment>();
      for(int i=0;i<Length-1;i++){
        segmentLocation.add(extendDir);
        extendDir.rotate(turnAngle);
        this.body.add(new Segment(segmentLocation));
        this.totalWeight += this.body.get(i).weight;
      }
//      segmentLocation.add(extendDir);
//      extendDir.rotate(turnAngle);
    }
    
    void iteratePhysics(List<Snake> toCollide){
      //Function to apply one iteration of 'natural' physics, ie. gravity and collision.
      PVector g = GRAVITY();
      
      PVector force = PVector.sub(mouse,head.getLocation());
      force.setMag((mousePressed)?PULL_FORCE:0);
      
      if(inputs[0]) force.add(new PVector(-MOVE_FORCE,0));
      if(inputs[1]) force.add(new PVector(MOVE_FORCE,0));
      if(inputs[2]) force.add(new PVector(0,MOVE_FORCE));
      if(inputs[3]) force.add(new PVector(0,-(MOVE_FORCE+GRAVITY_MAG)));
      
//      for(Segment s : body){
//        if(s.touchingSurface){
//          s.forceAddVelocity(force);
//        }
//      }
      
      if(this.head.touchingSurface){
        this.head.forceAddVelocity(force);
      }
      
      this.head.iteratePhysics(g);
      for(Segment s : this.body){
        s.iteratePhysics(g);
      }
      
      this.collideWith(toCollide);
      
      this.reconnectSegments();
      this.resolveSelfIntersection();
    }
    
    void collideWith(List<Snake> toCollide){
      for(Snake s : toCollide){
        for(Segment S : this.body){
          S.collide(s.body.body);
        }
        for(Segment S : s.body.body){
          S.collide(this.body);
        }
      }
    }
    
    void reconnectSegments(){
      //Function to properly realign segments that have moved away from (or into) eachother
      this.body.get(0).shimmy(this.head);
      for(int i=1;i<this.body.size();i++){
        this.body.get(i).shimmy(this.body.get(i-1));
      }
    }
    
    void resolveSelfIntersection(){
      //Function to resolve collisions and intersections between this own body's segments
      this.head.collide(this.body);
      for(int i=0;i<this.body.size();i++){
        List<Segment> toCollide = body.subList(i,body.size());
        this.body.get(i).collide(toCollide);
      }
    }
    
    void Render(){
      head.Render();
      for(Segment s : this.body){
        s.Render();
      }
    }
    
    class Head extends Segment{
      Head(PVector Location){
        super(Location);
      }
      
      void Render(){
        stroke(255);
        strokeWeight(3);
        noFill();
        ellipse(this.Location.x,this.Location.y,SEGMENT_DIAMETER,SEGMENT_DIAMETER);
      }
    }
    
    class Segment{
      protected PVector Location;
      protected PVector Velocity;
      float weight;
      boolean touchingSurface;
      boolean isAsleep;
      
      Segment(PVector Location){
        this.Location = Location.get();
        this.Velocity = new PVector(0,0);
        this.weight = DEFAULT_WEIGHT;
        this.touchingSurface = false;
        this.isAsleep = false;
      }
      
      void Render(){
        noStroke();
        fill(255);
        ellipse(this.Location.x,this.Location.y,SEGMENT_DIAMETER,SEGMENT_DIAMETER);
      }
      
      PVector getLocation(){
        return this.Location.get();
      }
      
      PVector getVelocity(){
        return this.Velocity.get();
      }
      
      void offsetLocation(PVector offset){
        this.Location.add(offset);
      }
      
      void forceSetVelocity(PVector vel){
        this.Velocity = vel.get();
      }
      
      void forceAddVelocity(PVector force){
        this.Velocity.add(force);
        this.updateAsleep();
      }
      
      void updateAsleep(){
        this.isAsleep = this.Velocity.mag()<=SLEEP_TOLERANCE;
        if(this.Velocity.mag()<=SLEEP_TOLERANCE){
          this.Velocity.setMag(0);
        }
      }
      
      void iteratePhysics(PVector totalAcceleration){
        this.touchingSurface = false;
        this.Velocity.add(totalAcceleration);
        this.Velocity.mult(NATURAL_DRAG);
        this.Location.add(Velocity);
        this.limitToBounds();
        this.updateAsleep();
      }
      
      void shimmy(Segment target){
        //'Shimmies' this segment right up to the given target segment,
        //or moves this segment away if they are too close together.
        if(PVector.dist(this.Location,target.getLocation())>SEGMENT_DIAMETER+FUDGE_TOLERANCE){
          PVector offset = PVector.sub(target.getLocation(),this.Location);
          offset.setMag(offset.mag()-SEGMENT_DIAMETER);
          this.offsetLocation(offset);
        }
      }
      
      void collide(List<Segment> toCollide){
        for(Segment s : toCollide){
          if(!(s.isAsleep && this.isAsleep)){
            float minDist = SEGMENT_DIAMETER-FUDGE_TOLERANCE;
            float distance = PVector.dist(this.Location,s.getLocation());
            PVector offset = PVector.sub(this.Location,s.getLocation());
            if(distance<minDist){
              this.touchingSurface = true;
              this.isAsleep = false;
              s.isAsleep = false;
              if(distance == 0){
                offset = this.Velocity.get();
              }
              else{
                float difference = abs(minDist-distance);
                difference/=2;
                offset.setMag(difference);
              }
              this.offsetLocation(offset);
              this.forceAddVelocity(offset);
              this.Velocity.mult(NATURAL_FRICTION);
              offset.mult(-1);
              s.offsetLocation(offset);
              s.forceAddVelocity(offset);
              s.forceSetVelocity(PVector.mult(s.getVelocity(),NATURAL_FRICTION));
            }
          }
        }
      }
      
      void limitToBounds(){
        if(this.Location.x+SEGMENT_DIAMETER>width-NEGATIVE_INDENT.x) {
          this.Location.x=width-NEGATIVE_INDENT.x-SEGMENT_DIAMETER;
          this.Velocity.x=0;
          this.Velocity.y*=NATURAL_FRICTION;
          this.touchingSurface = true;
        }
        if (this.Location.x-SEGMENT_DIAMETER<POSITIVE_INDENT.x) {
          this.Location.x=POSITIVE_INDENT.x+SEGMENT_DIAMETER;
          this.Velocity.x=0;
          this.Velocity.y*=NATURAL_FRICTION;
          this.touchingSurface = true;
        }
        if (this.Location.y+SEGMENT_DIAMETER>height-NEGATIVE_INDENT.y) {
          this.Location.y=height-NEGATIVE_INDENT.y-SEGMENT_DIAMETER;
          this.Velocity.y=0;
          this.Velocity.x*=NATURAL_FRICTION;
          this.touchingSurface = true;
        }
        if (this.Location.y-SEGMENT_DIAMETER<POSITIVE_INDENT.y) {
          this.Location.y=POSITIVE_INDENT.y+SEGMENT_DIAMETER;
          this.Velocity.y=0;
          this.Velocity.x*=NATURAL_FRICTION;
          this.touchingSurface = true;
        }   
      }
      
      boolean wouldCollide(PVector point){
        return PVector.dist(point,this.Location)<SEGMENT_DIAMETER;
      }
    }
  }
}

