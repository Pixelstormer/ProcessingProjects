Cloud c;

void setup(){
  size(840,560);
  frame.setResizable(true);
  
  c = new Cloud(300,200, 1,0,0.5,new PVector(0,0),12,0.2,0.01);
}

void draw(){
  background(0);
  loadPixels();
  
  c.Update();
  c.Render();
  
  updatePixels();
}


