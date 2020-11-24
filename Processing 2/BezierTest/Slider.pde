class Slider{
  private final PVector startPoint;
  private final PVector endPoint;
  private final float minValue;
  private final float maxValue;
  private float currentPercent;
  
  Slider(PVector startPoint, PVector endPoint, float min, float max){
    this(startPoint, endPoint, min, max, 0);
  }
  
  Slider(PVector startPoint, PVector endPoint, float min, float max, float startPercent){
    if(currentPercent < 0 || currentPercent > 1)
      throw new IllegalArgumentException("Percent has to be between 0 and 1, but was given a value outside of that range: "+startPercent);
    if(max <= min)
      throw new IllegalArgumentException(String.format("Max value has to be greater than min value, but was given value %s which is less than or equal to min value %s.", max, min));
    this.startPoint = startPoint.get();
    this.endPoint = endPoint.get();
    minValue = min;
    maxValue = max;
    currentPercent = startPercent;
  }
  
  float getValue(){
    return currentPercent*(maxValue - minValue) + minValue;
  }
  
  float getPercentAlong(PVector point){
    float startDist = PVector.sub(point, startPoint).mag();
    float endDist = PVector.sub(point, endPoint).mag();
    return startDist / PVector.dist(startPoint, endPoint);
  }
  
  void setPercent(float percent){
    if(percent < 0 || percent > 1)
      throw new IllegalArgumentException("Tried to set percent to value outside of range (0, 1): Illegal value "+percent);
    currentPercent = percent;
  }
  
  boolean isIntersecting(PVector point){
    float k = ((endPoint.y-startPoint.y) * (point.x-startPoint.x) - (endPoint.x-startPoint.x) * (point.y-startPoint.y)) / (sq(endPoint.y-startPoint.y) + sq(endPoint.x-startPoint.x));
    float x4 = point.x - k * (endPoint.y-startPoint.y);
    float y4 = point.y + k * (endPoint.x-startPoint.x);
    float percentAlong = getPercentAlong(point);
    return PVector.sub(new PVector(x4, y4), point).mag() <= 10 && percentAlong >= 0 && percentAlong <= 1;
  }
  
  boolean isIntersectingKnob(PVector point){
    return PVector.dist(point, PVector.lerp(startPoint, endPoint, currentPercent)) <= 20;
  }
  
  void render(){
    stroke(150);
    strokeWeight(16);
    line(startPoint, endPoint);
    noFill();
    stroke(255);
    strokeWeight(4);
    circle(PVector.lerp(startPoint, endPoint, currentPercent), 20);
  }
}


