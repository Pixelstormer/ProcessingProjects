class Randomizer{
  IntList Primary;
  IntList Secondary;
  int bagIndex;
  boolean usingPrimary;
  
  Randomizer(){
    init();
  }
  
  void init(){
    usingPrimary = true;
    Primary=new IntList();
    Secondary=new IntList();
    bagIndex=0;
    for(int i=0;i<7;i++){
      Primary.append(i);
      Secondary.append(i);
    }
    Primary.shuffle();
    Secondary.shuffle();
  }
  
  
  int cycleNextPiece(){
    int piece;
    if(usingPrimary){
      piece=Primary.get(bagIndex);
    }
    else{
      piece=Secondary.get(bagIndex);
    }
    bagIndex++;
    if(bagIndex>6){
      bagIndex=0;
      usingPrimary=!usingPrimary;
      Primary.shuffle();
      Secondary.shuffle();
    }
    return piece;
  }
  
  int[] getPrimaryArray(){
    return Primary.array();
  }
  
  int[] getSecondaryArray(){
    return Secondary.array();
  }
  
  int getBagIndex(){
    return bagIndex;
  }
  
  boolean getUsingPrimary(){
    return usingPrimary;
  }
}

