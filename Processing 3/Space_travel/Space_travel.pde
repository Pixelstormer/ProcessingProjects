PVector center;
int Stars = 1000;
Star[] stars = new Star[Stars];

void setup(){
  size(840,560);
  background(0);
  surface.setResizable(true);
  center = new PVector(width/2,height/2);
  
  fill(255);
  noStroke();
  
  for(int i=0;i<Stars;i++){
    stars[i] = new Star(new PVector(random(width),random(height)));
  }
}

void draw(){
  fill(0,64);
  rect(0,0,width,height);
  fill(255);
  center = new PVector(width/2,height/2,0);
  for(Star s : stars){
    s.update();
    s.render();
  }
}