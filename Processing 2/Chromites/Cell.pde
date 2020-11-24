class Cell{
  private int State;
  private PVector Location;
  
  Cell(PVector loc){
    this.Location = loc.get();
    this.attemptStateSet(0);
  }
  
  Cell(PVector loc,int initState){
    this.Location = loc.get();
    this.attemptStateSet(initState);
  }
  
  private void attemptStateSet(int newState){
    //State is constrained to within 0 and the maximum number of states
    if(newState>=0||newState<NUM_INSTRUCTIONS){
      this.State = newState;
    }
    else{
      throw new IllegalArgumentException("Cell has been passed an illegal attempted state: ["+newState+"].");
    }
  }
  
  int performAction(Tile t){
    //Interprets the RULESET to decide actions
    //We will assume the RULESET always follows the same format to make things easier for ourselves
    //x abcd abcd x abcd abcd
    //0013611242108311210024103620123008
    //0 0136 1124 2108 3112 1 0024 1036 2012 3008
    String instruction = "";
    String currentState = str(t.getState());
    int currentStateIndex = 0;
    for(int i=0;i<=floor((RULESET.length()-1)/4)-1;i++){
      if(int(str(RULESET.charAt(i*4+1+currentStateIndex)))!=((NUM_INSTRUCTIONS==-1)?i:i%NUM_INSTRUCTIONS)){
        //Found next 'x'
        NUM_INSTRUCTIONS = i;
        currentStateIndex = int(str(RULESET.charAt(i*4+1+currentStateIndex)));
        NUM_TILES = currentStateIndex;
      }
      if(int(str(RULESET.charAt(i*4+1+currentStateIndex)))==this.State){
        //Found matching cell state
        if(str(currentStateIndex).equals(currentState)){
          //If also on tile state we're looking for, this is the instruction we want
          instruction = RULESET.substring(i*4+2+currentStateIndex,i*4+5+currentStateIndex);
          break;
        }
      }
    }
    
    this.attemptStateSet(int(str(instruction.charAt(1))));
    this.Location.add(generateMovementVector(int(str(instruction.charAt(2)))));
    return int(str(instruction.charAt(0)));
  }
  
  PVector getLocation(){
    return this.Location.get();
  }
  
  PVector getRenderColour(){
    return new PVector((NUM_INSTRUCTIONS==-1)?255/(this.State+1):(255/(NUM_INSTRUCTIONS+1))*this.State,255,255);
  }
  
  PVector generateMovementVector(int dir){
    switch(dir){
      case 1:
        return new PVector(-1,1);
      case 2:
        return new PVector(0,1);
      case 3:
        return new PVector(1,1);
      case 4:
        return new PVector(-1,0);
      case 5:
        return new PVector(0,0);
      case 6:
        return new PVector(1,0);
      case 7:
        return new PVector(-1,-1);
      case 8:
        return new PVector(0,-1);
      case 9:
        return new PVector(1,-1);
      default:
        throw new IllegalArgumentException("Illegal movement state: ["+dir+"].");
    }
  }
}
