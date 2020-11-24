class UFO{
  boolean frame=false;
  boolean active=false;
  boolean side=true;
  int chance=20;
  int x;
  int combo;
  
  UFO(){}
  
  void move(){
    if(side){
      x+=3+level;
    }
    else{
      x-=3+level;
    }
    
    if(side&&x>width+45){
      active=false;
      combo=0;
      side=!(side);
    }
    else if(!(side)&&x<-45){
      active=false;
      combo=0;
      side=!(side);
    }
  }
  
  void getHit(){
    active=false;
    combo++;
    if(side){
      x=width+45;
    }
    else{
      x=-45;
    }
    if(combo<3){
      score+=5000*(combo)+5000*(level/2);
    }
    else{
      lives++;
    }
  }
  
  void render(){
    noTint();
    if(frame){
      image(UFOframe1,x,width-width/1.05,64,28);
    }
    else{
      image(UFOframe2,x,width-width/1.05,64,28);
    }
  }
}
