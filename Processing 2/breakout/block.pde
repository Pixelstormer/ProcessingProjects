class block{
  int x,y;
  boolean dead=false;
  
  block(int X,int Y){
    x=X;
    y=Y;
  }
  
  void render(){
    if(!(dead)){
      colorMode(HSB);
      fill(map(y,2,blocksInColumn*16+2,0,255),255,255);
      noStroke();
      rect(x,y,30,15);
    }
  }
}

