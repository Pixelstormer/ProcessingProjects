abstract class Staticbody{
  private final PVector position;
  private final float elasticity;
  
  Staticbody(PVector position, float elasticity){
    this.position = position.get();
    this.elasticity = elasticity;
  }
  
  
  
  abstract boolean pointCollides(PVector point);
  abstract void render();
}

