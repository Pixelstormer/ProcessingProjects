class barrier{
  int health=10000;
  int x,y;
  boolean dead=false;
  
  barrier(int X,int Y){
    x=X;
    y=Y;
  }
  
  void update(){
    if(health<=0){
      dead=true;
    }
  }
  
  void render(){
    if(!(dead)){
      noTint();
      image(barrier,x,y,50,44);
    }
  }
}

