class slider{
  int x,y,minValue,maxValue,size;
  float currentValue;
  
  slider(int X,int Y,int MinValue,int MaxValue,int Size){
    x=X;
    y=Y;
    minValue=MinValue;
    maxValue=MaxValue;
    currentValue=minValue;
    size=Size;
  }
  
  void update(int value){
    currentValue=map(value,y-size/2,y+size/2,minValue,maxValue);
    currentValue=constrain(currentValue,minValue,maxValue);
  }
  
  float getValue(){
    return currentValue;
  }
  
  void render(){
    noStroke();
    fill(135);
    rect(x-7.5,y-size/2,15,size,90);
    fill(200);
    ellipse(x,map(currentValue,minValue,maxValue,y-size/2,y+size/2),25,25);
  }
}


