class Bounds{
  //Min is inclusive, max is exclusive
  private final float min;
  private final float max;
  
  Bounds(float min, float max){
    if(min >= max)
      throw new IllegalArgumentException(String.format("Min was given illegal value %s which is greater than or equal to the given max %s. Min must be less than max.", min, max));
    this.min = min;
    this.max = max;
  }
  
  float getMin(){
    return min;
  }
  
  float getMax(){
    return max;
  }
  
  float generateValue(){
    return random(min, max);
  }
  
  boolean isInBounds(float value){
    return value >= min && value < max;
  }
}

