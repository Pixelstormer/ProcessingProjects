class Arc{
  private final PVector position;
  private final float angle;
  private final ArrayList<Segment> segments;
  private final int maxSegments;
  
  //Bounds for segment randomness
  private final Bounds angleDeviationBounds;
  private final Bounds growthSpeedBounds;
  private final Bounds growthTimeBounds;
  
  Arc(PVector origin, float angle, int maxSegments, Bounds angleBounds, Bounds growthBounds, Bounds timeBounds){
    this.position = origin.get();
    this.angle = angle;
    this.maxSegments = maxSegments;
    segments = new ArrayList<Segment>();
    angleDeviationBounds = angleBounds;
    growthSpeedBounds = growthBounds;
    growthTimeBounds = timeBounds;
    segments.add(generateSegment(origin));
  }
  
  Segment getActiveSegment(){
    return segments.get(segments.size()-1);
  }
  
  boolean isFinished(){
    return segments.size() >= maxSegments;
  }
  
  void update(){
    Segment activeSegment = getActiveSegment();
    activeSegment.update();
    if(segments.size() < maxSegments && activeSegment.isFinished()){
      segments.add(generateSegment(activeSegment.getHeadPosition()));
    }
  }
  
  void render(){
    for(Segment s : segments){
      s.render();
    }
  }
  
  Segment generateSegment(PVector origin){
    return new Segment(origin,
                       angle + angleDeviationBounds.generateValue(),
                       growthSpeedBounds.generateValue(),
                       growthTimeBounds.generateValue()); 
  }
  
  class Segment{
    private final PVector start;
    private final PVector head;
    private final PVector heading;
    private final float growthTime;
    private float elapsedTime;
    private boolean finished;
    
    Segment(PVector start, float angle, float growthSpeed, float growthTime){
      this.start = start.get();
      head = start.get();
      heading = new PVector(growthSpeed, 0);
      heading.rotate(radians(angle));
      this.growthTime = growthTime;
      elapsedTime = 0;
      finished = false;
    }
    
    PVector getHeadPosition(){
      return head.get();
    }
    
    boolean isFinished(){
      return finished;
    }
    
    void update(){
      if(!finished)
        head.add(heading);
      elapsedTime += frameRate/60;
      if(elapsedTime >= growthTime)
        finished = true;
    }
    
    void render(){
      strokeCap(ROUND);
      stroke(180, 180, 255);
      strokeWeight(5);
      line(start.x, start.y, head.x, head.y);
//      stroke(255);
//      strokeWeight(2);
//      line(start.x, start.y, head.x, head.y);
    }
  }
}

