ArrayList<ball> balls = new ArrayList<ball>();

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  balls.add(new ball(new PVector(width/2,height/2),new PVector(random(-10,10),random(-10,10)),1.02,int(random(200))));
}

void draw(){
  background(0);
  
  for(ball b : balls){
    b.update();
    for(ball other : balls){
      b.collide(other);
    }
    b.renderLines();
  }
  for(ball b : balls){
    b.renderBall();
    b.connected.removeAll(b.toRemove);
  }
}

void mousePressed(){
  balls.add(new ball(new PVector(mouseX,mouseY),new PVector(random(-10,10),random(-10,10)),1.02,int(random(200))));
}


