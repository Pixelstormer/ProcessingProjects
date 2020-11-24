class Reaction{
  //Class for containing information about reactions
  
  //The string representation of the reaction in question
  private String Rule;
  //The state the target cell has to be in for the reaction to take place
  private int TargetCellState;
  //ArrayList of all the Neighbour States that have to be matched for the reaction to take place
  private ArrayList<NeighbourState> Neighbours;
  //The state the target cell will be in as a result of the reaction
  private int TargetCellResult;
  
  Reaction(String rule){
    this.Rule = rule;
    this.Neighbours = new ArrayList<NeighbourState>();
    this.constructParsedRuleset();
    this.checkNumStates();
  }
  
  String toString(){
    return String.format("\"(%s & %s) -> %s\"",this.TargetCellState,this.Neighbours,this.TargetCellResult);
  }
  
  private void checkNumStates(){
    if(this.TargetCellState+1>NUM_STATES){
      NUM_STATES = this.TargetCellState+1;
    }
    
    if(this.TargetCellResult+1>NUM_STATES){
      NUM_STATES = this.TargetCellResult+1;
    }
  }
  
  private void constructParsedRuleset(){
    //We assume Reactions specified by the ruleset take on a reliable format:
    //The first character is the state the target cell has to be in for the reaction to take place
    //The last character is the state the target cell will be in as a result of the reaction
    //The characters inbetween represent the state the neighbours have to be in
    //The majority of the complexity comes from the neighbour rules
    //We still include a few sanity checks 'just in case'
    
    this.extractTargetCellState();
    
    this.extractTargetCellResult();
    
    this.extractNeighbourStateRules();
  }
  
  private void extractTargetCellState(){
    //Get required cell state
    this.TargetCellState = charToInt(this.Rule.charAt(0));
  }
  
  private void extractTargetCellResult(){
    //Get resulting cell state
    this.TargetCellResult = charToInt(this.Rule.charAt(this.Rule.length()-1));
  }
  
  private void extractNeighbourStateRules(){
    //Extract neighbour state rules from the cell state and result characters
    String neighbourStates = this.getNeighbourStates(this.Rule);
    
    //Split neighbour state rules into each individual trio of characters (each individual rule)
    ArrayList<String> neighbourRules = this.splitRules(neighbourStates);
    
    //Construct proper neighbourState objects from the given strings
    this.constructNeighbourStates(neighbourRules);
  }
  
  private String getNeighbourStates(String reaction){
    String neighbourStates = reaction.substring(1,reaction.length()-1);
    if(neighbourStates.length()%3!=0){
      //Sanity check for legal length
      throw new IllegalArgumentException("Ruleset contains invalid neighbour state equations");
    }
    return neighbourStates;
  }
  
  private ArrayList<String> splitRules(String rule){
    ArrayList<String> neighbourRules = new ArrayList<String>();
    for(int i=0;i<rule.length();i+=3){
      neighbourRules.add(rule.substring(i, Math.min(rule.length(), i + 3)));
    }
    return neighbourRules;
  }
  
  private void constructNeighbourStates(ArrayList<String> states){
    for(String s : states){
      if(s.length()!=3){
        throw new IllegalArgumentException("Ruleset contains invalid neighbour state equations");
      }
      this.Neighbours.add(new NeighbourState(s.charAt(1),charToInt(s.charAt(0)),charToInt(s.charAt(2))));
    }
  }
  
  boolean wouldReact(Cell target, HashMap<PVector,Cell> neighbours){
    //Returns whether or not a reaction would occur
    if(target.getState()!=this.TargetCellState){
      return false;
    }
    for(NeighbourState n : this.Neighbours){
      //If any one of the neighbour states returns false the reaction fails
      if(!n.checkForMatch(neighbours)){
        return false;
      }
    }
    return true;
  }
  
  int reactionResult(Cell target, HashMap<PVector,Cell> neighbours){
    //Returns what the new state of the target cell would be if this reaction would occur
    //If the reaction would not occur it returns the current state of the cell
    if(this.wouldReact(target,neighbours)){
      return this.TargetCellResult;
    }
    return target.getState();
  }
  
  private class NeighbourState{
    //Sub-class for tracking valid neighbours
    
    //Number of neighbours to compare with
    private int neighbourCount;
    //Either '<', '=' or '>' to represent 'less than' 'equal to' and 'more than'
    private char comparisonType;
    //Target state for the neighbours in question
    private int targetState;
    
    NeighbourState(char ct, int nc, int ts){
      this.comparisonType = ct;
      this.neighbourCount = nc;
      this.targetState = ts;
    }
    
    String toString(){
      return String.format("n`%s%s ? %s",this.comparisonType,this.neighbourCount,this.targetState);
    }
    
    boolean checkForMatch(HashMap<PVector,Cell> targetNeighbours){
      //Checks if a given neighbour set matches this neighbourState's rule
      int validNeighbourCount = this.accumulateValidNeighbours(targetNeighbours);
      switch(this.comparisonType){
        case '<':
          //'Less than'
          return validNeighbourCount < this.neighbourCount;
        case '=':
          //'Equal to'
          return validNeighbourCount == this.neighbourCount;
      }
      //Only other possible valid comparison type is '>' or 'Greater than'
      return validNeighbourCount > this.neighbourCount;
    }
    
    private int accumulateValidNeighbours(HashMap<PVector,Cell> targetNeighbours){
      //Counts the number of neighbours in the set that have a matching state
      int count = 0;
      for(Entry<PVector,Cell> e : targetNeighbours.entrySet()){
        if(e.getValue()==null){
          count+=(this.targetState==0)?1:0;
        }
        else{
          count+=(e.getValue().getState()==this.targetState)?1:0;
        }
      }
      return count;
    }
  }
}

