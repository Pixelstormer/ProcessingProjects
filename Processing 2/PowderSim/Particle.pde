abstract class Particle {
  //Base class for particles

  PVector Colour;

  PVector horizontalMovementProbability;
  PVector verticalMovementProbability;


  public Particle(PVector c) {
    this(c.x, c.y, c.z);
  }

  public Particle(float r, float g, float b) {
    this.Colour = new PVector(r, g, b);
    this.horizontalMovementProbability = new PVector(0, 100);
    this.verticalMovementProbability = new PVector(0, 100);
  }

  public void Render(float x, float y, PGraphics renderer) {
    renderer.noStroke();
    renderer.fill(this.Colour.x, this.Colour.y, this.Colour.z);
    renderer.rect(int(x), int(y),1,1);
  }

  public PVector NaturalUpdate() {
    //Returns the vector displacement this particle would have if no force was applied to it

    float horizontalResult = random(100);
    float verticalResult = random(100);
    PVector displacementResult = new PVector(0, 0);
    if (horizontalResult<this.horizontalMovementProbability.x) {
      displacementResult.x=-1;
    } else if (horizontalResult>this.horizontalMovementProbability.y) {
      displacementResult.x=1;
    }

    if (verticalResult<this.verticalMovementProbability.x) {
      displacementResult.y=-1;
    } else if (verticalResult<this.verticalMovementProbability.y) {
      displacementResult.y=1;
    }
    
    return displacementResult;
  }

  public PVector pollDisplacementResult(PVector displacement) {
    //Returns how a given vector force would move this particle according to this particle's physics
    return PVector.add(displacement, this.NaturalUpdate());
  }

  public PVector pollGravityResult(PVector gravity) {
    //Returns the vector displacement for this particle with how it reacts to gravity
    PVector result = PVector.add(gravity, this.NaturalUpdate());
    return new PVector(constrain(result.x,-1,1),constrain(result.y,-1,1));
  }

  public PVector pollCollisionResult(PVector intendedMovement, HashMap<PVector, Particle> neighbours) {
    //The 'else' case ("new PVector(0,0)") in the ? statement would be replaced with whatever the particle's reaction is to colliding with something
    return (neighbours.get(intendedMovement)==null)?intendedMovement.get():new PVector(0,0);
  }
  
  public boolean pollToDestroy(){
    return false;
  }
}

