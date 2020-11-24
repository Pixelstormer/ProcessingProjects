//A rectangular piece of terrain

class TerrainRect extends BasicObject implements CollidableObject{
  private PVector Bounds;
  
  public TerrainRect(){
    super();
  }
  
  public TerrainRect(PVector location){
    super(location);
  }
  
  public TerrainRect(PVector location, PVector Bounds){
    super(location);
    this.Bounds = Bounds.copy();
  }
  
  public PVector pollForBoundsCollision(PVector center, PVector bounds){
    pushMatrix();
    translate(Location.x,Location.y);
    rotate(Rotation);
    boolean Result = center.x-bounds.x/2 < Location.x+Bounds.x/2 &&
                     center.x+bounds.x/2 > Location.x-Bounds.x/2 &&
                     center.y-bounds.y/2 < Location.y+Bounds.y/2 &&
                     center.y+bounds.y/2 > Location.y-Bounds.y/2;
    
    float bottomDistance = abs((center.y-bounds.y/2)-(Location.y+Bounds.y/2));
    float topDistance = abs((center.y+bounds.y/2)-(Location.y-Bounds.y/2));
    float leftDistance = abs((center.x-bounds.x/2)-(Location.x+Bounds.x/2));
    float rightDistance = abs((center.x+bounds.x/2)-(Location.x-Bounds.x/2));
    
    popMatrix();
    
    if(Result){
      if(topDistance < bottomDistance && topDistance < leftDistance && topDistance < rightDistance){
        return new PVector(center.x,Location.y-Bounds.y/2-bounds.y/2,0);
      }
      if(bottomDistance < topDistance && bottomDistance < leftDistance && bottomDistance < rightDistance){
        return new PVector(center.x,Location.y+Bounds.y/2+bounds.y/2,1);
      }
      if(leftDistance < topDistance && leftDistance < bottomDistance && leftDistance < rightDistance){
        return new PVector(Location.x+Bounds.x/2+bounds.x/2,center.y,2);
      }
      if(rightDistance < topDistance && rightDistance < bottomDistance && rightDistance < leftDistance){
        return new PVector(Location.x-Bounds.x/2-bounds.x/2,center.y,3);
      }
    }
    return new PVector(center.x,center.y,-1);
  }
  
  public void Render(){
    noStroke();
    fill(255);
    rectMode(CENTER);
    pushMatrix();
    translate(Location.x,Location.y);
    rotate(Rotation);
    rect(0,0,Bounds.x,Bounds.y);
    popMatrix();
  }
}