class DebugLine{
  //This class depends heavily on PVectors being passed by reference
  
  //Colour to render
  PVector colour;
  //Origin point of line
  PVector originPoint;
  //A vector, assigned by reference, that is the offset
  PVector offsetVector;
  //Offset but scaled by this.scalar
  PVector scaledOffset;
  //The resulting end of the line
  PVector endPoint;
  //Scalar to make line more visible
  float scalar;
  
  DebugLine(PVector colour, PVector originPoint, PVector offsetVector, float scalar){
    this.colour = colour.get();
    this.originPoint = originPoint;
    this.offsetVector = offsetVector;
    //this.scaledOffset = PVector.mult(offsetVector,scalar);
    this.endPoint = PVector.add(originPoint,offsetVector);
    this.scalar = scalar;
    //endPoint is calculated and updated each iteration from other vectors
  }
  
  void update(){
    this.scaledOffset = PVector.mult(this.offsetVector,this.scalar);
    this.endPoint = PVector.add(this.originPoint,this.scaledOffset);
  }
  
  void update(PVector offsetVector){
    //Manual update with an explicitly provided offset vector
    this.scaledOffset = PVector.mult(offsetVector,this.scalar);
    this.endPoint = PVector.add(this.originPoint,this.scaledOffset);
  }
  
  void render(){
    strokeWeight(3);
    stroke(this.colour.x,this.colour.y,this.colour.z);
    line(this.originPoint.x,this.originPoint.y,this.endPoint.x,this.endPoint.y);
  }
}

