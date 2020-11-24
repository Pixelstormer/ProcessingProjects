class Key{
  float x,y;
  
  Key(float X,float Y){
    x=X;
    y=Y;
  }
  
  void render(){
    tint(map(shadowTimer,350,-836,0,255),map(shadowTimer,350,-836,0,255));
    image(sprite,x,y);
  }
  
  void collect(){
    score++;
    collected.add(this);
  }
}

