class slider{
  int x,y;
  int w,h;
  int sliderX;
  float min,max;
  float value;
  
  slider(int X,int Y,int W,int H,float Min,float Max,float startVal){
    x=X;
    y=Y;
    w=W;
    h=H;
    min=Min;
    max=Max;
    value=startVal;
    sliderX=ceil(map(value,min,max,x-w/2,x+w/2));
  }
  
  void render(){
    fill(80);
    rect(x,height-50,w,h,90);
    fill(155);
    ellipse(sliderX,height-50,25,25);
  }
  
  void update(){
    if(overRect(mouseX,mouseY,x,height-50,w,h)){
      sliderX=mouseX;
    }
    sliderX=constrain(sliderX,x-w/2,x+w/2);
    value=map(sliderX,x-w/2,x+w/2,min,max);
  }
  
  void setValues(float newMin,float newMax,float newValue){
    max=newMax;
    min=newMin;
    value=newValue;
    sliderX=ceil(map(value,min,max,x-w/2,x+w/2));
  }
  
  float getValue(){
    return value;
  }
}

