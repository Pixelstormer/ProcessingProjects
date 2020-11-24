class car{
  float x,y;
  float speed=0;
  int rotation=0;
  PImage sprite;
  
  int lastWaypointIndex=0;
  int laps=0;
  
  car(float X,float Y,PImage Sprite){
    x=X;
    y=Y;
    rotation=180;
    sprite=Sprite;
  }
  
  void move(){
    speed=constrain(speed,-8,8);
    
    applyDrag(0.05);
    
    if(rotation>360){
      rotation= 0;
    }
    else if(rotation< 0){
      rotation=360;
    }
    
    x=speed*cos(radians(rotation))+x;
    y=speed*sin(radians(rotation))+y;
    
    x=constrain(x,0,width);
    y=constrain(y,0,height);
  }
  
  void applyDrag(float amt){
    if(speed!=0){
      if(abs(speed)!=speed){
        speed+=amt;
      }
      else{
        speed-=amt;
      }
    }
  }
  
  void checkWayPoints(){
    PVector position=new PVector(x,y);
    if(lastWaypointIndex!=Track.points.size()-1){
      for(int i=1;i<Track.points.size();i++){
        if(position.dist(Track.points.get(i).location)<116&&Track.points.get(i-1).location==Track.points.get(lastWaypointIndex).location){
          lastWaypointIndex=i;
        }
      }
    }
    else if(position.dist(Track.points.get(0).location)<116){
      lastWaypointIndex=0;
      laps++;
    }
    if(debug){
      line(x,y,Track.points.get(lastWaypointIndex).location.x,Track.points.get(lastWaypointIndex).location.y);
    }
  }
  
  void render(){
    pushMatrix();
    translate(x,y);
    rotate(radians(rotation));
    image(sprite,0,0,45,45);
    popMatrix();
    fill(255);
    textSize(16);
    text(laps,x,y-55);
  }
}

