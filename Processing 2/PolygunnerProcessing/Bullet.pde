class Bullet{
  PVector pos,dir;
  int life;
  
  Bullet(PVector o,PVector d){
    pos=o.get();
    dir=d.get();
    dir.setMag(15);
    life=240;
  }
  
  void update(){
    pos.add(dir);
    life--;
    if(life<=0){
      toRemove.add(this);
    }
  }
  
  void render(){
    pushMatrix();
    translate(pos.x,pos.y);
    rotate(dir.heading());
    fill(255);
    rect(0,0,10,5);
    popMatrix();
  }
}

