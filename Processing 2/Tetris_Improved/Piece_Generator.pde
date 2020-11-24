class Piece_Generator{
  
   Mino generateMinoFromIndex(int i){
    return new Mino(new PVector(0,0),generateMinoImageFromIndex(i),tileSize);
  }
  
   Mino[] generateMinoArrayFromIndex(int i,int r,PVector o){
    return new Mino[] {new Mino(PVector.add(o,Rotation_Tables[i][r][0]),generateMinoImageFromIndex(i),tileSize),new Mino(PVector.add(o,Rotation_Tables[i][r][1]),generateMinoImageFromIndex(i),tileSize),new Mino(PVector.add(o,Rotation_Tables[i][r][2]),generateMinoImageFromIndex(i),tileSize),new Mino(PVector.add(o,Rotation_Tables[i][r][3]),generateMinoImageFromIndex(i),tileSize)};
  }
  
   Tetromino generateTetrominoFromIndex(int i,int r,PVector o){
    return new Tetromino(generateMinoArrayFromIndex(i,r,o),i);
  }
  
   PImage generateMinoImageFromIndex(int i){
    switch(i){
      case 0: //O
        return YellowMino;
      case 1: //T
        return PurpleMino;
      case 2: //L
        return OrangeMino;
      case 3: //J
        return BlueMino;
      case 4: //S
        return GreenMino;
      case 5: //Z
        return RedMino;
      case 6: //I
        return CyanMino;
      default:
        println("Invalid mino index; Defaulting to 0 (O)");
        return YellowMino;
    }
  }
}

