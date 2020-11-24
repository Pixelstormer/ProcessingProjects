class Launcher{
  PVector location;
  float interval;
  float lastInterval;
  Launcher(PVector location, float interval){
    this.location = location.get();
    this.interval = interval;
    lastInterval = millis();
  }
  
  void update(){
    if(millis()-lastInterval>=interval){
      launch();
      lastInterval = millis();
    }
  }
  
  void launch(){
    activeRockets.add(new Firework(new PVector(location.x,location.y)));
  }
  
  void move(PVector n){
    location = n.get();
  }
  
  void render(){
    fill(0);
    stroke(255);
    strokeWeight(3);
    rect(location.x,location.y,25,25);
  }
}
