class Cell {
  private int State;

  Cell() {
    this.attemptStateSet(0);
  }

  Cell(int initState) {
    this.attemptStateSet(initState);
  }
  
  String toString(){
    return String.format("[%s]",this.getState());
  }

  private void attemptStateSet(int newState) {
    //State is constrained to within 0 and the maximum number of states
    if (newState>=0||newState<NUM_STATES){
      this.State = newState;
    } else {
      throw new IllegalArgumentException("Cell has been passed an illegal attempted state: ["+newState+"].");
    }
  }
  
  private int speculateStateSet(int newState){
    //Checks if a new state would be valid. If not, throws an error
    if (!(newState>=0||newState<NUM_STATES)){
      throw new IllegalArgumentException("Cell has been passed an illegal attempted state: ["+newState+"].");
    }
    return newState;
  }

  int noisyUpdateState(HashMap<PVector, Cell> neighbours) {
    //Updates this cell's state according to given neighbours and returns the new state
    //Also logs information about the update
    int o = this.getState();
    for (Reaction r : parsedRuleset) {
      this.attemptStateSet(r.reactionResult(this, neighbours));
    }
    println(String.format("UPDATED FROM STATE %s TO STATE %s WHEN PRESENTED WITH NEIGHBOURHOOD %s",o,this.getState(),getRelativeNeighbourhood(neighbours)));
    return this.getState();
  }
  
  int speculativeUpdateState(HashMap<PVector, Cell> neighbours){
    //Returns what this cell's new state would be if it reacted with given neighbours
    int o = this.getState();
    for (Reaction r : parsedRuleset) {
      o = this.speculateStateSet(r.reactionResult(new Cell(o), neighbours));
    }
    return o;
  }
  
  void quietUpdateState(HashMap<PVector, Cell> neighbours){
    //Updates this cell's state and does not return any information
    for (Reaction r : parsedRuleset) {
      this.attemptStateSet(r.reactionResult(this, neighbours));
    }
  }

  int getState() {
    return this.State;
  }

  PVector getRenderColour() {
    return new PVector((NUM_STATES==-1)?255/(this.State+1):(255/(NUM_STATES+1))*this.State, 255, 255);
  }
}

