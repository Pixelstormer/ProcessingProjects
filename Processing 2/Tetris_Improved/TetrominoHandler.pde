class TetrominoHandler{
  Tetromino tetromino;
  boolean isTetrominoGrounded;
  int rotationIndex;
  
  TetrominoHandler(Tetromino piece){
    tetromino=piece;
    isTetrominoGrounded=false;
    rotationIndex=0;
  }
  
  void changeTetromino(Tetromino newTetromino){
    tetromino=newTetromino;
  }
  
  void changeTetrominoMinos(Mino[] newMinos){
    tetromino.updateMinos(newMinos);
  }
  
  Tetromino getTetromino(){
    return tetromino;
  }
  
  void offsetTetromino(PVector offset){
    for(Mino m : tetromino.Minos){
      try{
        if(grid[int(m.getPos().x+offset.x)][int(m.getPos().y+offset.y)]!=null){
          return;
        }
      }
      catch(ArrayIndexOutOfBoundsException e){
        return;
      }
    }
    tetromino.offset(offset);
    checkIfGrounded();
    lockDelayTimer=lockDelay;
  }
  
  boolean updateTetrominoRotation(){ //Returns if the rotation was successful
    isTetrominoGrounded = false;
  
    int centerPointIndex=getCenterPointFromIndex(tetromino.index);
    Tetromino newTetromino=minoGenerator.generateTetrominoFromIndex(tetromino.index,rotationIndex,tetromino.Minos[centerPointIndex].getPos());
    
    Mino[] oldMinos=new Mino[4];
    for(int i=0;i<4;i++){
      oldMinos[i]=new Mino(newTetromino.Minos[i].getPos(),newTetromino.Minos[i].getSprite(),tileSize);
    }
    
    if(checkIfPositionIsValid(newTetromino)){
      changeTetromino(newTetromino);
      checkIfGrounded();
      return true;
    }
    
    for(int y=2;y>=-2;y--){
      for(int x=-2;x<2;x++){
        PVector kick=new PVector(x,y);
        for(int i=0;i<4;i++){
          newTetromino.Minos[i].move(PVector.add(oldMinos[i].getPos(),kick));
        }
        if(checkIfPositionIsValid(newTetromino)){
          changeTetromino(newTetromino);
          checkIfGrounded();
          return true;
        }
      }
    }
    checkIfGrounded();
    return false;
  }
  
  boolean checkIfPositionIsValid(Tetromino target){
    for(Mino m : target.Minos){
      try{
        if(grid[int(m.getPos().x)][int(m.getPos().y)]!=null){
          return false;
        }
      }
      catch(ArrayIndexOutOfBoundsException e){
        return false;
      }
    }
    return true;
  }
  
  void changeRotationIndex(int offset){
    rotationIndex+=offset;
    if(rotationIndex>3){
      rotationIndex=0;
    }
    if(rotationIndex<0){
      rotationIndex=3;
    }
  }
  
  void setRotationIndex(int newIndex){
    rotationIndex=newIndex;
  }
  
  void hardDropTetromino(){
    while(!isTetrominoGrounded){
      checkIfGrounded();
      offsetTetromino(new PVector(0,1));
    }
    lockTetromino();
  }
  
  void lockTetromino(){
    tetromino.lockToGrid();
    clearFilledLines();
    swapToNextPiece();
  }
  
  void checkIfGrounded(){
    isTetrominoGrounded = false;
    for(Mino m : tetromino.Minos){
      try{
        isTetrominoGrounded=grid[int(m.getPos().x)][int(m.getPos().y+1)]!=null;
      }
      catch(ArrayIndexOutOfBoundsException e){
        isTetrominoGrounded=m.getPos().y+1>=gridHeight;
      }
      if(isTetrominoGrounded){
        return;
      }
    }
    lockDelayTimer=lockDelay;
  }
  
  void renderTetromino(){
    tetromino.render();
  }
}

