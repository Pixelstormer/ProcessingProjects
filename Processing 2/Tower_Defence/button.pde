class button{
  float x,y;
  String colour;
  
  button(float X,float Y,String Colour){
    x=X;
    y=Y;
    colour=Colour;
  }
  
  void render(){
    fill(switchFill(colour));
    if(paintMode==colour){
      strokeWeight(4);
    }
    rect(x,y,45,45);
    strokeWeight(1);
  }
  
  boolean pressed(){
    return overRect(x,y,45,45);
  }
  
  void pressEvent(){
    paintMode=colour;
  }
}
