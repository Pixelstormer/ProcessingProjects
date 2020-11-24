class Tile{
  private int State;
  
  Tile(){
    this.setState(0);
  }
  
  Tile(int initState){
    this.setState(initState);
  }
  
  void setState(int newState){
    //State is constrained to within 0 and the maximum number of states
    if(newState>=0){
      this.State = newState;
    }
    else{
      throw new IllegalArgumentException("Tile has been passed an illegal attempted state: ["+newState+"].");
    }
  }
  
  int getState(){
    return this.State;
  }
  
  PVector getRenderColour(){
    return new PVector((NUM_TILES==-1)?255/(this.State+1):(255/(NUM_TILES+1))*this.State,255,255);
  }
}
