boolean running;

PVector loc;
float angle;
final float speed = 1;
final float speed2 = 4;
final float radius = 180;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  running = true;
  angle = 0;
  loc = new PVector(width/2-radius,height/2);
  
  thread("spin");
  
  background(0);
}

void draw(){
  background(0);
  
  PVector p = PVector.sub(new PVector(mouseX,mouseY),loc);
  p.setMag(speed2);
  loc.add(p);
  
  pushMatrix();
  translate(width/2,height/2);
  rotate(radians(angle));
  
  fill(255);
  noStroke();
  ellipse(radius,radius,25,25);
  popMatrix();
  
  noFill();
  stroke(255);
  strokeWeight(4);
  ellipse(loc.x,loc.y,25,25);
}

void spin(){
  float timer = millis();
  float interval = 16.6;
  while(true){
    if(running){
      if(millis()-timer>interval){
        angle+=speed;
        timer = millis();
      }
    }
  }
}

void keyPressed(){
  running = !running;
}



