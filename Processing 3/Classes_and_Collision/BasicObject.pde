//Basic object with a physical presence (Location, rendering etc.)

class BasicObject{
  protected PVector Location;
  protected float Rotation;
  
  protected BasicObject(PVector l, float r){
    this.Location = l.copy();
    this.Rotation = r;
  }
  
  protected BasicObject(PVector l){
    this.Location = l.copy();
    this.Rotation = 0;
  }
  
  protected BasicObject(){
    this.Location = new PVector(0,0);
  }
  
  public void Render(){
    println("Placeholder function in basic object class. Please overwrite.");
    Thread.dumpStack();
    point(this.Location.x,this.Location.y);
  }
  
  public PVector GetLocation(){
    return this.Location.copy();
  }
}