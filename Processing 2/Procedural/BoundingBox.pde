class BoundingBox{
  //Represents a rectangular box
  public final long realWidth;
  public final long realHeight;
  public final long halfWidth;
  public final long halfHeight;
  public final long centerpointX;
  public final long centerpointY;
  public final long leftEdgeX;
  public final long rightEdgeX;
  public final long topEdgeY;
  public final long bottomEdgeY;
  public final float elasticity;
  
  BoundingBox(long Width, long Height, long centerX, long centerY, float elasticity){
    realWidth = Width;
    realHeight = Height;
    halfWidth = Width/2;
    halfHeight = Height/2;
    centerpointX = centerX;
    centerpointY = centerY;
    leftEdgeX = centerX - halfWidth;
    rightEdgeX = centerX + halfWidth;
    topEdgeY = centerY - halfHeight;
    bottomEdgeY = centerY + halfHeight;
    this.elasticity = elasticity;
  }
  
  boolean isInside(long x, long y){
    return x > leftEdgeX
        && x < rightEdgeX
        && y > topEdgeY
        && y < bottomEdgeY;
  }
  
  PVector getCollisionDirections(PVector point){
    PVector directions = new PVector(0, 0);
    if(point.x < leftEdgeX)
      directions.x = -1;
    if(point.x > rightEdgeX)
      directions.x = 1;
    if(point.y > bottomEdgeY)
      directions.y = 1;
    if(point.y < topEdgeY)
      directions.y = -1;
    return directions;
  }
  
  boolean isInside(PVector point){
    return isInside((long)point.x, (long)point.y);
  }
  
  PVector offsetPointToEdge(PVector point){
    PVector adjusted = point.get();
    adjusted.x += ((adjusted.x<=centerpointX) ? leftEdgeX : rightEdgeX) - adjusted.x;
    adjusted.y += ((adjusted.y<=centerpointY) ? topEdgeY : bottomEdgeY) - adjusted.y;
    return PVector.sub(adjusted, point);
  }
}

