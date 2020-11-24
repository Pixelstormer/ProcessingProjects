abstract class Rigidbody{
  protected final PVector position;
  protected final PVector velocity;
  protected final float mass;
  protected final float drag;
  protected final float elasticity;
  
  Rigidbody(PVector position, float mass, float drag, float elasticity){
    this.position = position.get();
    this.mass = mass;
    this.drag = drag;
    this.elasticity = elasticity;
    velocity = new PVector(0, 0);
  }
  
  final void virtualUpdate(List<? extends Staticbody> staticBodies, List<? extends Rigidbody> rigidBodies){
    virtualIteratePhysics();
    virtualCollideWithRigidbodies(rigidBodies);
    virtualCollideWithStaticbodies(staticBodies);
    virtualConstrainToScreen();
  }
  
  final void realUpdate(List<? extends Staticbody> staticBodies, List<? extends Rigidbody> rigidBodies){
    virtualUpdate(staticBodies, rigidBodies);
    applyVirtualUpdates();
  }
  
  protected abstract void virtualIteratePhysics();
  protected abstract void virtualConstrainToScreen();
  protected abstract void virtualCollideWithStaticbodies(List<? extends Staticbody> bodies);
  protected abstract void virtualCollideWithRigidbodies(List<? extends Rigidbody> bodies);
  
  abstract void applyVirtualUpdates();
  
  abstract boolean pointCollides(PVector point);
  abstract void render();
}

