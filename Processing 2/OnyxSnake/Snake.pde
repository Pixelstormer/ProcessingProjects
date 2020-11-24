class Snake {
  private final int segmentCount;
  private final float segmentSize;
  private final PVector headPosition;
  private final Segment[] segments;
  private final float restingDistance;
  private final float tension;

  Snake(PVector headPosition, int segmentCount, float restingDistance, float tension, float segmentSize) {    
    this.segmentCount = segmentCount;
    this.segmentSize = segmentSize;
    this.restingDistance = restingDistance;
    this.headPosition = headPosition.get();
    this.tension = tension;
    segments = new Segment[segmentCount];
    createSegments(headPosition, segmentCount, restingDistance, segmentSize);
  }

  private void createSegments(PVector headPosition, int count, float restingDistance, float segmentSize) {
    PVector segmentPosition = headPosition.get();
    for (int i=0; i<segmentCount; i++) {
      segments[i] = new Segment(segmentPosition, segmentSize);
      segmentPosition.x -= restingDistance;
    }
  }

  void update() {
    segments[0].position().lerp(headPosition, tension);
    segments[0].lerpAngle(angleTo(segments[0].getPosition(), headPosition), tension);
    for(int i=1; i<segmentCount; i++){
      PVector target = PVector.add(segments[i-1].getPosition(), getWithMag(PVector.sub(segments[i].getPosition(), segments[i-1].getPosition()), restingDistance));
      segments[i].position().lerp(target, tension);
      segments[i].lerpAngle(angleTo(segments[i].getPosition(), target), tension);
    }
  }

  void render() {
    for (Segment s : segments) {
      s.render();
    }
  }
  
  PVector getHeadPosition(){
    return headPosition.get();
  }
  
  void setHeadPosition(PVector to){
    headPosition.set(to.x, to.y, to.z);
  }
  
  void offsetHeadPosition(PVector by){
    headPosition.add(by);
  }
  
  float distanceToHead(){
    return PVector.dist(segments[0].getPosition(), headPosition);
  }

  class Segment {
    private final PVector position;
    private final float size;
    private float angle;

    Segment(PVector origin, float size) {
      position = origin.get();
      this.size = size;
      angle = 0;
    }

    void render() {
      noStroke();
      fill(160);
      pushMatrix();
      translate(position.x, position.y);
      rotate(radians(angle+45));
      square(0, 0, size);
      popMatrix();
    }
    
    PVector position(){
      return position;
    }
    
    PVector getPosition(){
      return position.get();
    }
    
    float getAngle(){
      return angle;
    }
    
    void setPosition(PVector to){
      position.set(to.x, to.y, to.z);
    }
    
    void offsetPosition(PVector offset){
      position.add(offset);
    }
    
    void setAngle(float to){
      angle = to;
    }
    
    void lerpAngle(float to, float amt){
      angle = lerp(angle, to, amt);
    }
  }
}

