class DraggablePoint{
  private final PVector location;
  private final float diameter;
  private final float radius;
  private final String flavourText;
  
  DraggablePoint(PVector location, float diameter, String flavourText){
    this.location = location.get();
    this.diameter = diameter;
    radius = diameter/2;
    this.flavourText = flavourText;
  }
  
  DraggablePoint(float locationX, float locationY, float diameter, String flavourText){
    this(new PVector(locationX, locationY), diameter, flavourText);
  }
  
  DraggablePoint(PVector location, float diameter){
    this(location, diameter, "");
  }
  
  DraggablePoint(float locationX, float locationY, float diameter){
    this(locationX, locationY, diameter, "");
  }
  
  PVector getLocation(){
    return location.get();
  }
  
  void setLocation(PVector to){
    setLocation(to.x, to.y, to.z);
  }
  
  void setLocation(float x, float y){
    setLocation(x, y, 0);
  }
  
  void setLocation(float x, float y, float z){
    location.set(x, y, z);
  }
  
  boolean isIntersecting(PVector point){
    return PVector.dist(point, location) <= radius;
  }
  
  void render(){
    noFill();
    stroke(255);
    strokeWeight(4);
    circle(location, diameter);
    point(location);
  }
  
  void renderFlavourText(){
    fill(255);
    text(flavourText, location.x + textWidth(flavourText)/2 + 5, location.y);
    noFill();
  }
}

