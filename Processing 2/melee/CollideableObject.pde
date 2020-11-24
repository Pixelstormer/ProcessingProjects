abstract class CollideableObject{
  //Represents an object with no physics that can be collided with
  protected final float elasticity;
  protected final float frictionCoefficient;
  
  CollideableObject(float elasticity, float friction){
    this.elasticity = elasticity;
    frictionCoefficient = friction;
  }
  
  abstract boolean isIntersecting(PVector point);
  abstract PVector closestPointTo(PVector point);
}

