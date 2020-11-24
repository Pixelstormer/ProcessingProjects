class Fire extends Gas{
  //Very short lifetime
  //Creates updraft
  //Ignites things
  
  private int lifeTime;
  
  public Fire(){
    super(255,85,0);
    this.horizontalMovementProbability = new PVector(15,85);
    this.verticalMovementProbability = new PVector(80,100);
    this.lifeTime = int(random(5,120));
  }
  
  public PVector NaturalUpdate(){
    this.lifeTime--;
    return super.NaturalUpdate();
  }
  
  public boolean pollToDestroy(){
    return this.lifeTime<=0;
  }
}

