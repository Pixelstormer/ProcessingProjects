class Water extends Liquid{
  //Flows fast
  //Extinguishes things
  
  Water(){
    super(25,25,255);
    this.horizontalMovementProbability = new PVector(45,65);
    this.verticalMovementProbability = new PVector(0,25);
  }
  
  PVector pollCollisionResult(PVector intendedMovement, HashMap<PVector,Particle> neighbours){
    return properConstrainMagnitude((neighbours.get(intendedMovement)==null)?
             intendedMovement.get()
           :(neighbours.get(intendedMovement)instanceof Water)?
             super.pollCollisionResult(new PVector(intendedMovement.x*-1,0),neighbours)
           :pollCollisionResult(this.NaturalUpdate(),neighbours),-1,1);
  }
}

