 class Player{
  PVector pos,dir;
  float spd;
  Hammer hammer;
  
  Player(PVector o,float s){
    pos=o.get();
    dir=new PVector(0,0);
    spd=s;
    hammer=new Hammer();
  }
  
  void update(){
    dir.lerp(new PVector((a[3]-a[2])*spd,(a[1]-a[0])*spd),0.8);
    pos.add(dir);
    hammer.cooldown();
  }
  
  void render(){
    fill(200);
    noStroke();
    rect(pos.x,pos.y,15,15);
  }
  
  void renderCursor(){
    noCursor();
    fill(255,100);
    stroke(255,100);
    strokeWeight(2);
    point(mouseX,mouseY);
    strokeWeight(1);
    beginShape(LINES);
    vertex(mouseX,mouseY+5);
    vertex(mouseX,mouseY+10);
    
    vertex(mouseX+5,mouseY);
    vertex(mouseX+10,mouseY);
    
    vertex(mouseX,mouseY-5);
    vertex(mouseX,mouseY-10);
    
    vertex(mouseX-5,mouseY);
    vertex(mouseX-10,mouseY);
    endShape();
  }
  
  void switchHammer(int h){
    hammer.setHammer(h);
  }
  
  void fire(){
    hammer.trigger(pos);
  }
}

