final class Circularbody extends Rigidbody{
  private final float radius;
  private final float diameter;
  
  Circularbody(PVector position, float mass, float drag, float elasticity, float radius){
    super(position, mass, drag, elasticity);
    this.radius = radius;
    diameter = radius * 2;
  }
  
  @Override
  protected void virtualIteratePhysics(){
    
  }
  
  @Override
  protected void virtualConstrainToScreen(){
    
  }
  
  @Override
  protected void virtualCollideWithStaticbodies(List<? extends Staticbody> bodies){
    
  }
  
  @Override
  protected void virtualCollideWithRigidbodies(List<? extends Rigidbody> bodies){
    
  }
  
  @Override
  void applyVirtualUpdates(){
    
  }
  
  @Override
  boolean pointCollides(PVector point){
    return PVector.dist(point, position) <= radius;
  }
  
  @Override
  void render(){
    noStroke();
    fill(120);
    ellipse(position.x, position.y, radius, radius);
  }
}

