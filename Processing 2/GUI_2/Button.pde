class Button{
  int x,y;
  boolean shape,mouseOver;
  int width,height;
  
  Button(int x_,int y_,String shape_,int width_,int height_){
    x=x_;
    y=y_;
    if(shape_=="RECT"){
      shape=true;
    }else if(shape_=="CIRCLE"){
      if(width_!=height_){
        println("Warning: For circles, Width and Height must be equal. (Width is "+width_+" and Height is "+height_+")\nDefaulting to using Width.");
        height_=width_;
      }
      shape=false;
    }else{
      println("Invalid shape '"+shape_+"': Defaulting to RECT. Valid shapes are RECT and CIRCLE.");
      shape=true;
    }
    width=width_;
    height=height_;
  }
  
  void check(){
    mouseOver=false;
    if(shape){
      if(overRect(x,y,width,height)){
        mouseOver=true;
      }
    }else{
      if(overCircle(x,y,width)){
        mouseOver=true;
      }
    }
    updateColours();
  }
  
  void updateColours(){
    fill(102);
    if(mouseOver){
      fill(230);
      if(mousePressed){
        fill(40);
      }
    }
  }
  
  void render(){
    if(shape){
      rect(x,y,width,height);
    }else{
      ellipse(x,y,width,height);
    }
  }
}
