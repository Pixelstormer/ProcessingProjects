class Tetromino{
  int minoNo=4;
  int rotationIndex;
  boolean grounded = false;
  PVector[] minos = new PVector[minoNo];
  
  Tetromino(PVector[] Minos,int r){
    minos = Minos;
    rotationIndex=r;
  }
  
  void move(PVector o,boolean g){
    for(PVector p : minos){
      if(PVector.add(p,o).x<0 || PVector.add(p,o).x>=gridWidth || PVector.add(p,o).y<0 || p.x<0 || p.x>=gridWidth || p.y<0){
        return;
      }
      int[][] buffer = tiles;
      for(PVector P : minos){
        buffer[floor(P.x)][floor(P.y)] = 0;
      }
      if(PVector.add(p,o).y>=gridHeight || buffer[int(PVector.add(p,o).x)][int(PVector.add(p,o).y)] != 0){
        return;
      }
    }
    PVector[] New = new PVector[minoNo];
    for(int i=0;i<minoNo;i++){
      New[i] = PVector.add(minos[i],o);
      tiles[floor(minos[i].x)][floor(minos[i].y)] = 0;
    }
    for(PVector p : New){
      tiles[floor(p.x)][floor(p.y)] = getHueFromIndex(blockIndex);
    }
    minos = New;
    
    checkIfGrounded();
  }
  
  void castToFloor(){
    PVector o = new PVector(0,1);
    while(!grounded){
      boolean blocked=false;
      for(PVector p : minos){
        if(PVector.add(p,o).x<0 || PVector.add(p,o).x>=gridWidth || PVector.add(p,o).y<0 || p.x<0 || p.x>=gridWidth || p.y<0){
          blocked=true;
        }
        int[][] buffer = tiles;
        for(PVector P : minos){
          buffer[floor(P.x)][floor(P.y)] = 0;
        }
        for(PVector P : activePiece.minos){
          buffer[floor(P.x)][floor(P.y)] = 0;
        }
        if(PVector.add(p,o).y>=gridHeight || buffer[int(PVector.add(p,o).x)][int(PVector.add(p,o).y)] != 0){
          blocked=true;
        }
      }
      if(!blocked){
        for(PVector p : minos){
          p.add(o);
        }
        lockingTimer=millis();
      }
      checkIfGrounded();
    }
  }
  
  void checkIfGrounded(){
    for(PVector p : minos){
      int[][] buffer = tiles;
      for(PVector P : minos){
        buffer[floor(P.x)][floor(P.y)] = 0;
      }
      for(PVector P : activePiece.minos){
        buffer[floor(P.x)][floor(P.y)] = 0;
      }
      grounded=(p.y+1>=gridHeight || buffer[int(p.x)][int(p.y+1)] != 0);
      if(grounded){
        break;
      }
    }
  }
  
  void lockPiece(){
    for(PVector p : minos){
      tiles[floor(p.x)][floor(p.y)] = getHueFromIndex(blockIndex);
    }
    clearLines();
    updateColours();
    activePiece = spawnTetromino(getRotationFromIndex(getPieceFromIndex(blockIndex),0),gridCenter,0);
  }
  
  void Rotate(boolean dir){
    for(int i=0;i<minoNo;i++){
      tiles[floor(minos[i].x)][floor(minos[i].y)] = 0;
    }
    PVector[] buffer = minos;
    int oldIndex=rotationIndex;
    if(dir){ //Left/Counterclockwise
      rotationIndex--;
      if(rotationIndex<0){
        rotationIndex=3;
      }
    }
    else{ //Right/Clockwise
      rotationIndex++;
      if(rotationIndex>3){
        rotationIndex=0;
      }
    }
    PVector[] target = getRotationFromIndex(getPieceFromIndex(blockIndex),rotationIndex);
    Tetromino targetPiece = spawnTetromino(target,minos[getCenterPointIndex()],rotationIndex);
    boolean blocked=false;
    for(PVector p : targetPiece.minos){
      try{
        if(tiles[floor(p.x)][floor(p.y)]!=0){
          blocked=true;
        }
      }
      catch(ArrayIndexOutOfBoundsException e){
        blocked=true;
      }
    }
    if(!blocked){
      activePiece=targetPiece;
      lockingTimer=millis();
    }
    else{
      rotationIndex=oldIndex;
    }
    checkIfGrounded();
  }
}

