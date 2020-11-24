class Objective implements GameObject{
  private PVector position;
  private float size;
  private float period;
  
  Objective(PVector position, float size){
    this.position = position.get();
    this.size = size;
    this.period = 0;
    
    displayName = "OBJECTIVE";
    do{
      
    }
    while(game.findById(id)!=null);
  }
  
  PVector position(){
    return this.position.get();
  }
  
  float size(){
    return this.size;
  }
  
  void iterate(){
    render();
  }
  
  void reposition(){
    this.position.set(random(size+2,width-size-2), random(size+2,height-size-2));
  }
  
  private void render(){
    pushMatrix();
    this.period += OBJECTIVE_ROTATION_INDEX;
    translate(position.x,position.y);
    float angle = map(noise(position.x,position.y,period),0,1,0,TWO_PI);
    stroke(255);
    strokeWeight(4);
    noFill();
    triangle(size*cos(angle),size*sin(angle),
             size*cos(angle+TWO_PI/3.0),size*sin(angle+TWO_PI/3.0),
             size*cos(angle+TWO_PI/1.5),size*sin(angle+TWO_PI/1.5));
    popMatrix();
  }
}

