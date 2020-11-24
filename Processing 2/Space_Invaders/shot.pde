class shot{
  int x,y;
  boolean isPlayer=true;
  
  shot(int X, int Y){
    x=X;
    y=Y;
  }
  
  void move(){
    y-=10;
  }
  
  void render(){
    fill(255);
    rect(x,y,6,16);
  }
  
  void checkCollision(){
    for (int X=0; X<aliensInRow; X++) {
      for (int Y=0; Y<aliensInColumn; Y++) {
        if(overRect(x,y,invaders[X][Y].x,invaders[X][Y].y,32,44) && !(invaders[X][Y].dead)){
          toRemove.add(this);
          invaders[X][Y].dead=true;
          interval-=ceil(maxInterval/(aliensInRow*aliensInColumn));
          score+=1000*(float(level)/2);
          pollUFO();
        }
      }
    }
    
    if(overRect(x,y,ufo.x,width-width/1.05,64,28)){
      ufo.getHit();
      toRemove.add(this);
    }
  }
  
  void checkBarriers(){
    if(overRect(x,y,left.x,left.y,50,44)&&!(left.dead)){
      barrier.loadPixels();
      int leftX=x-(left.x-25);
      int leftY=y-(left.y-22);
      barrier.pixels[leftY*barrier.width+leftX]=color(255);
      
      barrier.updatePixels();
      
      left.health--;
      toRemove.add(this);
    }
    if(overRect(x,y,middle.x,middle.y,50,44)&&!(middle.dead)){
      middle.health--;
      toRemove.add(this);
    }
    if(overRect(x,y,right.x,right.y,50,44)&&!(right.dead)){
      right.health--;
      toRemove.add(this);
    }
  }
}

