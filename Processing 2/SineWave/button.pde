class button{
  int x,y;
  String value;
  PImage sprite;
  
  button(int X,int Y,String Value,PImage Sprite){
    x=X;
    y=Y;
    value=Value;
    sprite=Sprite;
  }
  
  void update(){
    if(overRect(mouseX,mouseY,x,y,45,45)){
      waveMode=value;
      updateSliders();
    }
  }
  
  void render(){
    stroke(105);
    fill(80);
    rect(x,y,45,45);
    image(sprite,x,y,45,45);
  }
  
  String getValue(){
    return value;
  }
}

