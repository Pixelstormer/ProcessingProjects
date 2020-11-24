class enemyShot extends shot{
  
  enemyShot(int x,int y){
    super(x,y);
    isPlayer=false;
  }
  
  void move(){
    y+=5+level;
  }
  
  void checkCollision(){
    if(overRect(x,y,playerX,height/1.15,44,44)){
      toRemove.add(this);
      getHit();
    }
  }
}

