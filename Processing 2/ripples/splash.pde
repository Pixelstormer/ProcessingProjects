class splash{
  float x,y;
  float size;
  float life;
  
  splash(float x_,float y_,float size_){
    x=x_;
    y=y_;
    size=size_;
  }
  
  void render(){
    float cSize=map(life,0,255,0,size);
    stroke(#83C2FF,map(life,0,255,200,0));
    ellipse(x,y,cSize,cSize);
    life++;
  }
}
