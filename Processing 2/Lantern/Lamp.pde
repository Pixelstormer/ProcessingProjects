class Lamp{
  float x,y;
  float range;
  float opacity;
  
  Lamp(float x_,float y_,float range_){
    x=x_;
    y=y_;
    range=range_;
  }
  
  void render(){
    noStroke();
    for(int i=0;i<5;i++){
      float noise=map(noise(x,y,time),0,1,-45,45);
      float random=random(-8,8);
      opacity=map(i,0,5,80,0)+random+shadowTimer/10;
      float radius=map(i,0,5,20,range)+noise;
      fill(240,230,0,opacity);
      ellipse(x,y,radius,radius);
    }
    fill(255,opacity+20);
    ellipse(x,y,15,15);
  }
}

