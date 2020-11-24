class Tank{
  PVector location;
  int index;
  
  Tank(){
    location=new PVector(ground[24].x,ground[24].y);
    index=24;
  }
  
  void update(){
    if(keyPressed){
      switch(key){
        case 'd':
        case 'D':
          index++;
          break;
        case 'a':
        case 'A':
          index--;
      }
    }
    
    index=constrain(index,0,ground.length-1);
    
    location.x=ground[index].x;
    
    location.x=constrain(location.x,ground[0].x,ground[ground.length-1].x);
    
    location.y=ground[index].y;
  }
  
  void render(){
    noFill();
    stroke(255);
    rect(location.x,location.y,15,15);
  }
}


