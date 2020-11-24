class track{
  ArrayList<point> points;
  
  track(){
    points=new ArrayList<point>();
  }
  
  void render(){
    noFill();
    stroke(88);
    strokeWeight(116);
    beginShape();
    curveVertex(points.get(0).location.x,points.get(0).location.y);
    for(point p : points){
      curveVertex(p.location.x,p.location.y);
    }
    curveVertex(points.get(0).location.x,points.get(0).location.y);
    curveVertex(points.get(0).location.x,points.get(0).location.y);
    endShape();
    
    image(goalSprite,points.get(0).location.x,points.get(0).location.y,64,118);
  }
  
  void addPoint(PVector Location,boolean isWaypoint){
    points.add(new point(Location,isWaypoint));
  }
}

