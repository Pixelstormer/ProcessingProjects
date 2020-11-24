class BoundingBox extends CollideableObject{
  //Represents a rectangular perimeter
  
  private final PVector centerPoint;
  private float leftEdge;
  private float rightEdge;
  private float topEdge;
  private float bottomEdge;
  private float fullWidth;
  private float fullHeight;
  private float halfWidth;
  private float halfHeight;
  
  public BoundingBox(float elasticity, float friction, PVector centerPoint, float fullWidth, float fullHeight){
    super(elasticity, friction);
    this.centerPoint = centerPoint.get();
    this.fullWidth = fullWidth;
    this.fullHeight = fullHeight;
    halfWidth = fullWidth/2;
    halfHeight = fullHeight/2;
    leftEdge = centerPoint.x - halfWidth;
    rightEdge = centerPoint.x + halfWidth;
    topEdge = centerPoint.y - halfHeight;
    bottomEdge = centerPoint.y - halfHeight;
  }
  
  public BoundingBox(float elasticity, float friction, float leftEdge, float topEdge, float fullWidth, float fullHeight){
    super(elasticity, friction);
    this.leftEdge = leftEdge;
    this.topEdge = topEdge;
    this.fullWidth = fullWidth;
    this.fullHeight = fullHeight;
    halfWidth = fullWidth/2;
    halfHeight = fullHeight/2;
    rightEdge = leftEdge + fullWidth;
    bottomEdge = topEdge + fullHeight;
    centerPoint = new PVector(leftEdge + halfWidth, topEdge + halfHeight);
  }
  
  @Override
  boolean isIntersecting(PVector point){
    return point.x > leftEdge
        && point.x < rightEdge
        && point.y > topEdge
        && point.y < bottomEdge;
  }
  
  @Override
  PVector closestPointTo(PVector point){
    float x = point.x;
    float y = point.y;
    x = constrain(x, leftEdge, rightEdge);
    y = constrain(y, topEdge, bottomEdge);
    
    float distanceToLeft = abs(x-leftEdge);
    float distanceToRight = abs(x-rightEdge);
    float distanceToTop = abs(y-topEdge);
    float distanceToBottom = abs(y-bottomEdge);
    float smallestDistance = min(distanceToLeft, distanceToRight, distanceToTop, distanceToBottom);
  
    if(smallestDistance == distanceToTop)
      return new PVector(x, topEdge);
    if(smallestDistance == distanceToBottom)
      return new PVector(x, bottomEdge);
    if(smallestDistance == distanceToLeft)
      return new PVector(leftEdge, y);
    return new PVector(rightEdge, y);
  }
  
//  @Override
//  void constrainToBounds(BoundingBox bounds){
//    if(leftEdge < bounds.getLeftEdge())
//      offsetCenterPoint(bounds.getLeftEdge() - leftEdge, 0);
//    if(rightEdge > bounds.getRightEdge())
//      offsetCenterPoint(bounds.getRightEdge() - rightEdge, 0);
//    if(topEdge < bounds.getTopEdge())
//      offsetCenterPoint(0, bounds.getTopEdge() - topEdge);
//    if(bottomEdge > bounds.getBottomEdge)
//      offsetCenterPoint(0, bounds.getBottomEdge() - bottomEdge);
//  }
  
  PVector getCenterPoint(){
    return centerPoint.get();
  }
  
  float getLeftEdge(){
    return leftEdge;
  }
  
  float getRightEdge(){
    return rightEdge;
  }
  
  float getTopEdge(){
    return topEdge;
  }
  
  float getBottomEdge(){
    return bottomEdge;
  }
  
  float getFullWidth(){
    return fullWidth;
  }
  
  float getFullHeight(){
    return fullHeight;
  }
  
  float getHalfWidth(){
    return halfWidth;
  }
  
  float getHalfHeight(){
    return halfHeight;
  }
  
  void setCenterPoint(PVector newCenter){
    centerPoint.set(newCenter.x, newCenter.y);
    leftEdge = newCenter.x - halfWidth;
    rightEdge = newCenter.x + halfWidth;
    topEdge = newCenter.y - halfHeight;
    bottomEdge = newCenter.y + halfHeight;
  }
  
  void offsetCenterPoint(PVector offset){
    centerPoint.add(offset);
    leftEdge += offset.x;
    rightEdge += offset.x;
    topEdge += offset.y;
    bottomEdge += offset.y;
  }
  
  void setCenterPoint(float newX, float newY){
    centerPoint.set(newX, newY);
    leftEdge = newX - halfWidth;
    rightEdge = newX + halfWidth;
    topEdge = newY - halfHeight;
    bottomEdge = newY - halfHeight;
  }
  
  void offsetCenterPoint(float xOffset, float yOffset){
    centerPoint.add(xOffset, yOffset, 0);
    leftEdge += xOffset;
    rightEdge += xOffset;
    topEdge += yOffset;
    bottomEdge += yOffset;
  }
  
  void setLeftEdge(float newLeftEdge){
    leftEdge = newLeftEdge;
    centerPoint.x = newLeftEdge + halfWidth;
  }
  
  void setRightEdge(float newRightEdge){
    rightEdge = newRightEdge;
    centerPoint.x = newRightEdge - halfWidth;
  }
  
  void setTopEdge(float newTopEdge){
    topEdge = newTopEdge;
    centerPoint.y = newTopEdge + halfHeight;
  }
  
  void setBottomEdge(float newBottomEdge){
    bottomEdge = newBottomEdge;
    centerPoint.y = newBottomEdge - halfHeight;
  }
  
  void setEdges(float left, float top, float right, float bottom){
    setLeftEdge(left);
    setRightEdge(right);
    setTopEdge(top);
    setBottomEdge(bottom);
  }
  
  void setWidth(float newWidth){
    fullWidth = newWidth;
    halfWidth = newWidth/2;
    leftEdge = centerPoint.x - halfWidth;
    rightEdge = centerPoint.y + halfWidth;
  }
  
  void setHeight(float newHeight){
    fullHeight = newHeight;
    halfHeight = newHeight/2;
    topEdge = centerPoint.y - halfHeight;
    bottomEdge = centerPoint.y + halfHeight;
  }
}

