abstract class Gas extends Particle{
  //Base class for Gas particles
  //Particles that float around and are not affected by gravity
  
  public Gas(PVector c){
    super(c);
    this.horizontalMovementProbability = new PVector(35,65);
    this.verticalMovementProbability = new PVector(60,100);
  }
  
  public Gas(float r, float g, float b){
    super(r,g,b);
  }
  
  public PVector pollGravityResult(PVector gravity){
    return this.NaturalUpdate();
  }
}

