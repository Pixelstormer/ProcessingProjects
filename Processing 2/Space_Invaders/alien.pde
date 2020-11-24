class alien{
  int x,y;
  boolean dead=false;
  int variant;
  boolean frame=false;
  float timeToShoot;
  int colour;
  
  alien(int X,int Y,int Variant){
    x=X;
    y=Y;
    variant=Variant;
    timeToShoot=random(600);
    colour=(y-45)/((height-240)/aliensInColumn)-1;
  }
  
  void move(){
    if(!(dead)){
      if(direction){
        x+=10;
      }
      else{
        x-=10;
      }
      frame=!(frame);
    }
  }
  
  void render(){
    if(!(dead)){
      colorMode(HSB);
      tint(colour*30,255,255);
      switch(variant){
        case 1:
          if(frame){
            image(invader2f1,x,y,32,32);
          }
          else{
            image(invader2f2,x,y,32,32);
          }
          break;
        case 2:
          if(frame){
            image(invader1f1,x,y,44,32);
          }
          else{
            image(invader1f2,x,y,44,32);
          }
          break;
        case 3:
        if(frame){
          image(invader3f1,x,y,44,32);
        }
        else{
          image(invader3f2,x,y,44,32);
        }
          break;
      }
      colorMode(RGB);
    }
  }
  
  void shoot(){
    if(!(dead)){
      activeShots.add(new enemyShot(x-3,y+8));
      timeToShoot=random(650-level*10);
    }
  }
}

