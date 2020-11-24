class mirror{
  PVector mirrorLeft,mirrorRight;
  PVector[] points;
  boolean leftDragged,rightDragged;
  PVector delta,normal;
  
  mirror(PVector left,PVector right){
    mirrorLeft=left.get();
    mirrorRight=right.get();
    move();
  }
  
  void update(){
    delta=PVector.sub(mirrorRight,mirrorLeft);
    delta.normalize();
    
    normal=new PVector(-delta.y,delta.x);
  }
  
  void move(){
    float mirrorLength=PVector.dist(mirrorLeft,mirrorRight);
    points=new PVector[ceil(mirrorLength)];
    for(int i=0;i<points.length;i++){
      points[i]=new PVector(mirrorLeft.x+((mirrorRight.x-mirrorLeft.x)/mirrorLength)*i,
                            mirrorLeft.y+((mirrorRight.y-mirrorLeft.y)/mirrorLength)*i);
    }
  }
  
  void render(){
    stroke(#B8E1F0);
    strokeWeight(5);
    line(mirrorLeft.x,mirrorLeft.y,mirrorRight.x,mirrorRight.y);
    noStroke();
  }
}
