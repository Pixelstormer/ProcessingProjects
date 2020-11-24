abstract class Solid extends Particle{
  //Base class for solid particles
  //Particles that fall and form piles
  
  public Solid(PVector c){
    super(c);
    this.horizontalMovementProbability = new PVector(37.5,62.5);
    this.verticalMovementProbability = new PVector(0,15);
  }
  
  public Solid(float r, float g, float b){
    super(r,g,b);
  }
}
