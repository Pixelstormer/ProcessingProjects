class Mino{
  PVector position;
  PImage sprite;
  float size;
  
  Mino(PVector pos,PImage spr,float sze){
    position=pos;
    sprite=spr;
    size=sze;
  }
  
  PVector getPos(){
    return position.get();
  }
  
  PImage getSprite(){
    return sprite;
  }
  
  float getSize(){
    return size;
  }
  
  void render(){
    image(sprite,convIntToScreenCoord(int(position.x),true),convIntToScreenCoord(int(position.y),false),size,size);
  }
  
  void move(PVector newPos){ //Set position to a new location
    position=newPos.get();
  }
  
  void offset(PVector offset){ //Offset current position by a vector
    position.add(offset);
  }
  
  void updateSprite(PImage newSprite){
    sprite=newSprite;
  }
  
  void updateSize(float newSize){
    size=newSize;
  }
  
  void lockToGrid(){
    addMinoToGrid(this,position);
  }
}

