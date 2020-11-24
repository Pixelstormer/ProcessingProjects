class tile {
  String identifier;
  int x,y;
  boolean moved=false;

  tile(String Identifier,int X,int Y) {
    identifier=Identifier;
    x=X;
    y=Y;
  }
  
  void move(int targetX,int targetY){
    try{
      if(cells[targetX][targetY].identifier=="GROUND"){
        cells[targetX][targetY].identifier=identifier;
        moved=true;
        cells[targetX][targetY].moved=true;
        identifier="USEDGROUND";
      }
    }
    catch(ArrayIndexOutOfBoundsException e){}
  }
}

