class Tetromino{
  //Actually a polymino
  
  int index;
  int minoNumber; //Number of minos eg. Tetromino, pentomino, monomino, etc.
  Mino[] Minos; //Array to store each mino in
  
  Tetromino(Mino[] minos,int i){
    Minos=minos;
    minoNumber=Minos.length; //minoNumber is automatically derived from array length
    index=i;
  }
  
  void updateMinos(Mino[] newMinos){
    Minos=newMinos;
  }
  
  void updateSprite(PImage newSprite){
    for(Mino m : Minos){
      m.updateSprite(newSprite);
    }
  }
  
  void render(){
    for(Mino m : Minos){
      m.render();
    }
  }
  
  void move(PVector[] newPos){
    for(int i=0;i<4;i++){
      Minos[i].move(newPos[i]);
    }
  }
  
  void offset(PVector offset){
    for(Mino m : Minos){
      m.offset(offset);
    }
  }
  
  void lockToGrid(){
    for(Mino m : Minos){
      m.lockToGrid();
    }
  }
}

