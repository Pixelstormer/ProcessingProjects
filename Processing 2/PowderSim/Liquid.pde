abstract class Liquid extends Particle{
  //Base class for Liquid particles
  //Particles that flow fast and spread to fill space
  
  public Liquid(PVector c){
    super(c);
    this.horizontalMovementProbability = new PVector(40,60);
    this.verticalMovementProbability = new PVector(15,30);
  }
  
  public Liquid(float r, float g, float b){
    super(r,g,b);
  }
}
