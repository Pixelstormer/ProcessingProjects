class Button{
  int scheme;
  float x,y;
  int width,height;
  boolean state;
  String name;
  
  Button(int scheme_,float x_,float y_,int width_,int height_,boolean state_,String name_){
    scheme=scheme_;
    x=x_;
    y=y_;
    width=width_;
    height=height_;
    state=state_;
    String[] nameList=split(name_,' ');
    name=join(nameList,'\n');
  }
  
  void render(){
    colourScheme(scheme);
    if(state){
      ellipse(x,y,width,height);
    }
    else{
      rect(x,y,width,height);
    }
    fill(255);
    textSize(width/4);
    text(name,x,y,width,height);
  }
  
  boolean checkOver(){
    if(state){
      return overCircle(x,y,width);
    }
    else{
      return overRect(x,y,width,height);
    }
  }
  
  void clicked(){
    buttonPressed(this);
  }
}

