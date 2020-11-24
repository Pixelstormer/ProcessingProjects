abstract class Static extends Particle{
  //Base class for Static particles
  //Particles that do not move and only interact reactively
  
  public Static(PVector c){
    super(c);
    this.horizontalMovementProbability = new PVector(0,100);
    this.verticalMovementProbability = new PVector(0,100);
  }
  
  public Static(float r, float g, float b){
    super(r,g,b);
  }
  
  final PVector NaturalUpdate(){
    return new PVector(0,0);
  }
  
  final PVector pollGravityResult(PVector gravity){
    return new PVector(0,0);
  }
  
  final PVector pollDisplacementResult(PVector displacement){
    return new PVector(0,0);
  }
}

